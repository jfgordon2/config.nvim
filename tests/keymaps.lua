local function mapping(lhs, mode)
    local value = vim.fn.maparg(lhs, mode or 'n', false, true)
    assert(next(value), 'missing mapping: ' .. lhs)
    return value
end

local function invoke(lhs)
    local callback = assert(mapping(lhs).callback, 'expected Lua callback: ' .. lhs)
    return callback()
end

local function run()
    local buf = vim.api.nvim_get_current_buf()
    local path = vim.api.nvim_buf_get_name(buf)
    local root = assert(vim.uv.fs_realpath(assert(vim.env.KEYMAP_TEST_ROOT)))
    assert(
        vim.wait(15000, function()
            return vim.fn.maparg('grd', 'n', false, true).buffer == 1 and vim.b.gitsigns_head ~= nil
        end, 100),
        'LSP and Git mappings did not attach'
    )

    local expected = vim.json.decode(table.concat(vim.fn.readfile(vim.fn.stdpath 'config' .. '/tests/keymap-descriptions.json'), '\n'))
    for _, item in ipairs(expected) do
        if item.context ~= 'python' then
            assert(mapping(item.lhs, item.mode).desc == item.desc, item.lhs .. ': unexpected description')
        end
    end
    for _, lhs in ipairs { '<leader>tS', '<leader>ts', '<leader>ti', '<leader>tD', '<leader>sB', '<leader>ww', '<leader>ng', '<leader>gu' } do
        for _, mode in ipairs { 'n', 'x' } do
            assert(not next(vim.fn.maparg(lhs, mode, false, true)), 'retired mapping remains: ' .. lhs)
        end
    end
    local groups = {}
    for _, item in ipairs(require('which-key.config').mappings) do
        if item.group and not item.buffer and item.mode == 'n' then
            groups[item.lhs] = item.desc
        end
        assert(not (item.group and item.desc == 'Notebook' and not item.buffer), 'notebook group must be buffer-local')
    end
    for lhs, name in pairs {
        a = 'AI',
        b = 'Buffers',
        B = 'Debug',
        c = 'Code',
        d = 'Document',
        e = 'Explorer',
        g = 'Git',
        h = 'Help',
        m = 'Markdown',
        n = 'Notifications',
        N = 'Tests',
        q = 'Sessions',
        r = 'Refactor',
        s = 'Search',
        t = 'Toggles',
        u = 'Utilities',
        v = 'Terminals',
        w = 'Workspace',
        x = 'Diagnostics and lists',
    } do
        assert(groups['<leader>' .. lhs] == name, 'missing or incorrect group: ' .. lhs)
    end

    -- Exercise directory selection without opening a picker or explorer window.
    local command = require 'neo-tree.command'
    local execute, captured = command.execute
    command.execute = function(opts)
        captured = opts
    end
    vim.cmd.lcd(vim.fn.fnameescape(root .. '/cwd dir'))
    invoke '<leader>ee'
    assert(captured.dir == root, 'ee must use the current file Git root')
    invoke '<leader>eE'
    assert(captured.dir == root .. '/cwd dir', 'eE must use cwd')
    local browser = require('telescope').extensions.file_browser
    local pick, directory = browser.file_browser
    browser.file_browser = function(opts)
        directory = opts.path
    end
    invoke '<leader>ef'
    assert(directory == vim.fs.dirname(path), 'file browser must use the buffer directory, including spaces')
    browser.file_browser = pick
    vim.cmd.edit(vim.fn.fnameescape(root .. '/../outside.lua'))
    vim.cmd.lcd(vim.fn.fnameescape(root .. '/cwd dir'))
    invoke '<leader>ee'
    assert(captured.dir == root .. '/cwd dir', 'ee must fall back to cwd outside Git')
    command.execute = execute
    vim.api.nvim_set_current_buf(buf)

    local dapui, dap = require 'dapui', require 'dap'
    local toggle, toggled = dapui.toggle, 0
    dapui.toggle = function()
        toggled = toggled + 1
    end
    invoke '<F7>'
    invoke '<leader>B<F7>'
    assert(toggled == 2, 'F7 mappings must toggle the debug UI')
    dapui.toggle = toggle
    local breakpoint, input, condition = dap.set_breakpoint, vim.fn.input
    dap.set_breakpoint = function(value)
        condition = value
    end
    vim.fn.input = function()
        return 'value == 42'
    end
    invoke '<leader>BB'
    assert(condition == 'value == 42', 'BB must set a conditional breakpoint')
    dap.set_breakpoint, vim.fn.input = breakpoint, input
    local diagnostic = vim.diagnostic.is_enabled()
    invoke '<leader>tt'
    assert(vim.diagnostic.is_enabled() ~= diagnostic, 'tt must toggle diagnostics')
    invoke '<leader>tt'
    local open_float, scope = vim.diagnostic.open_float
    vim.diagnostic.open_float = function(_, opts)
        scope = opts.scope
    end
    invoke '<leader>xS'
    assert(scope == 'cursor', 'xS must show cursor diagnostics')
    vim.diagnostic.open_float = open_float
    local namespace = vim.api.nvim_create_namespace 'keymap-test'
    vim.diagnostic.set(namespace, buf, { { lnum = 0, col = 0, message = 'location-list test' } })
    invoke '<leader>xq'
    assert(#vim.fn.getloclist(0) > 0, 'xq must populate the location list')
    vim.cmd 'lclose'
    vim.diagnostic.reset(namespace)
    vim.api.nvim_set_current_buf(buf)

    local function keys(value)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(value, true, false, true), 'xt', false)
    end
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { 'call(1, 2)' })
    vim.bo.shiftwidth, vim.bo.expandtab = 2, true
    vim.api.nvim_win_set_cursor(0, { 1, 5 })
    keys ' cJ'
    assert(vim.api.nvim_buf_line_count(buf) > 1, 'cJ must split arguments')
    keys ' cJ'
    assert(vim.api.nvim_buf_get_lines(buf, 0, -1, false)[1] == 'call(1, 2)', 'cJ must join arguments')
    keys 'V cJ'
    assert(vim.api.nvim_buf_line_count(buf) > 1, 'visual cJ must split arguments')
    assert(vim.v.errmsg == '', vim.v.errmsg)
    print 'PASS: approved descriptions/groups, retired keys, explorer paths, debug/diagnostic actions and split/join'
end

vim.defer_fn(function()
    local ok, err = xpcall(run, debug.traceback)
    if not ok then
        io.stderr:write(err .. '\n')
        vim.cmd 'cquit 1'
    else
        vim.cmd 'qa!'
    end
end, 700)
