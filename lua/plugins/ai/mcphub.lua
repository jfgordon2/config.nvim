return {
    'ravitemer/mcphub.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-treesitter/nvim-treesitter', -- Added for code analysis
    },
    build = 'npm install -g mcp-hub@latest',
    config = function()
        require('mcphub').setup {
            config = vim.fn.expand '$HOME/.config/mcphub/servers.json',
            auto_approve = true,
        }
        local mcphub = require 'mcphub'

        -- LSP Diagnostics Resource
        mcphub.add_resource('neovim', {
            name = 'Diagnostics: Current File',
            description = 'Get diagnostics for current file',
            uri = 'neovim://diagnostics/current',
            mimeType = 'text/plain',
            handler = function(req, res)
                local buf_info = req.editor_info.last_active
                if not buf_info then
                    return res:error 'No active buffer'
                end

                local diagnostics = vim.diagnostic.get(buf_info.bufnr)
                local text = string.format('Diagnostics for: %s\n%s\n', buf_info.filename, string.rep('-', 40))

                for _, diag in ipairs(diagnostics) do
                    local severity = vim.diagnostic.severity[diag.severity]
                    text = text .. string.format('\n%s: Line %d - %s\n', severity, diag.lnum + 1, diag.message)
                end

                return res:text(text):send()
            end,
        })

        -- Documentation Resource
        mcphub.add_resource_template('docs', {
            name = 'Code Documentation',
            description = 'Get documentation for code symbols',
            uriTemplate = 'docs://{language}/{symbol}',
            mimeType = 'text/plain',
            handler = function(req, res)
                local params = req.params
                local lsp_clients = vim.lsp.get_clients()

                if #lsp_clients == 0 then
                    return res:error 'No LSP clients active'
                end

                local buf = vim.api.nvim_get_current_buf()
                local response = ''

                vim.lsp.buf_request_sync(buf, 'textDocument/hover', {
                    textDocument = { uri = vim.uri_from_bufnr(buf) },
                    position = { line = 0, character = 0 },
                }, 1000)

                if response == '' then
                    response = string.format('No documentation found for %s in %s', params.symbol, params.language)
                end

                return res:text(response):send()
            end,
        })
    end,
}
