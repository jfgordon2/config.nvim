-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Remove line numbers when opening a terminal
vim.api.nvim_create_autocmd('TermOpen', {
    group = vim.api.nvim_create_augroup('custom-term-open', { clear = true }),
    callback = function()
        vim.opt.number = false
        vim.opt.relativenumber = false
        vim.opt.laststatus = 0
    end,
})

-- Set the CWD to the root directory of the currently open file
vim.api.nvim_create_autocmd('BufEnter', {
    pattern = '*',
    callback = function()
        local root_path = Snacks.git.get_root()
        if root_path then
            vim.cmd('cd ' .. root_path)
        end
    end,
})

-- local timer = nil
-- vim.api.nvim_create_autocmd('BufEnter', {
--     group = vim.api.nvim_create_augroup('custom-vim-enter', { clear = true }),
--     callback = function()
--         if timer == nil then
--             timer = vim.uv.new_timer()
--             -- Repeat every hour while the editor is open
--             local timer_interval = (60 * 60 * 1000)
--             timer:start(0, timer_interval, function()
--                 vim.schedule(function()
--                     vim.cmd 'GHNotifications'
--                 end)
--             end)
--         end
--     end,
-- })
