local icons = require 'config.icons'

return function()
    do -- nvim-mini/mini.nvim
        require('mini.ai').setup { n_lines = 500 }

        require('mini.surround').setup {
            -- Add custom surroundings to be used on top of builtin ones. For more
            -- information with examples, see `:h MiniSurround.config`.
            custom_surroundings = nil,

            -- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
            highlight_duration = 500,

            -- Module mappings. Use `''` (empty string) to disable one.
            mappings = {
                add = 'gsa', -- Add surrounding in Normal and Visual modes
                delete = 'gsd', -- Delete surrounding
                find = 'gsf', -- Find surrounding (to the right)
                find_left = 'gsF', -- Find surrounding (to the left)
                highlight = 'gsh', -- Highlight surrounding
                replace = 'gsr', -- Replace surrounding
                update_n_lines = 'gsn', -- Update `n_lines`

                suffix_last = 'l', -- Suffix to search with "prev" method
                suffix_next = 'n', -- Suffix to search with "next" method
            },

            -- Number of lines within which surrounding is searched
            n_lines = 20,

            -- Whether to respect selection type:
            -- - Place surroundings on separate lines in linewise mode.
            -- - Place surroundings on each line in blockwise mode.
            respect_selection_type = false,

            search_method = 'cover',

            -- Whether to disable showing non-error feedback
            -- This also affects (purely informational) helper messages shown after
            -- idle time if user input is required.
            silent = false,
        }

        -- Jump across multiple lines using f/F/T/t
        require('mini.jump').setup {
            delay = {
                idle_stop = 1000,
            },
        }

        -- Toggle arguments between single-line and multiline layouts.
        require('mini.splitjoin').setup {
            mappings = {
                toggle = '<leader>tS',
            },
        }
        for _, mode in ipairs { 'n', 'x' } do
            local mapping = vim.fn.maparg('<leader>tS', mode, false, true)
            mapping.desc = 'Split/join arguments'
            vim.fn.mapset(mode, false, mapping)
        end

        -- Simple and easy statusline.
        --  You could remove this setup call if you don't like it,
        --  and try some other statusline plugin
        local statusline = require 'mini.statusline'
        -- set use_icons to true if you have a Nerd Font
        statusline.setup {
            use_icons = vim.g.have_nerd_font,
            content = {
                active = function()
                    local mode, mode_hl = MiniStatusline.section_mode { trunc_width = 120 }
                    local git = MiniStatusline.section_git { trunc_width = 40, icon = vim.fn.strcharpart(icons.git.branch, 0, 1) }
                    local diff = MiniStatusline.section_diff { trunc_width = 75, icon = vim.fn.strcharpart(icons.git.diff, 0, 1) }
                    local diagnostics = MiniStatusline.section_diagnostics {
                        trunc_width = 75,
                        icon = '',
                        signs = {
                            ERROR = icons.diagnostics.Error,
                            WARN = icons.diagnostics.Warn,
                            INFO = icons.diagnostics.Info,
                            HINT = icons.diagnostics.Hint,
                        },
                    }
                    local lsp = MiniStatusline.section_lsp { trunc_width = 75 }
                    local filename = MiniStatusline.section_filename { trunc_width = 140 }
                    local fileinfo = MiniStatusline.section_fileinfo { trunc_width = 120 }
                    local location = MiniStatusline.section_location { trunc_width = 75 }
                    local search = MiniStatusline.section_searchcount { trunc_width = 75 }

                    return MiniStatusline.combine_groups {
                        { hl = mode_hl, strings = { mode } },
                        { hl = 'MiniStatuslineDevinfo', strings = { git, diff } },
                        { hl = 'DiagnosticVirtualTextInfo', strings = { diagnostics } },
                        '%<', -- Mark general truncate point
                        { hl = 'MiniStatuslineFilename', strings = { filename } },
                        '%=', -- End left alignment
                        { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
                        { hl = mode_hl, strings = { search, location } },
                    }
                end,
            },
        }

        statusline.section_location = function()
            return '%2l:%-2v'
        end
    end
    do -- nvim-mini/mini.icons
        local opts = {
            file = {
                ['.keep'] = {
                    glyph = icons.ft.dotkeep,
                    hl = 'MiniIconsGrey',
                },
                ['devcontainer.json'] = {
                    glyph = icons.ft.devcontainer,
                    hl = 'MiniIconsAzure',
                },
            },
            filetype = {
                dotenv = {
                    glyph = icons.ft.dotenv,
                    hl = 'MiniIconsYellow',
                },
            },
            lsp = {
                array = {
                    glyph = icons.kinds.Array,
                    hl = 'MiniIconsCyan',
                },
                boolean = {
                    glyph = icons.kinds.Boolean,
                    hl = 'MiniIconsYellow',
                },
                class = {
                    glyph = icons.kinds.Class,
                    hl = 'MiniIconsRed',
                },
                collapsed = {
                    glyph = icons.kinds.Collapsed,
                    hl = 'MiniIconsGrey',
                },
                color = {
                    glyph = icons.kinds.Color,
                    hl = 'MiniIconsGreen',
                },
                constant = {
                    glyph = icons.kinds.Constant,
                    hl = 'MiniIconsCyan',
                },
                constructor = {
                    glyph = icons.kinds.Constructor,
                    hl = 'MiniIconsOrange',
                },
                control = {
                    glyph = icons.kinds.Control,
                    hl = 'MiniIconsGrey',
                },
                copilot = {
                    glyph = icons.kinds.Copilot,
                    hl = 'MiniIconsBlue',
                },
                enum = {
                    glyph = icons.kinds.Enum,
                    hl = 'MiniIconsYellow',
                },
                enummember = {
                    glyph = icons.kinds.EnumMember,
                    hl = 'MiniIconsYellow',
                },
                event = {
                    glyph = icons.kinds.Event,
                    hl = 'MiniIconsGrey',
                },
                field = {
                    glyph = icons.kinds.Field,
                    hl = 'MiniIconsPurple',
                },
                file = {
                    glyph = icons.kinds.File,
                    hl = 'MiniIconsGrey',
                },
                folder = {
                    glyph = icons.kinds.Folder,
                    hl = 'MiniIconsGrey',
                },
                Function = {
                    glyph = icons.kinds.Function,
                    hl = 'MiniIconsOrange',
                },
                interface = {
                    glyph = icons.kinds.Interface,
                    hl = 'MiniIconsRed',
                },
                key = {
                    glyph = icons.kinds.Key,
                    hl = 'MiniIconsCyan',
                },
                keyword = {
                    glyph = icons.kinds.Keyword,
                    hl = 'MiniIconsCyan',
                },
                method = {
                    glyph = icons.kinds.Method,
                    hl = 'MiniIconsOrange',
                },
                module = {
                    glyph = icons.kinds.Module,
                    hl = 'MiniIconsRed',
                },
                namespace = {
                    glyph = icons.kinds.Namespace,
                    hl = 'MiniIconsGrey',
                },
                null = {
                    glyph = icons.kinds.Null,
                    hl = 'MiniIconsGrey',
                },
                number = {
                    glyph = icons.kinds.Number,
                    hl = 'MiniIconsCyan',
                },
                object = {
                    glyph = icons.kinds.Object,
                    hl = 'MiniIconsCyan',
                },
                operator = {
                    glyph = icons.kinds.Operator,
                    hl = 'MiniIconsOrange',
                },
                package = {
                    glyph = icons.kinds.Package,
                    hl = 'MiniIconsGrey',
                },
                property = {
                    glyph = icons.kinds.Property,
                    hl = 'MiniIconsPurple',
                },
                reference = {
                    glyph = icons.kinds.Reference,
                    hl = 'MiniIconsGrey',
                },
                snippet = {
                    glyph = icons.kinds.Snippet,
                    hl = 'MiniIconsGreen',
                },
                string = {
                    glyph = icons.kinds.String,
                    hl = 'MiniIconsGreen',
                },
                struct = {
                    glyph = icons.kinds.Struct,
                    hl = 'MiniIconsRed',
                },
                text = {
                    glyph = icons.kinds.Text,
                    hl = 'MiniIconsGreen',
                },
                typeparameter = {
                    glyph = icons.kinds.TypeParameter,
                    hl = 'MiniIconsOrange',
                },
                unit = {
                    glyph = icons.kinds.Unit,
                    hl = 'MiniIconsYellow',
                },
                value = {
                    glyph = icons.kinds.Value,
                    hl = 'MiniIconsYellow',
                },
                variable = {
                    glyph = icons.kinds.Variable,
                    hl = 'MiniIconsPurple',
                },
            },
        }
        require('mini.icons').setup(opts)
    end
end
