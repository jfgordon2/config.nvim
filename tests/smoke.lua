-- Run after VimEnter with the real configuration and independent test data.
local results = {}
local function check(condition, message)
    assert(condition, message)
    results[#results + 1] = message
end
local function read_json(path)
    return vim.json.decode(table.concat(vim.fn.readfile(path), '\n'))
end
local function run()
    local data = vim.fn.stdpath 'data'
    local config = vim.fn.stdpath 'config'
    check(config:match '/nvim%-pack%-test$', 'configuration is isolated')
    check(data:match '/nvim%-pack%-test$', 'data is isolated')
    check(vim.env.MASON == data .. '/mason', 'Mason is isolated')
    check(not package.loaded.lazy and not package.loaded['lazy.core.config'], 'Lazy is not loaded')
    check(vim.o.loadplugins, 'native plugin loading remains enabled')
    local plugins = vim.pack.get(nil, { info = false })
    check(#plugins == #require 'config.packages', 'the native inventory matches the configured repositories')
    for _, plugin in ipairs(plugins) do
        assert(plugin.active and vim.startswith(plugin.path, data .. '/site/pack/core/opt/'), plugin.spec.name)
    end
    local lock = read_json(config .. '/nvim-pack-lock.json')
    for _, plugin in ipairs(plugins) do
        local head = vim.system({ 'git', '-C', plugin.path, 'rev-parse', 'HEAD' }, { text = true }):wait()
        assert(head.code == 0 and vim.trim(head.stdout) == lock.plugins[plugin.spec.name].rev, 'lockfile mismatch: ' .. plugin.spec.name)
    end
    check(true, 'the native lockfile matches the installed Git revisions')
    check(not vim.lsp.is_enabled 'rust_analyzer', 'Rustaceanvim is the sole Rust LSP owner')
    check(not package.loaded.ibl and not package.loaded.neoscroll, 'duplicate indent and scroll plugins are absent')
    check(Snacks.config.indent.enabled and Snacks.config.scroll.enabled, 'Snacks provides indentation and scrolling')
    check(debug.getinfo(require('mini.icons').setup).source:find('/mini.nvim/', 1, true), 'icons come from the existing mini.nvim repository')
    local lint = require 'lint'
    check(not vim.tbl_contains(lint._resolve_linter_by_ft 'python', 'ruff'), 'Ruff diagnostics use LSP only')
    check(not vim.tbl_contains(lint._resolve_linter_by_ft 'javascript', 'biomejs'), 'Biome diagnostics use LSP only')
    check(not vim.tbl_contains(lint._resolve_linter_by_ft 'text', 'vale'), 'Vale diagnostics use LSP only')
    local buffers = require 'config.buffers'
    check(vim.fn.maparg('<leader>bo', 'n', false, true).callback == buffers.others, 'one shared delete-other-buffers action owns the mapping')
    check(vim.fn.maparg('<leader>bd', 'n', false, true).callback == buffers.delete, 'buffer deletion uses the shared action')

    local commands = {
        'PackUpdate',
        'PackStatus',
        'PackRestore',
        'PackBuild',
        'Telescope',
        'ConformInfo',
        'Neotree',
        'Trouble',
        'Copilot',
        'CopilotSignin',
        'GHNotifications',
        'MdPick',
        'VimCoach',
        'TSUpdate',
    }
    for _, command in ipairs(commands) do
        assert(vim.fn.exists(':' .. command) == 2, 'missing command ' .. command)
    end
    check(true, 'native and plugin commands are registered')
    check(vim.g.colors_name and vim.g.colors_name:match '^tokyonight', 'Tokyo Night is active')
    check(vim.fn.exists '#kickstart-highlight-yank#TextYankPost' == 1, 'global autocommands are registered')
    check(vim.fn.exists '#nvim-lint#BufWritePost' == 1, 'linting is ready before first write')
    check(vim.fn.exists '#Conform#BufWritePre' == 1, 'formatting is ready before first write')
    check(vim.fn.exists '#persistence#BufReadPre' == 1 or package.loaded.persistence ~= nil, 'session setup is ready')

    local filetype = vim.bo.filetype
    check(filetype == vim.env.NVIM_PACK_EXPECT_FT, 'first file detected as ' .. filetype)
    check(vim.treesitter.get_parser(0):parse()[1] ~= nil, 'first file has a working parser')
    check(vim.bo.indentexpr:find 'nvim%-treesitter' ~= nil, 'Tree-sitter indentation is enabled on first file')

    local expected = read_json(vim.env.NVIM_PACK_EXPECTED_MAPS)
    for _, key in ipairs(expected) do
        if key.ft == nil or key.ft == filetype then
            local modes = type(key.mode) == 'table' and key.mode or { key.mode == '' and 'n' or key.mode }
            for _, mode in ipairs(modes) do
                assert(next(vim.fn.maparg(key.lhs, mode, false, true)), 'missing mapping ' .. key.lhs .. ' (' .. mode .. ')')
            end
        end
    end
    if filetype == 'python' then
        check(vim.fn.maparg('<leader>cv', 'n', false, true).buffer == 1, 'Python venv mapping is buffer-local')
    else
        check(not next(vim.fn.maparg('<leader>cv', 'n', false, true)), 'Python venv mapping does not leak to other filetypes')
    end
    check(true, 'all applicable original spec mappings exist')

    local compile = require 'luasnip.util.jsregexp'
    check(type(compile) == 'function' and compile('^snippet$', '') ~= nil, 'LuaSnip native jsregexp compiles expressions')
    check(require('blink.cmp.fuzzy').implementation_type == 'rust', 'Blink uses the prebuilt Rust matcher')
    check(require('telescope').extensions.fzf ~= nil, 'Telescope native sorter loads')
    check(require('telescope').extensions.file_browser ~= nil, 'Telescope file browser loads')
    check(require('dap').adapters.python ~= nil, 'Python debugger is configured')
    check(require('dap').adapters.go ~= nil, 'Go debugger is configured')
    check(vim.lsp.is_enabled 'lua_ls' and vim.lsp.is_enabled 'basedpyright', 'language servers are enabled')

    local server = ({ lua = 'lua_ls', python = 'basedpyright', typescript = 'typescript-tools', rust = 'rust-analyzer' })[filetype]
    local attached = vim.wait(20000, function()
        for _, client in ipairs(vim.lsp.get_clients { bufnr = 0, name = server }) do
            if client.initialized then
                return true
            end
        end
        return false
    end, 100)
    check(attached, server .. ' initializes and attaches to the first file')
    if filetype == 'rust' then
        check(#vim.lsp.get_clients { bufnr = 0, name = 'rust-analyzer' } == 1, 'exactly one Rust server attaches')
    end
    if filetype == 'lua' then
        vim.api.nvim_buf_set_lines(0, 0, -1, false, { 'local answer={1,2,3}', 'return answer' })
        vim.cmd.write()
        check(vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] == 'local answer = { 1, 2, 3 }', 'first save runs the real Lua formatter')
    end
    vim.fn.writefile(results, assert(vim.env.NVIM_PACK_TEST_RESULT))
    print(('PASS: %d integration checks (%s)'):format(#results, filetype))
end

vim.defer_fn(function()
    local ok, error_message = xpcall(run, debug.traceback)
    if not ok then
        vim.fn.writefile({ error_message }, assert(vim.env.NVIM_PACK_TEST_RESULT))
        io.stderr:write(error_message .. '\n')
        vim.cmd 'cquit 1'
    else
        vim.cmd 'qa!'
    end
end, 1500)
