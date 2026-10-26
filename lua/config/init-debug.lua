require 'config'
vim.api.nvim_create_autocmd('VimEnter', {
    once = true,
    callback = function()
        vim.schedule(function()
            local plugins = vim.pack.get(nil, { info = false })
            print(('Native plugins: %d; data: %s'):format(#plugins, vim.fn.stdpath 'data'))
            vim.print(plugins)
        end)
    end,
})
