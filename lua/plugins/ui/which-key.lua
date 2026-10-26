-- Which-key - Show pending keybinds
-- Helpful plugin to discover and learn keybindings

local icons = require 'config.icons'

return function()
    local opts = {
        delay = 0,
        icons = {
            mappings = vim.g.have_nerd_font,
            keys = vim.g.have_nerd_font and {} or {
                Up = '<Up> ',
                Down = '<Down> ',
                Left = '<Left> ',
                Right = '<Right> ',
                C = '<C-…> ',
                M = '<M-…> ',
                D = '<D-…> ',
                S = '<S-…> ',
                CR = '<CR> ',
                Esc = '<Esc> ',
                ScrollWheelDown = '<ScrollWheelDown> ',
                ScrollWheelUp = '<ScrollWheelUp> ',
                NL = '<NL> ',
                BS = '<BS> ',
                Space = '<Space> ',
                Tab = '<Tab> ',
                F1 = '<F1>',
                F2 = '<F2>',
                F3 = '<F3>',
                F4 = '<F4>',
                F5 = '<F5>',
                F6 = '<F6>',
                F7 = '<F7>',
                F8 = '<F8>',
                F9 = '<F9>',
                F10 = '<F10>',
                F11 = '<F11>',
                F12 = '<F12>',
            },
        },
        spec = {
            { '<leader>', group = 'Leader', mode = { 'n', 'x' } },
            { '<leader>a', group = 'AI', mode = { 'n', 'x' } },
            { '<leader>b', group = 'Buffers' },
            { '<leader>B', group = 'Debug' },
            { '<leader>c', group = 'Code', mode = { 'n', 'x' } },
            { '<leader>d', group = 'Document', icon = { icon = vim.trim(icons.kinds.File), color = 'blue' } },
            { '<leader>e', group = 'Explorer', icon = { icon = vim.trim(icons.kinds.Folder), color = 'orange' } },
            { '<leader>g', group = 'Git', mode = { 'n', 'x' } },
            { '<leader>h', group = 'Help', icon = { icon = icons.misc.help, color = 'cyan' } },
            { '<leader>m', group = 'Markdown', icon = { cat = 'filetype', name = 'markdown' } },
            { '<leader>n', group = 'Notifications' },
            { '<leader>N', group = 'Tests' },
            { '<leader>q', group = 'Sessions' },
            { '<leader>r', group = 'Refactor' },
            { '<leader>s', group = 'Search', mode = { 'n', 'x' } },
            { '<leader>t', group = 'Toggles', mode = { 'n', 'x' } },
            { '<leader>u', group = 'Utilities', icon = { icon = icons.misc.tools, color = 'yellow' } },
            { '<leader>v', group = 'Terminals' },
            { '<leader>w', group = 'Workspace', icon = { icon = icons.misc.workspace, color = 'purple' } },
            { '<leader>x', group = 'Diagnostics and lists' },
            { 'gs', group = 'Surround', mode = { 'n', 'x' } },
            { 'g', group = 'Go to' },
            { 'gr', group = 'LSP' },
            { 'z', group = 'Folds and view' },
            { '[', group = 'Previous' },
            { ']', group = 'Next' },
        },
    }
    require('which-key').setup(opts)

    -- Notebook keys also exist in the plugin's Python/other-language cell buffers.
    vim.api.nvim_create_autocmd({ 'FileType', 'BufEnter' }, {
        group = vim.api.nvim_create_augroup('notebook-keymap-group', { clear = true }),
        callback = function(event)
            if vim.b[event.buf].which_key_notebook_group then
                return
            end
            if vim.bo[event.buf].filetype == 'ipynb' or vim.b[event.buf].ipynb_is_edit_buffer then
                -- Register late cell buffers immediately, after the startup queue.
                require('which-key.config').add {
                    { '<leader>k', group = 'Notebook', buffer = event.buf, icon = { icon = icons.misc.notebook, color = 'green' } },
                }
                vim.b[event.buf].which_key_notebook_group = true
            end
        end,
    })
end
