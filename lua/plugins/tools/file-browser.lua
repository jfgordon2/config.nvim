return function()
    require('telescope').load_extension 'file_browser'

    vim.keymap.set('n', '<leader>ef', function()
        local path = vim.api.nvim_buf_get_name(0)
        local directory = path == '' and vim.uv.cwd() or vim.fs.dirname(path)
        require('telescope').extensions.file_browser.file_browser { path = directory }
    end, { desc = 'Browse files in buffer directory' })
end
