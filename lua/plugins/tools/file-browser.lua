return function()
    require('telescope').load_extension 'file_browser'

    vim.keymap.set('n', '<leader>sB', ':Telescope file_browser path=%:p:h=%:p:h<cr>', { desc = 'Browse Files' })
end
