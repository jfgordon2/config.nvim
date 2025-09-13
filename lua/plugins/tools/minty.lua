return {
    {
        'nvzone/minty',
        dependencies = { 'nvzone/volt' },
        cmd = { 'Shades', 'Huefy' },
        opts = {},
    },
    {
        vim.keymap.set('n', '<leader>ts', ':Shades<CR>', { desc = '[T]ool: [S]hades' }),
    },
}
