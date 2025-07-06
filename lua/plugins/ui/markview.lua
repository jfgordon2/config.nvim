-- https://github.com/OXY2DEV/markview.nvim
-- Preview markdown
return {
    'OXY2DEV/markview.nvim',
    lazy = false, -- Recommended
    -- ft = "markdown" -- If you decide to lazy-load anyway

    dependencies = {
        'nvim-tree/nvim-web-devicons',
        'echasnovski/mini.icons',
    },
    config = function()
        require('markview').setup {
            preview = {
                enable = false,
                icon_provider = 'mini',
            },
            experimental = {
                check_rtp_message = false,
            },
        }
        vim.keymap.set('n', '<leader>tM', ':Markview toggle<CR>', { desc = '[T]oggle [M]arkdown Preview' })
        vim.keymap.set('n', '<leader>tm', ':Markview splitToggle<CR>', { desc = '[T]oggle [M]arkdown Split Preview' })
    end,
}
