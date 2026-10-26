return function()
    local opts = {}
    require('minty').setup(opts)
    vim.keymap.set('n', '<leader>uc', ':Shades<CR>', { desc = 'Pick color (Shades)' })
end
