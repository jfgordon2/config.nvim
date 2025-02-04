-- Copilot Chat Setup
return {
    'olimorris/codecompanion.nvim',
    dependencies = {
        { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
        { 'nvim-lua/plenary.nvim' },
    },
    config = function()
        require('codecompanion').setup {
            adapters = {
                copilot = function()
                    return require('codecompanion.adapters').extend('copilot', {
                        schema = {
                            model = { default = 'claude-3.5-sonnet' },
                        },
                    })
                end,
            },
            strategies = {
                inline = {
                    adapter = 'copilot',
                    keymaps = {
                        accept_change = {
                            modes = { n = '<leader>as' },
                            description = '[A]i: Accept the [s]suggested change',
                        },
                        reject_change = {
                            modes = { n = '<leader>ar' },
                            description = '[A]i: [R]eject the suggested change',
                        },
                    },
                },
                chat = {
                    adapter = 'copilot',
                    keymaps = {
                        send = {
                            modes = { n = '<CR>', i = '<C-s>' },
                        },
                        close = {
                            modes = { n = '<C-c>', i = '<C-c>' },
                        },
                        -- Add further custom keymaps here
                    },
                },
            },
            display = {
                chat = {
                    intro_message = ' CodeCompanion - Press ? for options',
                    show_header_separator = false, -- Show header separators in the chat buffer? Set this to false if you're using an external markdown formatting plugin
                    separator = '─', -- The separator between the different messages in the chat buffer
                    show_references = true, -- Show references (from slash commands and variables) in the chat buffer?
                    show_settings = false, -- Show LLM settings at the top of the chat buffer?
                    show_token_count = true, -- Show the token count for each response?
                    start_in_insert_mode = false, -- Open the chat buffer in insert mode?
                },
            },
            prompt_library = {
                ['Code Expert'] = {
                    strategy = 'chat',
                    description = 'Get some special advice from an LLM',
                    opts = {
                        mapping = '<Leader>ce',
                        modes = { 'v' },
                        short_name = 'expert',
                        auto_submit = true,
                        stop_context_insertion = true,
                        user_prompt = true,
                    },
                    prompts = {
                        {
                            role = 'system',
                            content = function(context)
                                return 'I want you to act as a senior '
                                    .. context.filetype
                                    .. ' developer. I will ask you specific questions and I want you to return concise explanations and codeblock examples.'
                            end,
                        },
                        {
                            role = 'user',
                            content = function(context)
                                local text = require('codecompanion.helpers.actions').get_code(context.start_line, context.end_line)

                                return 'I have the following code:\n\n```' .. context.filetype .. '\n' .. text .. '\n```\n\n'
                            end,
                            opts = {
                                contains_code = true,
                            },
                        },
                    },
                },
            },
        }
    end,
}
