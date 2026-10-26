return function()
    local opts = {
        settings = {
            options = {
                notify_user_on_venv_activation = true,
            },
        },
    }
    require('venv-selector').setup(opts)
    vim.api.nvim_create_autocmd('FileType', {
        pattern = 'python',
        callback = function(event)
            vim.keymap.set('n', '<leader>cv', '<cmd>:VenvSelect<cr>', { buffer = event.buf, desc = 'Choose Python environment' })
        end,
    })
end
