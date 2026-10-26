-- Session management. This saves your session in the background,
-- keeping track of open buffers, window arrangement, and more.
-- You can restore sessions when returning through the dashboard.

return function()
    local opts = {}
    require('persistence').setup(opts)
    vim.keymap.set('n', '<leader>qs', function()
        require('persistence').load()
    end, { desc = 'Restore session for current directory' })
    vim.keymap.set('n', '<leader>qS', function()
        require('persistence').select()
    end, { desc = 'Choose session to restore' })
    vim.keymap.set('n', '<leader>ql', function()
        require('persistence').load { last = true }
    end, { desc = 'Restore last session' })
    vim.keymap.set('n', '<leader>qd', function()
        require('persistence').stop()
    end, { desc = 'Stop saving the session' })
end
