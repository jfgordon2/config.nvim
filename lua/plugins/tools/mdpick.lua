return function()
    local opts = {
        picker = 'fzf',
        preview_window = 'right,80%,wrap',
    }
    require('mdpick').setup(opts)
    vim.keymap.set('n', '<leader>md', '<cmd>MdPick<cr>', { desc = 'Pick Markdown document' })
end
