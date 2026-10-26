-- https://github.com/OXY2DEV/markview.nvim
-- Preview markdown

return function()
    require('markview').setup {
        preview = {
            enable = false,
            icon_provider = 'mini',
        },
        experimental = {
            check_rtp_message = false,
        },
    }
    vim.keymap.set('n', '<leader>tM', ':Markview toggle<CR>', { desc = 'Toggle Markdown preview' })
    vim.keymap.set('n', '<leader>tm', ':Markview splitToggle<CR>', { desc = 'Toggle Markdown split preview' })
end
