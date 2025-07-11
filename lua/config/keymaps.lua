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

-- Format highlighted JSON text in place or whole file
vim.keymap.set('v', '<leader>cj', function()
    local start_line = math.min(vim.fn.line "'<", vim.fn.line "'>") - 1
    local end_line = math.max(vim.fn.line "'<", vim.fn.line "'>")

    local selected_text = vim.api.nvim_buf_get_lines(0, start_line, end_line, false)
    local text_to_format = table.concat(selected_text, '\n')

    local formatted = vim.fn.system('jq .', text_to_format)

    if vim.v.shell_error == 0 and formatted then
        -- Save cursor position
        local cursor_pos = vim.fn.getpos '.'
        -- Replace the selection with formatted text
        vim.api.nvim_buf_set_lines(0, start_line, end_line, false, vim.split(formatted, '\n'))
        -- Restore cursor position
        vim.fn.setpos('.', cursor_pos)
    else
        vim.notify(formatted or 'Invalid JSON', vim.log.levels.ERROR, { title = 'JSON Format Error' })
    end
end, { desc = '[C]ode: Format JSON' })

vim.keymap.set('n', '<leader>cj', function()
    local content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), '\n')

    local formatted = vim.fn.system('jq .', content)

    if vim.v.shell_error == 0 and formatted then
        -- Save cursor position
        local cursor_pos = vim.fn.getpos '.'
        -- Replace buffer content
        vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(formatted, '\n'))
        -- Restore cursor position
        vim.fn.setpos('.', cursor_pos)
    else
        vim.notify(formatted or 'Invalid JSON', vim.log.levels.ERROR, { title = 'JSON Format Error' })
    end
end, { desc = '[C]ode: Format JSON (whole file)' })

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
