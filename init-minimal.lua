-- Minimal working configuration for testing

local minimal_parsers = { 'lua', 'vim', 'vimdoc', 'query' }

local function enable_minimal_treesitter(buf)
    if not vim.api.nvim_buf_is_valid(buf) or vim.bo[buf].buftype ~= '' then
        return
    end

    local ok = pcall(vim.treesitter.start, buf)
    if ok then
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
end

local function install_minimal_parsers(nvim_treesitter)
    local installed = {}
    for _, parser in ipairs(nvim_treesitter.get_installed 'parsers') do
        installed[parser] = true
    end

    local missing = {}
    for _, parser in ipairs(minimal_parsers) do
        if not installed[parser] then
            table.insert(missing, parser)
        end
    end

    if #missing > 0 then
        nvim_treesitter.install(missing)
    end
end

local function setup_minimal_treesitter()
    local nvim_treesitter = require 'nvim-treesitter'
    nvim_treesitter.setup {
        install_dir = vim.fn.stdpath 'data' .. '/site',
    }

    install_minimal_parsers(nvim_treesitter)

    local group = vim.api.nvim_create_augroup('minimal_treesitter', { clear = true })
    vim.api.nvim_create_autocmd('FileType', {
        group = group,
        pattern = '*',
        callback = function(event)
            enable_minimal_treesitter(event.buf)
        end,
    })
end

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
        '--branch=main',
        lazypath,
    }
end
---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

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
        branch = 'main',
        lazy = false,
        build = ':TSUpdate',
        config = setup_minimal_treesitter,
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
