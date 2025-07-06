return {
    'Davidyz/VectorCode',
    version = '*',
    build = "uv tool upgrade 'vectorcode[lsp,mcp]'",
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = 'VectorCode',
    ---@type VectorCode.Opts
    opts = {
        cli_cmds = {
            vectorcode = 'vectorcode',
        },
        ---@type VectorCode.RegisterOpts
        async_opts = {
            debounce = 10,
            events = { 'BufWritePost', 'InsertEnter', 'BufReadPost' },
            exclude_this = true,
            n_query = 1,
            notify = false,
            query_cb = require('vectorcode.utils').make_surrounding_lines_cb(-1),
            run_on_register = false,
        },
        async_backend = 'lsp', -- or "default"
        exclude_this = true,
        n_query = 1,
        notify = true,
        timeout_ms = 5000,
        on_setup = {
            update = false, -- set to true to enable update when `setup` is called.
            lsp = false,
        },
        sync_log_env_var = false,
    },
}
