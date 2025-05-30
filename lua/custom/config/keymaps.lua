-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- escape terminal mode using esc+esc instead of this nonsense <c-\><c-n>
vim.keymap.set('t', '<esc><esc>', '<c-\\><c-n>', { desc = 'Return terminal to normal mode ' })

-- open a terminal along the bottom of the screen that we can send commands to
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

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- lazygit
if vim.fn.executable 'lazygit' == 1 then
    vim.keymap.set('n', '<leader>gg', function()
        ---@diagnostic disable-next-line: missing-fields
        Snacks.lazygit { cwd = Snacks.git.get_root() }
    end, { desc = '[G]it: Lazygit (Root Dir)' })
    vim.keymap.set('n', '<leader>gG', function()
        Snacks.lazygit()
    end, { desc = '[G]it: Lazygit (cwd)' })
    vim.keymap.set('n', '<leader>gf', function()
        Snacks.picker.git_log_file()
    end, { desc = '[G]it: Current [F]ile History' })
    vim.keymap.set('n', '<leader>gl', function()
        ---@diagnostic disable-next-line: missing-fields
        Snacks.picker.git_log { cwd = Snacks.git.get_root() }
    end, { desc = '[G]it: [L]og' })
    vim.keymap.set('n', '<leader>gL', function()
        Snacks.picker.git_log()
    end, { desc = '[G]it [L]og (cwd)' })
end
if vim.fn.executable 'gh' == 1 then
    vim.keymap.set('n', '<leader>gb', function()
        vim.fn.system 'gh browse'
    end, { desc = '[G]it: [B]rowse' })
end

-- Notifier
vim.keymap.set('n', '<leader>nn', function()
    Snacks.notifier.show_history()
end, { desc = '[N]notifications: Show [N]notifications History' })
vim.keymap.set('n', '<leader>nh', function()
    Snacks.notifier.hide()
end, { desc = '[N]notifications: [H]ide' })
vim.keymap.set('n', '<leader>ng', function()
    Snacks.notifier.get_history()
end, { desc = '[N]notifications: [G]et History' })

-- Copilot
vim.keymap.set('n', '<leader>aa', '<cmd>CodeCompanionActions<CR>', { desc = '[A]i: [A]ctions palette' })
vim.keymap.set('n', '<leader>ac', '<cmd>CodeCompanionChat<CR>', { desc = '[A]i: Chat' })

-- GitHub Notifications
vim.api.nvim_set_keymap('n', '<leader>gn', '<cmd>GHNotifications<CR>', { noremap = true, silent = true, desc = 'GitHub Notifications' })

-- Fugitive Keymaps
vim.keymap.set('n', '<leader>gv', '<cmd>Gvdiffsplit<CR>', { noremap = true, silent = true, desc = '[G]it: [V]ertical Diffsplit' })

-- Workspace
vim.keymap.set('n', '<leader>wd', function()
    Snacks.dashboard.open()
end, { desc = '[W]orkspace: Show [D]ashboard' })
vim.keymap.set('n', '<leader>wf', function()
    os.execute('open ' .. Snacks.git.get_root())
end, { desc = '[W]orkspce: Open in Finder' })
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

-- Buffers
vim.keymap.set('n', '<leader>bd', function()
    Snacks.bufdelete()
end, { desc = 'Delete Buffer' })
vim.keymap.set('n', '<leader>bo', function()
    Snacks.bufdelete.other()
end, { desc = 'Delete Other Buffers' })

-- Diagnostics

vim.keymap.set('n', '<leader>tt', function()
    if vim.diagnostic.is_enabled() then
        vim.diagnostic.enable(false)
    else
        vim.diagnostic.enable(true)
    end
end, { noremap = true, silent = true, desc = '[T]oggle [T]rouble Diagnositcs' })

-- typescript hover doc
vim.keymap.set('n', 'K', '<cmd>Lspsaga hover_doc<CR>', { desc = 'Hover function definition' })
