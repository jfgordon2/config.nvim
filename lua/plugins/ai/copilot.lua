return function()
    local opts = {
        suggestion = {
            enabled = false,
            auto_trigger = true,
            keymap = {
                accept = false, -- handled by nvim-cmp / blink.cmp
                next = '<M-]>',
                prev = '<M-[>',
            },
        },
        panel = { enabled = false },
        filetypes = {
            markdown = true,
            help = true,
        },
    }
    require('copilot').setup(opts)
    vim.api.nvim_create_user_command('CopilotSignin', function()
        require('copilot.auth').signin()
    end, { desc = 'Login to Copilot' })
    vim.api.nvim_create_user_command('CopilotSignout', function()
        require('copilot.auth').signout()
    end, { desc = 'Logout from Copilot' })
end
