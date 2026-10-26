return function()
    local opts = {}
    require('gh_notifications').setup(opts)
    vim.api.nvim_set_keymap('n', '<leader>gn', '<cmd>GHNotifications<CR>', { noremap = true, silent = true, desc = 'GitHub Notifications' })
end
