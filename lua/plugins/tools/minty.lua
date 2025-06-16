return {
    {
        'nvzone/minty',
        cmd = { 'Shades', 'Huefy' },
    },
    {
        vim.keymap.set('n', '<leader>ts', ':Shades<CR>', { desc = '[T]ool: [S]hades' }),
    },
}
