-- Here is a more advanced example where we pass configuration
-- options to `gitsigns.nvim`. This is equivalent to the following Lua:
--    require('gitsigns').setup({ ... })
--
-- See `:help gitsigns` to understand what the configuration keys do
-- Adds git related signs to the gutter, as well as utilities for managing changes
return {
    {
        'tpope/vim-fugitive',
        config = function()
            -- Fugitive is a Git wrapper for Neovim
            -- It provides commands like :Gstatus, :Gcommit, etc.
            -- No additional configuration needed for basic usage
            vim.keymap.set('n', '<leader>gv', '<cmd>Gvdiffsplit<CR>', { noremap = true, silent = true, desc = '[G]it: [V]ertical Diffsplit' })
        end,
    },
    {
        'lewis6991/gitsigns.nvim',
        opts = {
            signs = {
                add = { text = _G.LazyVim.config.icons.git.added or ' ' },
                change = { text = _G.LazyVim.config.icons.git.modified or ' ' },
                delete = { text = _G.LazyVim.config.icons.git.removed or ' ' },
                topdelete = { text = _G.LazyVim.config.icons.git.topdelete or '‾' },
                changedelete = { text = _G.LazyVim.config.icons.git.changedelete or '~' },
            },
            current_line_blame = true,
            on_attach = function(bufnr)
                local gitsigns = require 'gitsigns'

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                map('n', ']c', function()
                    if vim.wo.diff then
                        vim.cmd.normal { ']c', bang = true }
                    else
                        gitsigns.nav_hunk 'next'
                    end
                end, { desc = 'Jump to next git [c]hange' })

                map('n', '[c', function()
                    if vim.wo.diff then
                        vim.cmd.normal { '[c', bang = true }
                    else
                        gitsigns.nav_hunk 'prev'
                    end
                end, { desc = 'Jump to previous git [c]hange' })

                -- Actions
                -- visual mode
                map('v', '<leader>gs', function()
                    gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
                end, { desc = '[G]it: [S]tage hunk' })
                map('v', '<leader>gr', function()
                    gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
                end, { desc = '[G]it: [R]eset hunk' })
                -- normal mode
                map('n', '<leader>gs', gitsigns.stage_hunk, { desc = '[G]it: [S]tage hunk' })
                map('n', '<leader>gr', gitsigns.reset_hunk, { desc = '[G]it: [R]eset hunk' })
                map('n', '<leader>gS', gitsigns.stage_buffer, { desc = '[G]it: [S]tage buffer' })
                map('n', '<leader>gu', gitsigns.stage_hunk, { desc = '[G]it: [U]ndo stage hunk' })
                map('n', '<leader>gR', gitsigns.reset_buffer, { desc = '[G]it: [R]eset buffer' })
                map('n', '<leader>gp', gitsigns.preview_hunk, { desc = '[G]it: [P]review hunk' })
                map('n', '<leader>gB', gitsigns.blame_line, { desc = '[G]it: [B]lame line' })
                map('n', '<leader>gd', gitsigns.diffthis, { desc = '[G]it: [D]iff against index' })
                map('n', '<leader>gD', function()
                    gitsigns.diffthis '@'
                end, { desc = '[G]it: [D]iff against last commit' })
                -- Toggles
                map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle: git[b]lame line' })
                map('n', '<leader>tD', gitsigns.preview_hunk_inline, { desc = '[T]oggle: git show [D]eleted' })
            end,
        },
    },
}
