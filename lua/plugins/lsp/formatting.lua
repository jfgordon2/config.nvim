return { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
        {
            '<leader>cf',
            function()
                require('conform').format { async = true, lsp_format = 'fallback' }
            end,
            mode = '',
            desc = '[C]ode: [F]ormat buffer',
        },
        {
            '<leader>cF',
            mode = '',
            desc = '[C]ode: List formatters to run',
            function()
                local curr_buf = vim.api.nvim_get_current_buf()
                local formatters = require('conform').list_formatters_to_run(curr_buf)
                local formatter_names = vim.tbl_map(function(f)
                    return type(f) == 'string' and f or f.name
                end, formatters)
                vim.notify('Formatters to run: ' .. table.concat(formatter_names, ', '), vim.log.levels.INFO, { title = 'Conform' })
            end,
        },
        {
            '<leader>tf',
            mode = '',
            desc = '[T]oggle: [F]ormat on save',
            function()
                if vim.g.disable_autoformat then
                    vim.g.disable_autoformat = false
                    vim.notify('Autoformat enabled', vim.log.levels.INFO, { title = 'Conform' })
                else
                    vim.g.disable_autoformat = true
                    vim.notify('Autoformat disabled', vim.log.levels.INFO, { title = 'Conform' })
                end
            end,
        },
    },
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
        timeout_ms = 3000,
        async = false,
        quiet = false,
        notify_on_error = true,
        format_on_save = function(bufnr)
            -- Disable "format_on_save lsp_fallback" for languages that don't
            -- have a well standardized coding style. You can add additional
            -- languages here or re-enable it for the disabled ones.
            local disable_filetypes = { c = true, cpp = true }
            if vim.g.disable_autoformat or disable_filetypes[vim.bo[bufnr].filetype] then
                return nil
            else
                return {
                    lsp_format = 'fallback',
                }
            end
        end,
        formatters_by_ft = {
            css = { 'biome' },
            fish = { 'fish_indent' },
            graphql = { 'biome' },
            go = { 'goimports', 'gofmt' },
            hcl = { 'terraform_fmt' },
            html = { 'biome' },
            lua = { 'stylua' },
            rust = { 'rustfmt', lsp_format = 'fallback' },
            javascript = { 'biome' },
            javascriptreact = { 'biome' },
            json = { 'biome' },
            jsonc = { 'biome' },
            markdown = { 'markdownlint-cli2' },
            ['markdown.mdx'] = { 'markdownlint-cli2' },
            mysql = { 'sqlfluff' },
            plsql = { 'sqlfluff' },
            python = function(bufnr)
                if require('conform').get_formatter_info('ruff_format', bufnr).available then
                    return { 'ruff_format', 'ruff_organize_imports' }
                else
                    return { 'isort', 'black' }
                end
            end,
            sh = { 'shfmt' },
            sql = { 'sqlfluff' },
            svelte = { 'biome' },
            terraform = { 'terraform_fmt' },
            ['terraform-vars'] = { 'terraform_fmt' },
            tf = { 'terraform_fmt' },
            toml = { 'taplo' },
            typescript = { 'biome' },
            typescriptreact = { 'biome' },
            vue = { 'biome' },
            yaml = { 'yamlfmt' },
            -- ['*'] = { 'codespell' },
            ['_'] = { 'trim_whitespace' },
        },
        -- The options you set here will be merged with the builtin formatters.
        -- You can also define any custom formatters here.
        ---@type table<string, conform.FormatterConfigOverride|fun(bufnr: integer): nil|conform.FormatterConfigOverride>
        formatters = {
            injected = { options = { ignore_errors = true } },
            taplo = {
                prepend_args = { 'format', '-o', 'indent_string=    ', '-' },
            },
            biome = {
                prepend_args = {
                    'format',
                    '--write',
                    '--indent-style=space',
                    '--indent-width=2',
                    '--jsx-quote-style=single',
                    '--javascript-formatter-quote-style=single',
                    '--css-formatter-quote-style=single',
                    '--graphql-formatter-quote-style=single',
                    '--semicolons=as-needed',
                    '--trailing-commas=none',
                    '--line-width=99',
                    '--html-formatter-enabled=true',
                    '--html-formatter-indent-style=space',
                    '--html-formatter-indent-width=2',
                    '--html-formatter-line-width=99',
                    '--html-formatter-indent-script-and-style=true',
                },
            },
            shfmt = {
                prepend_args = { '-i', '4', '-ci' },
            },
            yamlfmt = {
                prepend_args = {
                    '-formatter',
                    table.concat({
                        'drop_merge_tag=true',
                        'eof_newline=true',
                        'include_document_start=false',
                        'indent=2',
                        'pad_line_comments=2',
                        'retain_line_breaks_single=true',
                        'scan_folded_as_literal=true',
                        'trim_trailing_whitespace=true',
                    }, ','),
                },
            },
        },
    },
}
