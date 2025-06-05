-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
    -- NOTE: Yes, you can install new plugins here!
    'mfussenegger/nvim-dap',
    -- NOTE: And you can specify dependencies as well
    dependencies = {
        -- Creates a beautiful debugger UI
        'rcarriga/nvim-dap-ui',

        -- Required dependency for nvim-dap-ui
        'nvim-neotest/nvim-nio',

        -- Installs the debug adapters for you
        'mason-org/mason.nvim',
        'jay-babu/mason-nvim-dap.nvim',

        -- Add your own debuggers here
        'leoluz/nvim-dap-go',
        'mfussenegger/nvim-dap-python',
        'mrcjkb/rustaceanvim',
    },
    keys = {
        -- Basic debugging keymaps, feel free to change to your liking!
        {
            '<F5>',
            function()
                require('dap').continue()
            end,
            desc = 'Debug: Start/Continue',
        },
        {
            '<leader>B<F5>',
            function()
                require('dap').continue()
            end,
            desc = 'Debug: Start/Continue (F5)',
        },
        {
            '<F1>',
            function()
                require('dap').step_into()
            end,
            desc = 'Debug: Step Into',
        },
        {
            '<leader>B<F1>',
            function()
                require('dap').step_into()
            end,
            desc = 'Debug: Step Into (F1)',
        },
        {
            '<F2>',
            function()
                require('dap').step_over()
            end,
            desc = 'Debug: Step Over',
        },
        {
            '<leader>B<F2>',
            function()
                require('dap').step_over()
            end,
            desc = 'Debug: Step Over (F2)',
        },
        {
            '<F3>',
            function()
                require('dap').step_out()
            end,
            desc = 'Debug: Step Out',
        },
        {
            '<leader>B<F3>',
            function()
                require('dap').step_out()
            end,
            desc = 'Debug: Step Out (F3)',
        },

        {
            '<leader>Bb',
            function()
                require('dap').toggle_breakpoint()
            end,
            desc = 'Debug: Toggle [B]reakpoint',
        },
        {
            '<leader>BB',
            function()
                require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
            end,
            desc = 'Debug: Set [B]reakpoint',
        },
        {
            '<leader>Bc',
            function()
                require('dap').clear_breakpoints()
            end,
            desc = 'Debug: [C]lear all breakpoints',
        },
        -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
        {
            '<F7>',
            function()
                require('dapui').toggle()
            end,
            desc = 'Debug: See last session result.',
        },
        {
            '<leader>B<F7>',
            function()
                require('dapui').toggle()
            end,
            desc = 'Debug: See last session result (F7)',
        },
    },
    config = function()
        local dap = require 'dap'
        local dapui = require 'dapui'

        require('mason-nvim-dap').setup {
            -- Makes a best effort to setup the various debuggers with
            -- reasonable debug configurations
            automatic_installation = true,

            -- You can provide additional configuration to the handlers,
            -- see mason-nvim-dap README for more information
            handlers = {},

            -- You'll need to check that you have the required things installed
            -- online, please don't ask me how to install them :)
            ensure_installed = {
                -- Update this to ensure that you have the debuggers for the langs you want
                'delve',
            },
        }

        -- Dap UI setup
        -- For more information, see |:help nvim-dap-ui|
        ---@diagnostic disable-next-line: missing-fields
        dapui.setup {
            -- Set icons to characters that are more likely to work in every terminal.
            --    Feel free to remove or use ones that you like more! :)
            --    Don't feel like these are good choices.
            icons = _G.LazyVim.config.icons.dapui.icons or { expanded = '▾', collapsed = '▸', current_frame = '*' },
            ---@diagnostic disable-next-line: missing-fields
            controls = {
                icons = _G.LazyVim.config.icons.dapui.controls or {
                    pause = '⏸',
                    play = '▶',
                    step_into = '⏎',
                    step_over = '⏭',
                    step_out = '⏮',
                    step_back = 'b',
                    run_last = '▶▶',
                    terminate = '⏹',
                    disconnect = '⏏',
                },
            },
        }

        -- Change breakpoint icons
        -- vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
        -- vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
        -- local breakpoint_icons = vim.g.have_nerd_font
        --     and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
        --   or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
        -- for type, icon in pairs(breakpoint_icons) do
        --   local tp = 'Dap' .. type
        --   local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
        --   vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
        -- end
        if _G.LazyVim and _G.LazyVim.config and _G.LazyVim.config.icons then
            local breakpoint_icons = vim.deepcopy(_G.LazyVim.config.icons.dap)
            for icon_type, icon in pairs(breakpoint_icons) do
                local tp = 'Dap' .. icon_type
                -- Handle both string and table icon formats
                local sign_text, sign_hl, line_hl
                if type(icon) == 'table' then
                    sign_text = icon[1] -- First element is the icon
                    sign_hl = icon[2] -- Second element is the highlight group
                    line_hl = icon[3] -- Third element is the line highlight
                    -- If it's Stopped, we need to define the line highlight
                    if icon_type == 'Stopped' and line_hl then
                        vim.api.nvim_set_hl(0, line_hl, { background = '#44475a' })
                    end
                else
                    sign_text = icon -- Direct string case
                    sign_hl = (icon_type == 'Stopped') and 'DapStop' or 'DapBreak'
                end
                vim.fn.sign_define(tp, {
                    text = sign_text,
                    texthl = sign_hl,
                    numhl = sign_hl,
                    linehl = line_hl, -- This will be nil for string format icons, which is fine
                })
            end
        end

        dap.listeners.after.event_initialized['dapui_config'] = dapui.open
        dap.listeners.before.event_terminated['dapui_config'] = dapui.close
        dap.listeners.before.event_exited['dapui_config'] = dapui.close

        -- Install golang specific config
        require('dap-go').setup {
            delve = {
                -- On Windows delve must be run attached or it crashes.
                -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
                detached = vim.fn.has 'win32' == 0,
            },
        }
        -- Python specific config
        require('dap-python').setup 'uv'
    end,
}
