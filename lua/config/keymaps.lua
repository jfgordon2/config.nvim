-- Global keymaps
-- These are general keymaps not specific to any plugin

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>xq', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Terminal mode shortcuts
vim.keymap.set('t', '<esc><esc>', '<c-\\><c-n>', { desc = 'Return terminal to normal mode' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Window navigation - Use CTRL+<hjkl> to switch between windows
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Buffer management
vim.keymap.set('n', '<leader>bd', function()
    if LazyVim and LazyVim.has 'snacks.nvim' then
        Snacks.bufdelete()
    else
        vim.cmd 'bdelete'
    end
end, { desc = 'Delete Buffer' })

vim.keymap.set('n', '<leader>bo', function()
    if LazyVim and LazyVim.has 'snacks.nvim' then
        Snacks.bufdelete.other()
    else
        vim.cmd 'bufdo bdelete'
    end
end, { desc = 'Delete Other Buffers' })

-- Toggle diagnostics
vim.keymap.set('n', '<leader>tt', function()
    if vim.diagnostic.is_enabled() then
        vim.diagnostic.enable(false)
    else
        vim.diagnostic.enable(true)
    end
end, { noremap = true, silent = true, desc = '[T]oggle [T]rouble Diagnostics' })

-- Terminal management
local job_id = 0
vim.keymap.set('n', '<space>to', function()
    vim.cmd.vnew()
    vim.cmd.term()
    vim.cmd.wincmd 'J'
    vim.api.nvim_win_set_height(0, 15)
    job_id = vim.bo.channel
end, { desc = '[T]erminal: [O]pen' })

local current_command = ''
vim.keymap.set('n', '<space>te', function()
    current_command = vim.fn.input 'Command: '
    if job_id ~= 0 then
        vim.fn.chansend(job_id, { current_command .. '\r\n' })
    else
        vim.cmd 'echo "Terminal is not open"'
    end
end, { desc = '[T]erminal: [E]xecute a command' })

vim.keymap.set('n', '<space>tr', function()
    if current_command == '' then
        current_command = vim.fn.input 'Command: '
    end
    if job_id ~= 0 then
        vim.fn.chansend(job_id, { current_command .. '\r\n' })
    else
        vim.cmd 'echo "Terminal is not open"'
    end
end, { desc = '[T]erminal: [R]epeat last command' })
