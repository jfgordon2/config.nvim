local buffers = require 'config.buffers'

-- Global keymaps
-- These are general keymaps not specific to any plugin

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>xq', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Terminal mode shortcuts
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Window navigation - Use CTRL+<hjkl> to switch between windows
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Resize window using <ctrl> arrow keys
vim.keymap.set('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase Window Height' })
vim.keymap.set('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease Window Height' })
vim.keymap.set('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease Window Width' })
vim.keymap.set('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase Window Width' })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set('n', 'n', "'Nn'[v:searchforward].'zv'", { expr = true, desc = 'Next Search Result' })
vim.keymap.set('x', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
vim.keymap.set('o', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
vim.keymap.set('n', 'N', "'nN'[v:searchforward].'zv'", { expr = true, desc = 'Prev Search Result' })
vim.keymap.set('x', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })
vim.keymap.set('o', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })

-- Buffer management
vim.keymap.set('n', '<leader>bd', buffers.delete, { desc = 'Delete Buffer' })

vim.keymap.set('n', '<leader>bo', buffers.others, { desc = 'Delete Other Buffers' })

-- Toggle diagnostics
vim.keymap.set('n', '<leader>tt', function()
    if vim.diagnostic.is_enabled() then
        vim.diagnostic.enable(false)
    else
        vim.diagnostic.enable(true)
    end
end, { noremap = true, silent = true, desc = '[T]oggle [T]rouble Diagnostics' })

-- Terminal management
-- local job_id = 0
-- vim.keymap.set('n', '<space>to', function()
--     vim.cmd.vnew()
--     vim.cmd.term()
--     vim.cmd.wincmd 'J'
--     vim.api.nvim_win_set_height(0, 15)
--     job_id = vim.bo.channel
-- end, { desc = '[T]erminal: [O]pen' })
--
-- local current_command = ''
-- vim.keymap.set('n', '<space>te', function()
--     current_command = vim.fn.input 'Command: '
--     if job_id ~= 0 then
--         vim.fn.chansend(job_id, { current_command .. '\r\n' })
--     else
--         vim.cmd 'echo "Terminal is not open"'
--     end
-- end, { desc = '[T]erminal: [E]xecute a command' })
--
-- vim.keymap.set('n', '<space>tr', function()
--     if current_command == '' then
--         current_command = vim.fn.input 'Command: '
--     end
--     if job_id ~= 0 then
--         vim.fn.chansend(job_id, { current_command .. '\r\n' })
--     else
--         vim.cmd 'echo "Terminal is not open"'
--     end
-- end, { desc = '[T]erminal: [R]epeat last command' })

-- Format JSON in the whole buffer or the active Visual selection.
local json = require 'config.json'
vim.keymap.set('x', '<leader>cj', json.selection, { desc = '[C]ode: Format JSON selection' })
vim.keymap.set('n', '<leader>cj', json.file, { desc = '[C]ode: Format JSON (whole file)' })

-- Convert leading indentation and configure subsequent edits in this buffer.
local function convert_indentation(use_spaces)
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.softtabstop = use_spaces and 4 or 0
    vim.bo.vartabstop = ''
    vim.bo.varsofttabstop = ''
    vim.bo.expandtab = use_spaces
    vim.cmd '%retab! -indentonly'
end

vim.keymap.set('n', '<leader>c4', function()
    convert_indentation(true)
end, { desc = '[C]ode: Convert indentation to [4] spaces' })
vim.keymap.set('n', '<leader>ct', function()
    convert_indentation(false)
end, { desc = '[C]ode: Convert indentation to [t]abs (width 4)' })

vim.keymap.set('n', '<leader>ww', function()
    local on_exit = function(obj)
        if obj.code == 0 then
            vim.schedule(function()
                local normalize = string.gsub(obj.stdout, '"', '')
                vim.notify(normalize, vim.log.levels.INFO, { title = 'Davenport, IA' })
            end)
        else
            vim.schedule(function()
                vim.notify(vim.json.encode(obj))
            end)
        end
    end
    vim.system({ 'curl', '-s', 'https://wttr.in/52803?format="%c%20Actual:%20%t,%20Feels:%20%f%20Precip:%20%p"&u' }, { text = true }, on_exit)
end, { desc = '[W]orkspace: Show [W]eather' })

-- Copy filepath to clipboard
vim.keymap.set('n', '<leader>cp', function()
    vim.fn.setreg('+', vim.fn.expand '%')
end, { desc = '[C]ode: Yank file [p]ath to clipboard' })
