local icons = require 'config.icons'

return function()
    do -- tpope/vim-fugitive
        vim.keymap.set('n', '<leader>gv', '<cmd>Gvdiffsplit<CR>', { noremap = true, silent = true, desc = '[G]it: [V]ertical Diffsplit' })
    end
    do -- lewis6991/gitsigns.nvim
        local opts = {
            signs = {
                add = { text = icons.git.added },
                change = { text = icons.git.modified },
                delete = { text = icons.git.removed },
                topdelete = { text = icons.git.topdelete },
                changedelete = { text = icons.git.changedelete },
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
        }
        require('gitsigns').setup(opts)
    end
end
