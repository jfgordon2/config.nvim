-- LSP Plugins

return {
    {
        'folke/lazydev.nvim',
        ft = 'lua',
        cmd = 'LazyDev',
        opts = {
            library = {
                { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
            },
        },
    },
    {
        'mason-org/mason.nvim',
        opts = {
            ui = {
                icons = _G.LazyVim and _G.LazyVim.config and _G.LazyVim.config.icons and _G.LazyVim.config.icons.mason or {
                    package_installed = '𧻓',
                    package_pending = '𥳐',
                    package_uninstalled = '龎',
                },
            },
        },
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            { 'mason-org/mason.nvim', opts = {} },
            'williamboman/mason-lspconfig.nvim',
            'WhoIsSethDaniel/mason-tool-installer.nvim',
            { 'j-hui/fidget.nvim', opts = {} },
            'saghen/blink.cmp',
        },
        opts = {
            servers = {
                gopls = {},
                basedpyright = {},
                rust_analyzer = {},
                ansiblels = {},
                codeqlls = {},
                docker_compose_language_service = {},
                dockerls = {},
                bashls = {},
                tailwindcss = {},
                eslint = {},
                gh_actions_ls = {},
                htmx = {},
                taplo = {},
                jqls = {},
                biome = {
                    settings = {
                        json = {
                            format = {
                                enable = true,
                                defaultConfig = {
                                    indent_size = '4',
                                    indent_style = 'space',
                                },
                            },
                        },
                    },
                },
                ruff = {},
                terraformls = {},
                yamlls = {
                    settings = {
                        yaml = {
                            customTags = {
                                '!And sequence',
                                '!And',
                                '!And sequence',
                                '!If',
                                '!If sequence',
                                '!Not',
                                '!Not sequence',
                                '!Equals',
                                '!Equals sequence',
                                '!Or',
                                '!Or sequence',
                                '!FindInMap',
                                '!FindInMap sequence',
                                '!Base64',
                                '!Join',
                                '!Join sequence',
                                '!Cidr',
                                '!Ref',
                                '!Sub',
                                '!Sub sequence',
                                '!GetAtt',
                                '!GetAZs',
                                '!ImportValue',
                                '!ImportValue sequence',
                                '!Select',
                                '!Select sequence',
                                '!Split',
                                '!Split sequence',
                            },
                            schemas = {
                                ['https://raw.githubusercontent.com/kedro-org/kedro/develop/static/jsonschema/kedro-catalog-0.17.json'] = 'conf/**/*catalog*',
                                ['https://json.schemastore.org/github-workflow.json'] = '/.github/workflows/*',
                            },
                        },
                    },
                },
                lua_ls = {
                    settings = {
                        Lua = {
                            completion = {
                                callSnippet = 'Replace',
                            },
                            format = {
                                enable = true,
                                defaultConfig = {
                                    indent_style = 'space',
                                    indent_size = '4',
                                },
                            },
                        },
                    },
                },
            },
        },
        config = function(_, opts)
            -- Brief aside: **What is LSP?**
            --
            -- LSP is an initialism you've probably heard, but might not understand what it is.
            --
            -- LSP stands for Language Server Protocol. It's a protocol that helps editors
            -- and language tooling communicate in a standardized fashion.
            --
            -- In general, you have a "server" which is some tool built to understand a particular
            -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
            -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
            -- processes that communicate with some "client" - in this case, Neovim!
            --
            -- LSP provides Neovim with features like:
            --  - Go to definition
            --  - Find references
            --  - Autocompletion
            --  - Symbol Search
            --  - and more!
            --
            -- Thus, Language Servers are external tools that must be installed separately from
            -- Neovim. This is where `mason` and related plugins come into play.
            --
            -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
            -- and elegantly composed help section, `:help lsp-vs-treesitter`

            --  This function gets run when an LSP attaches to a particular buffer.
            --    That is to say, every time a new file is opened that is associated with
            --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
            --    function will be executed to configure the current buffer
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
                callback = function(event)
                    -- NOTE: Remember that Lua is a real programming language, and as such it is possible
                    -- to define small helper and utility functions so you don't have to repeat yourself.
                    --
                    -- In this case, we create a function that lets us more easily define mappings specific
                    -- for LSP related items. It sets the mode, buffer and description for us each time.
                    local map = function(keys, func, desc, mode)
                        mode = mode or 'n'
                        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                    end

                    -- Jump to the definition of the word under your cursor.
                    --  This is where a variable was first declared, or where a function is defined, etc.
                    --  To jump back, press <C-t>.
                    map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

                    -- Find references for the word under your cursor.
                    map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

                    -- Jump to the implementation of the word under your cursor.
                    --  Useful when your language has ways of declaring types without an actual implementation.
                    map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

                    -- Jump to the type of the word under your cursor.
                    --  Useful when you're not sure what type a variable is and you want to see
                    --  the definition of its *type*, not where it was *defined*.
                    map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
                    map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

                    -- Fuzzy find all the symbols in your current document.
                    --  Symbols are things like variables, functions, types, etc.
                    map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
                    map('grO', require('telescope.builtin').lsp_document_symbols, '[O]pen Document Symbols')

                    -- Fuzzy find all the symbols in your current workspace.
                    --  Similar to document symbols, except searches over your entire project.
                    map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
                    map('grW', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

                    -- Rename the variable under your cursor.
                    --  Most Language Servers support renaming across files, etc.
                    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
                    map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

                    -- Execute a code action, usually your cursor needs to be on top of an error
                    -- or a suggestion from your LSP for this to activate.
                    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
                    map('gra', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

                    -- WARN: This is not Goto Definition, this is Goto Declaration.
                    --  For example, in C this would take you to the header.
                    map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

                    -- The following two autocommands are used to highlight references of the
                    -- word under your cursor when your cursor rests there for a little while.
                    --    See `:help CursorHold` for information about when this is executed
                    --
                    -- When you move your cursor, the highlights will be cleared (the second autocommand).
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

                    -- The following code creates a keymap to toggle inlay hints in your
                    -- code, if the language server you are using supports them
                    --
                    -- This may be unwanted, since they displace some of your code
                    ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
                    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
                        map('<leader>th', function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
                        end, '[T]oggle Inlay [H]ints')
                    end
                end,
            })

            -- Change diagnostic symbols in the sign column (gutter)
            if vim.g.have_nerd_font then
                local signs = {
                    ERROR = _G.LazyVim.config.icons.diagnostics.Error or ' ',
                    WARN = _G.LazyVim.config.icons.diagnostics.Warn or ' ',
                    INFO = _G.LazyVim.config.icons.diagnostics.Info or ' ',
                    HINT = _G.LazyVim.config.icons.diagnostics.Hint or ' ',
                }
                local diagnostic_signs = {}
                for type, icon in pairs(signs) do
                    diagnostic_signs[vim.diagnostic.severity[type]] = icon
                end
                vim.diagnostic.config {
                    signs = { text = diagnostic_signs },
                    virtual_text = {
                        prefix = _G.LazyVim.config.icons.misc.circle or '●',
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
                end, { desc = 'E[x]amine Trouble [S]how in floating buffer' })
            end

            local ensure_installed = vim.tbl_keys(opts.servers or {})
            vim.list_extend(ensure_installed, {
                'stylua', -- Used to format Lua code
            })
            require('mason-tool-installer').setup { ensure_installed = ensure_installed }

            local lspconfig = require 'lspconfig'
            for server, config in pairs(opts.servers) do
                config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
                lspconfig[server].setup(config)
            end
        end,
    },
    {
        'nvimdev/lspsaga.nvim',
        config = function()
            require('lspsaga').setup {
                ui = { code_action = _G.LazyVim.config.icons.misc.lightning or '󱐋' },
            }
        end,
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'nvim-tree/nvim-web-devicons',
        },
    },
}
