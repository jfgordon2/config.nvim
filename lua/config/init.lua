assert(vim.fn.has 'nvim-0.12' == 1, 'This configuration requires Neovim 0.12 or newer')
vim.loader.enable()
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true
-- Override an inherited MASON path so test tools remain isolated.
vim.env.MASON = vim.fn.stdpath 'data' .. '/mason'
require 'config.options'
for _, plugin in ipairs { 'gzip', 'netrwPlugin', 'spellfile_plugin', 'tarPlugin', 'tohtml', 'tutor', 'zipPlugin' } do
    vim.g['loaded_' .. plugin] = 1
end
require 'config.pack'
require 'config.autocmds'
require 'config.keymaps'
