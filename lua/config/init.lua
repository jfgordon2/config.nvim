-- Main configuration entry point
-- This file orchestrates the loading of all configuration modules

-- Initialize LazyVim utilities and config defaults first
_G.LazyVim = require 'config.utils'

-- Load vim options early
require 'config.options'

-- Setup lazy.nvim and load plugins
require 'config.lazy'

-- Setup autocmds and keymaps after plugins load
vim.api.nvim_create_autocmd('User', {
    pattern = 'VeryLazy',
    callback = function()
        require 'config.autocmds'
        require 'config.keymaps'

        -- Load colorscheme after all plugins are loaded
        vim.schedule(function()
            local ok, tokyonight = pcall(require, 'tokyonight')
            if ok then
                tokyonight.load()
            else
                vim.cmd.colorscheme 'habamax'
            end
        end)
    end,
})
