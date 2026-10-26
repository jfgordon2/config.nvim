local icons = require 'config.icons'

-- LSP Plugins

return function()
    require('fidget').setup {}
    -- Rustaceanvim owns Rust; share completion capabilities with the other servers.
    vim.g.rustaceanvim = { server = { capabilities = require('blink.cmp').get_lsp_capabilities() } }
    do -- folke/lazydev.nvim
        local opts = {
            library = {
                { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
            },
        }
        require('lazydev').setup(opts)
    end
    do -- neovim/nvim-lspconfig
        local opts = {
            servers = require('config.tools').servers,
        }
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
            callback = function(event)
                local map = function(keys, func, desc, mode)
                    mode = mode or 'n'
                    vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = desc })
                end

                -- Jump to the definition of the word under your cursor.
                --  This is where a variable was first declared, or where a function is defined, etc.
                --  To jump back, press <C-t>.
                map('grd', require('telescope.builtin').lsp_definitions, 'Go to definition')

                -- Find references for the word under your cursor.
                map('grr', require('telescope.builtin').lsp_references, 'Find references')

                -- Jump to the implementation of the word under your cursor.
                --  Useful when your language has ways of declaring types without an actual implementation.
                map('gri', require('telescope.builtin').lsp_implementations, 'Go to implementation')

                -- Jump to the type of the word under your cursor.
                --  Useful when you're not sure what type a variable is and you want to see
                --  the definition of its *type*, not where it was *defined*.
                map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Go to type definition')
                map('grt', require('telescope.builtin').lsp_type_definitions, 'Go to type definition')

                -- Fuzzy find all the symbols in your current document.
                --  Symbols are things like variables, functions, types, etc.
                map('<leader>ds', require('telescope.builtin').lsp_document_symbols, 'Find document symbols')
                map('grO', require('telescope.builtin').lsp_document_symbols, 'Find document symbols')

                -- Fuzzy find all the symbols in your current workspace.
                --  Similar to document symbols, except searches over your entire project.
                map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Find workspace symbols')
                map('grW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Find workspace symbols')

                -- Rename the variable under your cursor.
                --  Most Language Servers support renaming across files, etc.
                map('<leader>rn', vim.lsp.buf.rename, 'Rename symbol')
                map('grn', vim.lsp.buf.rename, 'Rename symbol')

                local code_actions = function()
                    require('fzf-lua.providers.lsp').code_actions {
                        prompt = '❯ ',
                        winopts = { height = 0.3, width = 0.5, title = 'Code Actions', preview = { wrap = true } },
                        silent = true,
                    }
                end
                map('<leader>ca', code_actions, 'Show code actions', { 'n', 'x' })
                map('gra', code_actions, 'Show code actions', { 'n', 'x' })
                -- WARN: This is not Goto Definition, this is Goto Declaration.
                --  For example, in C this would take you to the header.
                map('grD', vim.lsp.buf.declaration, 'Go to declaration')

                local client = vim.lsp.get_client_by_id(event.data.client_id)
                ---@diagnostic disable-next-line: param-type-mismatch, missing-parameter
                if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
                    local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
                    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.document_highlight,
                    })

                    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.clear_references,
                    })

                    vim.api.nvim_create_autocmd('LspDetach', {
                        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
                        callback = function(event2)
                            vim.lsp.buf.clear_references()
                            vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
                        end,
                    })
                end

                if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
                    map('<leader>th', function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
                    end, 'Toggle inlay hints')
                end
            end,
        })

        -- Change diagnostic symbols in the sign column (gutter)
        if vim.g.have_nerd_font then
            local signs = {
                ERROR = icons.diagnostics.Error,
                WARN = icons.diagnostics.Warn,
                INFO = icons.diagnostics.Info,
                HINT = icons.diagnostics.Hint,
            }
            local diagnostic_signs = {}
            for type, icon in pairs(signs) do
                diagnostic_signs[vim.diagnostic.severity[type]] = icon
            end
            vim.diagnostic.config {
                signs = { text = diagnostic_signs },
                virtual_text = {
                    prefix = icons.misc.circle,
                    source = true,
                    format = function(diagnostic)
                        return string.format('%s %s', diagnostic.message, diagnostic.source and '(' .. diagnostic.source .. ')' or '')
                    end,
                },
                float = {
                    source = true,
                    border = 'rounded',
                },
                severity_sort = true,
                update_in_insert = false,
            }
            vim.keymap.set('n', '<leader>xS', function()
                local diag_opts = {
                    focusable = false,
                    close_events = { 'BufLeave', 'CursorMoved', 'InsertEnter', 'FocusLost' },
                    border = 'rounded',
                    source = 'always',
                    prefix = ' ',
                    scope = 'cursor',
                }
                vim.diagnostic.open_float(nil, diag_opts)
            end, { desc = 'Show diagnostic at cursor' })
        end

        for server, config in pairs(opts.servers) do
            config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
            vim.lsp.config(server, config)
            vim.lsp.enable(server)
        end
    end
    do -- pmizio/typescript-tools.nvim
        local opts = {}
        require('typescript-tools').setup(opts)
    end
end
