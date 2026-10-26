local buffers = require 'config.buffers'
local icons = require 'config.icons'

-- Bufferline - Enhanced buffer line
-- Buffer tabs with icons and diagnostics

return function()
    local opts = {
        options = {
            close_command = buffers.delete,
            right_mouse_command = buffers.delete,
            diagnostics = 'nvim_lsp',
            always_show_bufferline = false,
            diagnostics_indicator = function(_, _, diag)
                local icons = icons.diagnostics
                local ret = (diag.error and icons.Error .. diag.error .. ' ' or '') .. (diag.warning and icons.Warn .. diag.warning or '')
                return vim.trim(ret)
            end,
            offsets = {
                {
                    filetype = 'neo-tree',
                    text = 'Neo-tree',
                    highlight = 'Directory',
                    text_align = 'left',
                },
            },
            buffer_close_icon = icons.misc.buffer_close_icon,
            modified_icon = icons.misc.modified_icon,
            close_icon = icons.misc.close_icon,
            left_trunc_marker = icons.misc.left_trunc_marker,
            right_trunc_marker = icons.misc.right_trunc_marker,
            color_icons = true,
            get_element_icon = function(opts)
                local icon, hl = require('nvim-web-devicons').get_icon_by_filetype(opts.filetype, { default = false })
                return icon, hl
            end,
            separator_style = { '󰽣', '󰽡' },
        },
    }
    require('bufferline').setup(opts)

    vim.keymap.set('n', '<leader>bp', '<Cmd>BufferLineTogglePin<CR>', { desc = 'Toggle buffer pin' })
    vim.keymap.set('n', '<leader>bP', '<Cmd>BufferLineGroupClose ungrouped<CR>', { desc = 'Delete unpinned buffers' })
    vim.keymap.set('n', '<leader>br', '<Cmd>BufferLineCloseRight<CR>', { desc = 'Delete buffers to the right' })
    vim.keymap.set('n', '<leader>bl', '<Cmd>BufferLineCloseLeft<CR>', { desc = 'Delete buffers to the left' })
    vim.keymap.set('n', '<S-h>', '<cmd>BufferLineCyclePrev<cr>', { desc = 'Previous buffer' })
    vim.keymap.set('n', '<S-l>', '<cmd>BufferLineCycleNext<cr>', { desc = 'Next buffer' })
    vim.keymap.set('n', '[b', '<cmd>BufferLineCyclePrev<cr>', { desc = 'Previous buffer' })
    vim.keymap.set('n', ']b', '<cmd>BufferLineCycleNext<cr>', { desc = 'Next buffer' })
    vim.keymap.set('n', '[B', '<cmd>BufferLineMovePrev<cr>', { desc = 'Move buffer left' })
    vim.keymap.set('n', ']B', '<cmd>BufferLineMoveNext<cr>', { desc = 'Move buffer right' })
end
