local icons = require 'config.icons'

return function()
    do -- tpope/vim-fugitive
        vim.keymap.set('n', '<leader>gv', '<cmd>Gvdiffsplit<CR>', { noremap = true, silent = true, desc = 'Open vertical Git diff' })
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
                end, { desc = 'Next Git change' })

                map('n', '[c', function()
                    if vim.wo.diff then
                        vim.cmd.normal { '[c', bang = true }
                    else
                        gitsigns.nav_hunk 'prev'
                    end
                end, { desc = 'Previous Git change' })

                -- Actions
                -- visual mode
                map('v', '<leader>gs', function()
                    gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
                end, { desc = 'Stage hunk' })
                map('v', '<leader>gr', function()
                    gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
                end, { desc = 'Reset hunk' })
                -- normal mode
                map('n', '<leader>gs', gitsigns.stage_hunk, { desc = 'Stage hunk' })
                map('n', '<leader>gr', gitsigns.reset_hunk, { desc = 'Reset hunk' })
                map('n', '<leader>gS', gitsigns.stage_buffer, { desc = 'Stage buffer' })
                map('n', '<leader>gR', gitsigns.reset_buffer, { desc = 'Reset buffer changes' })
                map('n', '<leader>gp', gitsigns.preview_hunk, { desc = 'Preview Git hunk' })
                map('n', '<leader>gB', gitsigns.blame_line, { desc = 'Show Git blame for line' })
                map('n', '<leader>gd', gitsigns.diffthis, { desc = 'Diff buffer against index' })
                map('n', '<leader>gD', function()
                    gitsigns.diffthis '@'
                end, { desc = 'Diff buffer against HEAD' })
                -- Toggles
                map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = 'Toggle inline Git blame' })
                map('n', '<leader>gi', gitsigns.preview_hunk_inline, { desc = 'Preview Git hunk inline' })
            end,
        }
        require('gitsigns').setup(opts)
    end
end
