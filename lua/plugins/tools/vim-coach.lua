return function()
    local opts = {
        window = {
            border = 'rounded',
            title_pos = 'center',
        },
        keymaps = {
            copy_keymap = '<C-y>',
            close = '<Esc>',
        },
    }
    require('vim-coach').setup(opts)
end
