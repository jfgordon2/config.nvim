return {
    {
        'nvzone/floaterm',
        enabled = false,
        dependencies = 'nvzone/volt',
        cmd = 'FloatermToggle',
        opts = {
            border = false,
            size = { h = 60, w = 70 },

            -- to use, make this func(buf)
            -- mappings = { sidebar = nil, term = nil },
            mappings = {
                sidebar = function(buf)
                    vim.keymap.set('n', '<leader>fs', function()
                        require('floaterm.api').switch_wins()
                    end, { buffer = buf, desc = '[F]loaterm: [S]witch to term' })
                    vim.keymap.set('n', '<leader>fr', function()
                        require('floaterm.api').edit_name()
                    end, { buffer = buf, desc = '[F]loaterm: [R]ename terminal' })
                    vim.keymap.set('n', '<leader>fn', function()
                        require('floaterm.api').new_term()
                    end, { buffer = buf, desc = '[F]loaterm: [N]ew terminal' })
                end,
                term = function(buf)
                    vim.keymap.set('n', '<Esc>', function() end, { buffer = buf, desc = 'Prevent Esc from closing terminal' })
                    vim.keymap.set({ 'n', 't' }, '<leader>fc', function()
                        require('floaterm.api').cycle_term_bufs 'prev'
                    end, { buffer = buf, desc = '[F]loaterm: [C]ycle terminals' })
                    vim.keymap.set({ 'n', 't' }, '<leader>fn', function()
                        require('floaterm.api').new_term 'Terminal'
                    end, { buffer = buf, desc = '[F]loaterm: [N]ew terminal' })
                    vim.keymap.set({ 'n', 't' }, '<leader>fs', function()
                        require('floaterm.api').switch_wins()
                    end, { buffer = buf, desc = '[F]loaterm: [S]witch to sidebar' })
                    vim.keymap.set({ 'n', 't' }, '<leader>fx', function()
                        local state = require 'floaterm.state'
                        local utils = require 'floaterm.utils'
                        local volt_redraw = require('volt').redraw
                        if not state.terminals or #state.terminals == 0 then
                            return
                        end
                        local cur_index = utils.get_term_by_buf(state.buf)
                        if not cur_index then
                            return
                        end
                        table.remove(state.terminals, cur_index[1])
                        vim.keymap.del('n', tostring(cur_index[1]), { buffer = state.sidebuf })
                        -- vim.api.nvim_buf_delete(state.buf, { force = true })
                        volt_redraw(state.sidebuf, 'bufs')
                        require('floaterm.api').cycle_term_bufs 'next'
                        require('floaterm').toggle()
                        require('floaterm').toggle()
                    end, { buffer = buf, desc = '[F]loaterm: [X] Close terminal' })
                    vim.keymap.set('n', '<leader>fr', function()
                        local state = require 'floaterm.state'
                        local utils = require 'floaterm.utils'
                        local volt_redraw = require('volt').redraw
                        local cur_index = utils.get_term_by_buf(state.buf)
                        vim.ui.input({ prompt = '   Enter name: ' }, function(input)
                            state.terminals[cur_index[1]].name = input or state.terminals[cur_index[1]].name
                            vim.api.nvim_echo({}, false, {})
                            volt_redraw(state.sidebuf, 'bufs')
                        end)
                    end, { buffer = buf, desc = '[F]loaterm: [R]ename terminal' })
                    vim.keymap.set('n', '<leader>fg', function()
                        local line = vim.fn.getline '.'
                        local filepath, line_num, col = line:match '([^:]+):(%d+):(%d):'
                        if not filepath then
                            filepath, line_num = line:match '([^:]+):(%d+)'
                        end
                        if not filepath then
                            filepath = vim.fn.expand '<cfile>'
                        end
                        if filepath then
                            require('floaterm').toggle()
                            vim.cmd('edit ' .. filepath)
                            if line_num then
                                line_num = tonumber(line_num)
                                col = tonumber(col) or 0
                                vim.api.nvim_win_set_cursor(0, { line_num, col })
                            end
                        end
                    end, { desc = '[F]loaterm: [G]oto current file', buffer = buf })
                end,
            },
            -- Default sets of terminals you'd like to open
            terminals = {
                { name = 'Terminal' },
                -- cmd can be function too
                -- { name = 'Terminal', cmd = 'neofetch' },
                -- More terminals
            },
        },
    },
    {
        -- vim.keymap.set('n', '<leader>ff', function()
        --     require('floaterm').toggle()
        -- end, { desc = '[F]loaterm: Toggle' }),
        -- vim.keymap.set('n', '<leader>fq', function()
        --     local state = require 'floaterm.state'
        --     local utils = require 'floaterm.utils'
        --     if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
        --         vim.api.nvim_buf_delete(state.buf, { force = true })
        --         state.terminals = nil
        --         state.buf = nil
        --     end
        --     if state.sidebuf and vim.api.nvim_buf_is_valid(state.sidebuf) then
        --         vim.api.nvim_buf_delete(state.sidebuf, { force = true })
        --         state.sidebuf = nil
        --     end
        --     if state.barbuf and vim.api.nvim_buf_is_valid(state.barbuf) then
        --         vim.api.nvim_buf_delete(state.barbuf, { force = true })
        --         state.barbuf = nil
        --     end
        --     if state.terminals and #state.terminals > 0 then
        --         for _, term in ipairs(state.terminals) do
        --             if term.buf and vim.api.nvim_buf_is_valid(term.buf) then
        --                 vim.api.nvim_buf_delete(term.buf, { force = true })
        --             end
        --         end
        --         state.terminals = nil
        --     end
        --     if state.termbuf_session_timer then
        --         utils.close_timers()
        --     end
        --     state.volt_set = false
        -- end, { desc = '[F]loaterm: [Q]uit' }),
    },
}
