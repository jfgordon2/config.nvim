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
    },
    opts = {
        notify_on_error = false,
        format_on_save = function(bufnr)
            -- Disable "format_on_save lsp_fallback" for languages that don't
            -- have a well standardized coding style. You can add additional
            -- languages here or re-enable it for the disabled ones.
            local disable_filetypes = { c = true, cpp = true }
            local lsp_format_opt
            if disable_filetypes[vim.bo[bufnr].filetype] then
                lsp_format_opt = 'never'
            else
                lsp_format_opt = 'fallback'
            end
            return {
                timeout_ms = 500,
                lsp_format = lsp_format_opt,
            }
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
            ['*'] = { 'codespell' },
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
                prepend_args = { 'format', '--indent-style=space', '--indent-size=4', '--line-width=99' },
            },
        },
    },
}
