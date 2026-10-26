return function()
    local opts = require 'data.fortunes'
    require('fortune').setup(opts)
    vim.keymap.set('n', '<leader>nf', function()
        local fortune_table = require('fortune').get_fortune()
        local text = ''
        for _, fortune in ipairs(fortune_table) do
            if fortune == '' then
                text = text .. '\n'
            else
                text = text .. fortune .. '\n'
            end
        end
        vim.notify(text, vim.log.levels.INFO, { title = 'Fortune', icon = '󰮥 ' })
    end, { desc = 'Show a fortune' })
end
