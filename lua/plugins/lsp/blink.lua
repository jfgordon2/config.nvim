local icons = require 'config.icons'

-- Autocompletions

return function()
    local opts = {
        keymap = {
            preset = 'default',
            ['<Tab>'] = {
                'snippet_forward',
                function() -- sidekick next edit suggestion
                    return require('sidekick').nes_jump_or_apply()
                end,
                'accept',
                'fallback',
            },
        },

        fuzzy = { implementation = 'prefer_rust_with_warning' },

        snippets = { preset = 'luasnip' },

        appearance = {
            -- Sets the fallback highlight groups to nvim-cmp's highlight groups
            -- Useful for when your theme doesn't support blink.cmp
            -- Will be removed in a future release
            use_nvim_cmp_as_default = true,
            -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
            -- Adjusts spacing to ensure icons are aligned
            nerd_font_variant = 'mono',
            kind_icons = icons.kinds,
        },

        -- Default list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, due to `opts_extend`
        sources = {
            default = {
                'lsp',
                'path',
                'snippets',
                'buffer',
                'copilot',
                -- 'codecompanion'
            },
            providers = {
                copilot = {
                    name = 'copilot',
                    module = 'blink-copilot',
                    score_offset = 100,
                    async = true,
                },
            },
        },
        -- Completion options
        completion = {
            accept = {
                auto_brackets = { enabled = true },
            },
            ghost_text = {
                enabled = true,
            },
            documentation = {
                auto_show = true,
            },
            menu = {
                enabled = true,
                direction_priority = { 'n', 's' },
                draw = {
                    components = {
                        kind_icon = {
                            text = function(ctx)
                                local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
                                return kind_icon
                            end,
                            -- (optional) use highlights from mini.icons
                            highlight = function(ctx)
                                local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                                -- if LSP source, check for color derived from documentation
                                if ctx.item.source_name == 'LSP' then
                                    local color_item = require('nvim-highlight-colors').format(ctx.item.documentation, { kind = ctx.kind })
                                    if color_item and color_item.abbr_hl_group then
                                        hl = color_item.abbr_hl_group
                                    end
                                end
                                return hl
                            end,
                        },
                        kind = {
                            -- (optional) use highlights from mini.icons
                            highlight = function(ctx)
                                local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                                return hl
                            end,
                        },
                    },
                },
            },
        },
        -- cmd line
        cmdline = {
            enabled = true,
            completion = {
                menu = {
                    auto_show = true,
                },
                ghost_text = {
                    enabled = true,
                },
            },
            keymap = {
                preset = 'inherit',
            },
        },
        -- signature help
        signature = {
            enabled = true,
            window = {
                show_documentation = true,
            },
        },
    }
    require('blink.cmp').setup(opts)
end
