-- Highlight todo, notes, etc in comments
-- Finds and lists all of the TODO, HACK, BUG, etc comment
-- in your project and loads them into a browsable list.

return function()
    local opts = { signs = false }
    require('todo-comments').setup(opts)
    vim.keymap.set('n', ']t', function()
        require('todo-comments').jump_next()
    end, { desc = 'Next TODO comment' })
    vim.keymap.set('n', '[t', function()
        require('todo-comments').jump_prev()
    end, { desc = 'Previous TODO comment' })
    vim.keymap.set('n', '<leader>xt', '<cmd>Trouble todo toggle<cr>', { desc = 'Toggle TODO list' })
    vim.keymap.set('n', '<leader>xT', '<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>', { desc = 'Toggle TODO/FIX/FIXME list' })
    vim.keymap.set('n', '<leader>st', '<cmd>TodoTelescope<cr>', { desc = 'Find TODO comments' })
    vim.keymap.set('n', '<leader>sT', '<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>', { desc = 'Find TODO/FIX/FIXME comments' })
end
