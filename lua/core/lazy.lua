-- Core lazy.nvim setup - CLEAN VERSION
-- Plugin manager initialization with category-based imports

-- Set leaders early
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

-- Install lazy.nvim if not present
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system {
        'git',
        'clone',
        '--filter=blob:none',
        '--branch=stable',
        lazyrepo,
        lazypath,
    }
    if vim.v.shell_error ~= 0 then
        error('Error cloning lazy.nvim:\n' .. out)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim with category imports + essential plugins
require('lazy').setup({
    -- Import plugin categories
    { import = 'plugins.ui' },
    { import = 'plugins.editor' },
    { import = 'plugins.tools' },
    { import = 'plugins.lsp' },
    { import = 'plugins.ai' },
}, {
    defaults = {
        lazy = false,
        version = nil,
    },
    install = {
        colorscheme = { 'tokyonight', 'habamax' },
    },
    checker = {
        enabled = true,
        notify = false,
    },
    performance = {
        rtp = {
            disabled_plugins = {
                'gzip',
                'netrwPlugin',
                'spellfile_plugin',
                'tarPlugin',
                'tohtml',
                'tutor',
                'zipPlugin',
            },
        },
    },
    ui = {
        icons = vim.g.have_nerd_font and {} or {
            cmd = '⌘',
            config = '🛠',
            event = '📅',
            ft = '📂',
            init = '⚙',
            keys = '🗝',
            plugin = '🔌',
            runtime = '💻',
            require = '🌙',
            source = '📄',
            start = '🚀',
            task = '📌',
            lazy = '💤 ',
        },
    },
})
