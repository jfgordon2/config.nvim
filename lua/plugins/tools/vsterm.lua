return {
    'jfgordon2/vsterm.nvim',
    opts = {
        height = 0.27,
        default_name = 'Terminal %d',
        shell = vim.o.shell,
        list_width = 25,
        enable_mouse = true,
        number_prefix = '<leader>v',
        mappings = {
            toggle = '<leader>vv',
            new = '<leader>vn',
            kill = '<leader>vk',
            rename = '<leader>vr',
        },
    },
}
