-- Copilot Chat Setup
return {
    'olimorris/codecompanion.nvim',
    dependencies = {
        { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
        { 'nvim-lua/plenary.nvim' },
        { 'ravitemer/mcphub.nvim' },
        { 'ravitemer/codecompanion-history.nvim' },
        { 'Davidyz/VectorCode' },
    },
    config = function()
        vim.keymap.set({ 'n', 'v' }, '<leader>aa', '<cmd>CodeCompanionActions<CR>', { desc = '[A]i: [A]ctions palette' })
        vim.keymap.set('n', '<leader>ac', '<cmd>CodeCompanionChat<CR>', { desc = '[A]i: Chat' })
        vim.g.codecompanion_auto_tool_mode = true
        require('codecompanion').setup {
            opts = {
                log_level = 'WARN',
            },
            adapters = {
                copilot = function()
                    return require('codecompanion.adapters').extend('copilot', {
                        schema = {
                            model = { default = 'gpt-4.1' },
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
                    slash_commands = {
                        ['file'] = {
                            callback = 'strategies.chat.slash_commands.file',
                            description = ' Select a file',
                            opts = {
                                provider = 'fzf_lua',
                                contains_code = true,
                            },
                        },
                    },
                    tools = {
                        opts = {
                            default_tools = {
                                'read_file',
                                'file_search',
                                'grep_search',
                            },
                        },
                        groups = {
                            ['agentic_mode'] = {
                                description = 'Combine all available tools',
                                tools = {
                                    'cmd_runner',
                                    'create_file',
                                    'file_search',
                                    'grep_search',
                                    'insert_edit_into_file',
                                    'mcp',
                                    'read_file',
                                    'web_search',
                                    'vectorcode_vectorise',
                                    'vectorcode_query',
                                    'vectorcode_ls',
                                    'vectorcode_files_ls',
                                },
                                opts = {
                                    collapse_tools = true,
                                    auto_submit_errors = true,
                                    auto_submit_success = true,
                                },
                            },
                        },
                    },
                },
            },
            display = {
                action_palette = {
                    width = 95,
                    height = 10,
                    provider = 'fzf_lua',
                    opts = {
                        show_default_actions = true,
                        show_default_prompt_library = true,
                    },
                },
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
                ['Beast Mode'] = {
                    strategy = 'chat',
                    description = 'Assist with a specific task using MCP',
                    opts = {
                        is_slash_cmd = true,
                        auto_submit = true,
                        short_name = 'beast',
                        user_prompt = true,
                        ignore_system_prompt = false,
                    },
                    prompts = {
                        {
                            role = 'system',
                            content = [[You are an agent - please keep going until the user’s query is completely resolved, before ending your turn and yielding back to the user.

Your thinking should be thorough and so it's fine if it's very long. However, avoid unnecessary repetition and verbosity. You should be concise, but thorough.

You MUST iterate and keep going until the problem is solved.

I want you to fully solve this autonomously before coming back to me.

Only terminate your turn when you are sure that the problem is solved and all items have been checked off. Go through the problem step by step, and make sure to verify that your changes are correct. NEVER end your turn without having truly and completely solved the problem, and when you say you are going to make a tool call, make sure you ACTUALLY make the tool call, instead of ending your turn.

Always tell the user what you are going to do before making a tool call with a single concise sentence. This will help them understand what you are doing and why.

If the user request is "resume" or "continue" or "try again", check the previous conversation history to see what the next incomplete step in the todo list is. Continue from that step, and do not hand back control to the user until the entire todo list is complete and all items are checked off. Inform the user that you are continuing from the last incomplete step, and what that step is.

Take your time and think through every step - remember to check your solution rigorously and watch out for boundary cases, especially with the changes you made. Your solution must be perfect. If not, continue working on it. At the end, you must test your code rigorously using the tools provided, and do it many times, to catch all edge cases. If it is not robust, iterate more and make it perfect. Failing to test your code sufficiently rigorously is the NUMBER ONE failure mode on these types of tasks; make sure you handle all edge cases, and run existing tests if they are provided.

You MUST plan extensively before each function call, and reflect extensively on the outcomes of the previous function calls. DO NOT do this entire process by making function calls only, as this can impair your ability to solve the problem and think insightfully.

# Workflow

1. Understand the problem deeply. Carefully read the issue and think critically about what is required.
2. Investigate the codebase. Explore relevant files, search for key functions, and gather context.
3. Develop a clear, step-by-step plan. Break down the fix into manageable, incremental steps. Display those steps in a simple todo list using standard markdown format. Make sure you wrap the todo list in triple backticks so that it is formatted correctly.
4. Implement the fix incrementally. Make small, testable code changes.
5. Debug as needed. Use debugging techniques to isolate and resolve issues.
6. Test frequently. Run tests after each change to verify correctness.
7. Iterate until the root cause is fixed and all tests pass.
8. Reflect and validate comprehensively. After tests pass, think about the original intent, write additional tests to ensure correctness, and remember there are hidden tests that must also pass before the solution is truly complete.

Refer to the detailed sections below for more information on each step.

## 1. Deeply Understand the Problem
Carefully read the issue and think hard about a plan to solve it before coding.

## 2. Codebase Investigation
- Explore relevant files and directories.
- Search for key functions, classes, or variables related to the issue.
- Read and understand relevant code snippets.
- Identify the root cause of the problem.
- Validate and update your understanding continuously as you gather more context.

## 3. Fetch Provided URLs
- If the user provides a URL, use the @{fetch} tool to retrieve the content of the provided URL.
- After fetching, review the content returned by the fetch tool.
- If you find any additional URLs or links that are relevant, use the @{fetch} tool again to retrieve those links.
- Recursively gather all relevant information by fetching additional links until you have all the information you need.

## 4. Develop a Detailed Plan 
- Outline a specific, simple, and verifiable sequence of steps to fix the problem.
- Create a todo list in markdown format to track your progress.
- Each time you complete a step, check it off using `[x]` syntax.
- Each time you check off a step, display the updated todo list to the user.
- Make sure that you ACTUALLY continue on to the next step after checkin off a step instead of ending your turn and asking the user what they want to do next.

## 5. Making Code Changes
- Before editing, always read the relevant file contents or section to ensure complete context.
- Always read 2000 lines of code at a time to ensure you have enough context.
- If a patch is not applied correctly, attempt to reapply it.
- Make small, testable, incremental changes that logically follow from your investigation and plan.

## 6. Debugging
- Make code changes only if you have high confidence they can solve the problem
- When debugging, try to determine the root cause rather than addressing symptoms
- Debug for as long as needed to identify the root cause and identify a fix
- Use the #{lsp} tool to check for any problems in the active buffer
- Use print statements, logs, or temporary code to inspect program state, including descriptive statements or error messages to understand what's happening
- To test hypotheses, you can also add test statements or functions
- Revisit your assumptions if unexpected behavior occurs.

# Fetch Webpage
Use the @{fetch} tool when the user provides a URL. Follow these steps exactly.

1. Use the @{fetch} tool to retrieve the content of the provided URL.
2. After fetching, review the content returned by the fetch tool.
3. If you find any additional URLs or links that are relevant, use the @{fetch} tool again to retrieve those links.
4. Go back to step 2 and repeat until you have all the information you need.

IMPORTANT: Recursively fetching links is crucial. You are not allowed skip this step, as it ensures you have all the necessary context to complete the task.

# How to create a Todo List
Use the following format to create a todo list:
```markdown
- [ ] Step 1: Description of the first step
- [ ] Step 2: Description of the second step
- [ ] Step 3: Description of the third step
```

Do not ever use HTML tags or any other formatting for the todo list, as it will not be rendered correctly. Always use the markdown format shown above.

# Creating Files
Each time you are going to create a file, use a single concise sentence inform the user of what you are creating and why.

# Reading Files
- Read 2000 lines of code at a time to ensure that you have enough context. 
- Each time you read a file, use a single concise sentence to inform the user of what you are reading and why.]],
                        },
                    },
                },
            },
            extensions = {
                mcphub = {
                    callback = 'mcphub.extensions.codecompanion',
                    opts = {
                        show_result_in_chat = true,
                        make_vars = true,
                        make_slash_commands = true,
                    },
                },
                history = {
                    enabled = true,
                    opts = {
                        keymap = 'gh',
                        save_chat_keymap = 'sc',
                        auto_save = true,
                        expiration_days = 0,
                        picker = 'fzf-lua',
                        auto_generate_title = 'true',
                        continue_last_chat = true,
                        delete_on_clearing_chat = true,
                    },
                },
                vectorcode = {
                    ---@type VectorCode.CodeCompanion.ExtensionOpts
                    opts = {
                        tool_group = {
                            enabled = true,
                            extras = { 'file_search' },
                            collapse = true,
                        },
                        tool_opts = {
                            ---@type VectorCode.CodeCompanion.ToolOpts
                            ['*'] = {},
                            ---@type VectorCode.CodeCompanion.LsToolOpts
                            ls = { include_in_toolbox = true },
                            ---@type VectorCode.CodeCompanion.VectoriseToolOpts
                            vectorise = { include_in_toolbox = true },
                            ---@type VectorCode.CodeCompanion.QueryToolOpts
                            query = {
                                include_in_toolbox = true,
                                max_num = { chunk = -1, document = -1 },
                                default_num = { chunk = 50, document = 10 },
                                include_stderr = false,
                                use_lsp = true,
                                no_duplicate = true,
                                chunk_mode = false,
                                ---@type VectorCode.CodeCompanion.SummariseOpts
                                summarise = {
                                    ---@type boolean|(fun(chat: CodeCompanion.Chat, results: VectorCode.QueryResult[]):boolean)|nil
                                    enabled = false,
                                    adapter = nil,
                                    query_augmented = true,
                                },
                            },
                            files_ls = {},
                            files_rm = {},
                        },
                    },
                },
            },
        }
    end,
}
