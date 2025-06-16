return {
    {
        'stevearc/oil.nvim',
        ---@module 'oil'
        ---@type oil.SetupOpts
        opts = {
            columns = {
                'icon',
                -- "permissions",
                'size',
                'mtime',
            },
            default_file_explorer = false,
            delete_to_trash = true,
            view_options = {
                show_hidden = true,
            },
            win_options = {
                wrap = true,
            },
        },
        dependencies = {
            { 'nvim-tree/nvim-web-devicons' },
        },
    },
    {
        vim.keymap.set('n', '-', '<CMD>Oil --float<CR>', { desc = 'Open parent directory' }),
    },
    {
        'Eutrius/Otree.nvim',
        lazy = false,
        dependencies = {
            'stevearc/oil.nvim',
            'nvim-tree/nvim-web-devicons',
        },
        config = function()
            require('Otree').setup()
        end,
    },
}
