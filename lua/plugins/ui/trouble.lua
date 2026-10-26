-- better diagnostics list and others

return function()
    local opts = {
        modes = {
            lsp = {
                win = { position = 'right' },
            },
        },
    }
    require('trouble').setup(opts)
    vim.keymap.set('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', { desc = 'Toggle diagnostics list' })
    vim.keymap.set('n', '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', { desc = 'Toggle buffer diagnostics list' })
    vim.keymap.set('n', '<leader>cs', '<cmd>Trouble symbols toggle<cr>', { desc = 'Toggle document symbols' })
    vim.keymap.set('n', '<leader>cS', '<cmd>Trouble lsp toggle<cr>', { desc = 'Toggle LSP navigation list' })
    vim.keymap.set('n', '<leader>xL', '<cmd>Trouble loclist toggle<cr>', { desc = 'Toggle location list' })
    vim.keymap.set('n', '<leader>xQ', '<cmd>Trouble qflist toggle<cr>', { desc = 'Toggle quickfix list' })
    vim.keymap.set('n', '[q', function()
        if require('trouble').is_open() then
            ---@diagnostic disable-next-line: missing-parameter, missing-fields
            require('trouble').prev { skip_groups = true, jump = true }
        else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
                vim.notify(err, vim.log.levels.ERROR)
            end
        end
    end, { desc = 'Previous list item' })
    vim.keymap.set('n', ']q', function()
        if require('trouble').is_open() then
            ---@diagnostic disable-next-line: missing-parameter, missing-fields
            require('trouble').next { skip_groups = true, jump = true }
        else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
                vim.notify(err, vim.log.levels.ERROR)
            end
        end
    end, { desc = 'Next list item' })
end
