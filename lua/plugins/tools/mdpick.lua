return {
    'jfgordon2/mdpick.nvim',
    opts = {
        picker = 'fzf',
        preview_window = 'right,80%,wrap',
    },
    keys = {
        { '<leader>md', '<cmd>MdPick<cr>', desc = 'Pick Markdown document' },
    },
}
