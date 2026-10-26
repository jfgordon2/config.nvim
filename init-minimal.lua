-- Minimal native startup for diagnosing plugin setup independently.
assert(vim.fn.has 'nvim-0.12' == 1, 'Neovim 0.12+ required')
vim.loader.enable()
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true
require 'config.options'
require('config.pack_build').setup()
local wanted = {
    ['tokyonight.nvim'] = true,
    ['nvim-treesitter'] = true,
    ['markview.nvim'] = true,
    ['mini.nvim'] = true,
    ['nvim-web-devicons'] = true,
    ['plenary.nvim'] = true,
    ['telescope.nvim'] = true,
    ['telescope-fzf-native.nvim'] = true,
    ['telescope-ui-select.nvim'] = true,
}
vim.pack.add(vim.tbl_filter(function(spec)
    return wanted[spec.src:match '/([^/]+)%.git$']
end, require 'config.packages'))
require 'plugins.ui.colorscheme'()
require('mini.icons').setup()
require 'plugins.ui.markview'()
require 'plugins.editor.treesitter'()
require 'plugins.tools.telescope'()
