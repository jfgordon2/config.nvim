-- Bufferline - Enhanced buffer line
-- Buffer tabs with icons and diagnostics

return {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    event = 'VeryLazy',
    keys = {
        { '<leader>bp', '<Cmd>BufferLineTogglePin<CR>', desc = 'Toggle Pin' },
        { '<leader>bP', '<Cmd>BufferLineGroupClose ungrouped<CR>', desc = 'Delete Non-Pinned Buffers' },
        { '<leader>bo', '<Cmd>BufferLineCloseOthers<CR>', desc = 'Delete Other Buffers' },
        { '<leader>br', '<Cmd>BufferLineCloseRight<CR>', desc = 'Delete Buffers to the Right' },
        { '<leader>bl', '<Cmd>BufferLineCloseLeft<CR>', desc = 'Delete Buffers to the Left' },
        { '<S-h>', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev Buffer' },
        { '<S-l>', '<cmd>BufferLineCycleNext<cr>', desc = 'Next Buffer' },
        { '[b', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev Buffer' },
        { ']b', '<cmd>BufferLineCycleNext<cr>', desc = 'Next Buffer' },
        { '[B', '<cmd>BufferLineMovePrev<cr>', desc = 'Move buffer prev' },
        { ']B', '<cmd>BufferLineMoveNext<cr>', desc = 'Move buffer next' },
    },
    opts = {
        options = {
            close_command = function(n)
                local snacks = require 'snacks'
                if snacks and snacks.bufdelete then
                    snacks.bufdelete(n)
                else
                    vim.api.nvim_buf_delete(n, { force = true })
                end
            end,
            right_mouse_command = function(n)
                local snacks = require 'snacks'
                if snacks and snacks.bufdelete then
                    snacks.bufdelete(n)
                else
                    vim.api.nvim_buf_delete(n, { force = true })
                end
            end,
            diagnostics = 'nvim_lsp',
            always_show_bufferline = false,
            diagnostics_indicator = function(_, _, diag)
                local icons = _G.LazyVim.config.icons.diagnostics
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
            buffer_close_icon = _G.LazyVim.config.icons.misc.buffer_close_icon or '󰅖',
            modified_icon = _G.LazyVim.config.icons.misc.modified_icon or '● ',
            close_icon = _G.LazyVim.config.icons.misc.close_icon or ' ',
            left_trunc_marker = _G.LazyVim.config.icons.misc.left_trunc_marker or ' ',
            right_trunc_marker = _G.LazyVim.config.icons.misc.right_trunc_marker or ' ',
            color_icons = true,
            get_element_icon = function(opts)
                local icon, hl = require('nvim-web-devicons').get_icon_by_filetype(opts.filetype, { default = false })
                return icon, hl
            end,
            separator_style = { '󰽣', '󰽡' },
        },
    },
    config = function(_, opts)
        require('bufferline').setup(opts)
    end,
}
