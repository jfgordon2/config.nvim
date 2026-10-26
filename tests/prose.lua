local function run()
    local lint = require 'lint'
    local configured = vim.env.TEST_VALE_CONFIGURED == '1'
    if vim.bo.filetype == 'markdown' then
        assert(vim.fn.executable 'markdownlint' == 1, 'markdownlint is unavailable')
        assert(
            vim.wait(10000, function()
                return #vim.diagnostic.get(0, { namespace = lint.get_namespace 'markdownlint' }) > 0
            end, 100),
            'Markdown diagnostics were not produced'
        )
    end
    assert(not vim.tbl_contains(lint._resolve_linter_by_ft 'text', 'vale'), 'duplicate Vale CLI diagnostics')
    if configured then
        assert(
            vim.wait(15000, function()
                for _, client in ipairs(vim.lsp.get_clients { bufnr = 0, name = 'vale_ls' }) do
                    if client.initialized then
                        return true
                    end
                end
                return false
            end, 100),
            'Vale failed to attach in a configured project'
        )
        assert(
            vim.wait(10000, function()
                for _, diagnostic in ipairs(vim.diagnostic.get(0)) do
                    if diagnostic.message:find('Avoid badword', 1, true) then
                        return true
                    end
                end
                return false
            end, 100),
            'Vale did not report the project rule'
        )
        local count = 0
        for _, diagnostic in ipairs(vim.diagnostic.get(0)) do
            if diagnostic.message:find('Avoid badword', 1, true) then
                count = count + 1
            end
        end
        assert(count == 1, 'Vale published duplicate diagnostics')
    else
        vim.wait(1500, function()
            return false
        end, 100)
        assert(#vim.lsp.get_clients { bufnr = 0, name = 'vale_ls' } == 0, 'Vale attached without .vale.ini')
    end
    for _, message in ipairs(_G.buffer_test_notifications) do
        assert(not message:find 'ENOENT' and not message:find 'no config file found', message)
    end
    assert(vim.v.errmsg == '', vim.v.errmsg)
    print 'PASS: prose diagnostics, configuration discovery, and no duplicate Vale reports'
end
vim.defer_fn(function()
    local ok, err = xpcall(run, debug.traceback)
    if not ok then
        io.stderr:write(err .. '\n')
        vim.cmd 'cquit 1'
    else
        vim.cmd 'qa!'
    end
end, 500)
