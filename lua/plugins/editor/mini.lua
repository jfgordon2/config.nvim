return { -- Collection of various small independent plugins/modules
    {
        'echasnovski/mini.nvim',
        config = function()
            -- Better Around/Inside textobjects
            --
            -- Examples:
            --  - va)  - [V]isually select [A]round [)]paren
            --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
            --  - ci'  - [C]hange [I]nside [']quote
            require('mini.ai').setup { n_lines = 500 }

            -- Add/delete/replace surroundings (brackets, quotes, etc.)
            --
            -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
            -- - sd'   - [S]urround [D]elete [']quotes
            -- - sr)'  - [S]urround [R]eplace [)] [']
            require('mini.surround').setup()

            -- Jump across multiple lines using f/F/T/t
            require('mini.jump').setup {
                delay = {
                    idle_stop = 1000,
                },
            }

            -- Split/Join scopes using gS
            require('mini.splitjoin').setup {
                mappings = {
                    toggle = '<leader>tS',
                },
            }

            -- Simple and easy statusline.
            --  You could remove this setup call if you don't like it,
            --  and try some other statusline plugin
            local statusline = require 'mini.statusline'
            -- set use_icons to true if you have a Nerd Font
            statusline.setup { use_icons = vim.g.have_nerd_font }

            -- You can configure sections in the statusline by overriding their
            -- default behavior. For example, here we set the section for
            -- cursor location to LINE:COLUMN
            ---@diagnostic disable-next-line: duplicate-set-field
            statusline.section_location = function()
                return '%2l:%-2v'
            end

            -- ... and there is more!
            --  Check out: https://github.com/echasnovski/mini.nvim
        end,
    },
    -- icons
    {
        'echasnovski/mini.icons',
        lazy = true,
        opts = {
            file = {
                ['.keep'] = {
                    glyph = _G.LazyVim.config.icons.ft.dotkeep or '󰊢',
                    hl = 'MiniIconsGrey',
                },
                ['devcontainer.json'] = {
                    glyph = _G.LazyVim.config.icons.ft.devcontainer or '',
                    hl = 'MiniIconsAzure',
                },
            },
            filetype = {
                dotenv = {
                    glyph = _G.LazyVim.config.icons.ft.dotenv or '',
                    hl = 'MiniIconsYellow',
                },
            },
            lsp = {
                array = {
                    glyph = _G.LazyVim.config.icons.kinds.Array or '󰅪',
                    hl = 'MiniIconsCyan',
                },
                boolean = {
                    glyph = _G.LazyVim.config.icons.kinds.Boolean or '󰪚',
                    hl = 'MiniIconsYellow',
                },
                class = {
                    glyph = _G.LazyVim.config.icons.kinds.Class or '󱡠',
                    hl = 'MiniIconsRed',
                },
                collapsed = {
                    glyph = _G.LazyVim.config.icons.kinds.Collapsed or '󰅩',
                    hl = 'MiniIconsGrey',
                },
                color = {
                    glyph = _G.LazyVim.config.icons.kinds.Color or '󰏘',
                    hl = 'MiniIconsGreen',
                },
                constant = {
                    glyph = _G.LazyVim.config.icons.kinds.Constant or '󰏿',
                    hl = 'MiniIconsCyan',
                },
                constructor = {
                    glyph = _G.LazyVim.config.icons.kinds.Constructor or '󰒓',
                    hl = 'MiniIconsOrange',
                },
                control = {
                    glyph = _G.LazyVim.config.icons.kinds.Control or '',
                    hl = 'MiniIconsGrey',
                },
                copilot = {
                    glyph = _G.LazyVim.config.icons.kinds.Copilot or '',
                    hl = 'MiniIconsBlue',
                },
                enum = {
                    glyph = _G.LazyVim.config.icons.kinds.Enum or '󰦨',
                    hl = 'MiniIconsYellow',
                },
                enummember = {
                    glyph = _G.LazyVim.config.icons.kinds.EnumMember or '󰦨',
                    hl = 'MiniIconsYellow',
                },
                event = {
                    glyph = _G.LazyVim.config.icons.kinds.Event or '󱐋',
                    hl = 'MiniIconsGrey',
                },
                field = {
                    glyph = _G.LazyVim.config.icons.kinds.Field or '󰜢',
                    hl = 'MiniIconsPurple',
                },
                file = {
                    glyph = _G.LazyVim.config.icons.kinds.File or '󰈙',
                    hl = 'MiniIconsGrey',
                },
                folder = {
                    glyph = _G.LazyVim.config.icons.kinds.Folder or '󰉋',
                    hl = 'MiniIconsGrey',
                },
                Function = {
                    glyph = _G.LazyVim.config.icons.kinds.Function or '󰊕',
                    hl = 'MiniIconsOrange',
                },
                interface = {
                    glyph = _G.LazyVim.config.icons.kinds.Interface or '󱡠',
                    hl = 'MiniIconsRed',
                },
                key = {
                    glyph = _G.LazyVim.config.icons.kinds.Key or '󰪓',
                    hl = 'MiniIconsCyan',
                },
                keyword = {
                    glyph = _G.LazyVim.config.icons.kinds.Keyword or '󰻾',
                    hl = 'MiniIconsCyan',
                },
                method = {
                    glyph = _G.LazyVim.config.icons.kinds.Method or '󰊕',
                    hl = 'MiniIconsOrange',
                },
                module = {
                    glyph = _G.LazyVim.config.icons.kinds.Module or '󱡠',
                    hl = 'MiniIconsRed',
                },
                namespace = {
                    glyph = _G.LazyVim.config.icons.kinds.Namespace or '󰦮',
                    hl = 'MiniIconsGrey',
                },
                null = {
                    glyph = _G.LazyVim.config.icons.kinds.Null or '',
                    hl = 'MiniIconsGrey',
                },
                number = {
                    glyph = _G.LazyVim.config.icons.kinds.Number or '󰎠',
                    hl = 'MiniIconsCyan',
                },
                object = {
                    glyph = _G.LazyVim.config.icons.kinds.Object or '',
                    hl = 'MiniIconsCyan',
                },
                operator = {
                    glyph = _G.LazyVim.config.icons.kinds.Operator or '󰪚',
                    hl = 'MiniIconsOrange',
                },
                package = {
                    glyph = _G.LazyVim.config.icons.kinds.Package or '󰅩',
                    hl = 'MiniIconsGrey',
                },
                property = {
                    glyph = _G.LazyVim.config.icons.kinds.Property or '󰖷',
                    hl = 'MiniIconsPurple',
                },
                reference = {
                    glyph = _G.LazyVim.config.icons.kinds.Reference or '󰬲',
                    hl = 'MiniIconsGrey',
                },
                snippet = {
                    glyph = _G.LazyVim.config.icons.kinds.Snippet or '󱄽',
                    hl = 'MiniIconsGreen',
                },
                string = {
                    glyph = _G.LazyVim.config.icons.kinds.String or '󰉿',
                    hl = 'MiniIconsGreen',
                },
                struct = {
                    glyph = _G.LazyVim.config.icons.kinds.Struct or '󱡠',
                    hl = 'MiniIconsRed',
                },
                text = {
                    glyph = _G.LazyVim.config.icons.kinds.Text or '󰉿',
                    hl = 'MiniIconsGreen',
                },
                typeparameter = {
                    glyph = _G.LazyVim.config.icons.kinds.TypeParameter or '󰬛',
                    hl = 'MiniIconsOrange',
                },
                unit = {
                    glyph = _G.LazyVim.config.icons.kinds.Unit or '󰪚',
                    hl = 'MiniIconsYellow',
                },
                value = {
                    glyph = _G.LazyVim.config.icons.kinds.Value or '󰦨',
                    hl = 'MiniIconsYellow',
                },
                variable = {
                    glyph = _G.LazyVim.config.icons.kinds.Variable or '󰆦',
                    hl = 'MiniIconsPurple',
                },
            },
        },
    },
}
