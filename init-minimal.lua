-- Minimal working configuration for testing

-- Set leaders
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

-- Load vim options
require 'config.options'

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system {
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable',
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim with explicit plugin list
require('lazy').setup({
    -- Colorscheme
    {
        'folke/tokyonight.nvim',
        priority = 1000,
        config = function()
            require('tokyonight').load()
        end,
    },

    -- Dashboard and utilities
    {
        'folke/snacks.nvim',
        priority = 1000,
        lazy = false,
        config = function()
            require('snacks').setup {
                dashboard = { enabled = true },
                notifier = { enabled = true },
                quickfile = { enabled = true },
            }
        end,
    },

    -- Treesitter
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = function()
            require('nvim-treesitter.configs').setup {
                ensure_installed = { 'lua', 'vim', 'vimdoc', 'query' },
                highlight = { enable = true },
            }
        end,
    },

    -- Telescope
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.6',
        dependencies = { 'nvim-lua/plenary.nvim' },
        keys = {
            { '<leader>sf', '<cmd>Telescope find_files<cr>', desc = 'Find files' },
            { '<leader>sg', '<cmd>Telescope live_grep<cr>', desc = 'Live grep' },
        },
    },
}, {
    install = { colorscheme = { 'tokyonight', 'habamax' } },
    checker = { enabled = true },
})

print '✅ Minimal config loaded successfully!'
