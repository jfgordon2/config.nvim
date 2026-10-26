return function()
    local opts = {}
    require('minty').setup(opts)
    vim.keymap.set('n', '<leader>ts', ':Shades<CR>', { desc = '[T]ool: [S]hades' })
end
