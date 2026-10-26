return function()
    local opts = { headerMaxWidth = 80 }
    require('grug-far').setup(opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>sR', function()
        local grug = require 'grug-far'
        local ext = vim.bo.buftype == '' and vim.fn.expand '%:e'
        grug.open {
            transient = true,
            prefills = {
                filesFilter = ext and ext ~= '' and '*.' .. ext or nil,
            },
        }
    end, { desc = 'Search and replace' })
end
