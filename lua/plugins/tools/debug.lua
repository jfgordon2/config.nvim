local icons = require 'config.icons'

return function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup { automatic_installation = false, handlers = {} }

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    ---@diagnostic disable-next-line: missing-fields
    dapui.setup {
        -- Set icons to characters that are more likely to work in every terminal.
        --    Feel free to remove or use ones that you like more! :)
        --    Don't feel like these are good choices.
        icons = icons.dapui.icons,
        ---@diagnostic disable-next-line: missing-fields
        controls = {
            icons = icons.dapui.controls,
        },
    }

    local breakpoint_icons = vim.deepcopy(icons.dap)
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

    vim.keymap.set('n', '<F5>', function()
        require('dap').continue()
    end, { desc = 'Start/continue debugging' })
    vim.keymap.set('n', '<leader>B<F5>', function()
        require('dap').continue()
    end, { desc = 'Start/continue debugging' })
    vim.keymap.set('n', '<F1>', function()
        require('dap').step_into()
    end, { desc = 'Step into' })
    vim.keymap.set('n', '<leader>B<F1>', function()
        require('dap').step_into()
    end, { desc = 'Step into' })
    vim.keymap.set('n', '<F2>', function()
        require('dap').step_over()
    end, { desc = 'Step over' })
    vim.keymap.set('n', '<leader>B<F2>', function()
        require('dap').step_over()
    end, { desc = 'Step over' })
    vim.keymap.set('n', '<F3>', function()
        require('dap').step_out()
    end, { desc = 'Step out' })
    vim.keymap.set('n', '<leader>B<F3>', function()
        require('dap').step_out()
    end, { desc = 'Step out' })
    vim.keymap.set('n', '<leader>Bb', function()
        require('dap').toggle_breakpoint()
    end, { desc = 'Toggle breakpoint' })
    vim.keymap.set('n', '<leader>BB', function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = 'Set conditional breakpoint' })
    vim.keymap.set('n', '<leader>Bc', function()
        require('dap').clear_breakpoints()
    end, { desc = 'Clear all breakpoints' })
    vim.keymap.set('n', '<F7>', function()
        require('dapui').toggle()
    end, { desc = 'Toggle debug UI' })
    vim.keymap.set('n', '<leader>B<F7>', function()
        require('dapui').toggle()
    end, { desc = 'Toggle debug UI' })
end
