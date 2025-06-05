return {
    {
        'jfgordon2/gh-notifications.nvim',
        opts = {},
    },
    {
        vim.api.nvim_set_keymap('n', '<leader>gn', '<cmd>GHNotifications<CR>', { noremap = true, silent = true, desc = 'GitHub Notifications' }),
    },
}
