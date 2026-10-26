-- Telescope - Fuzzy finder
-- Comprehensive file finder, grep, and more with full keymaps

return function()
    require('telescope').setup {
        pickers = {
            find_files = {
                theme = 'dropdown',
            },
            live_grep = {
                theme = 'dropdown',
                additional_args = { '--hidden' },
            },
        },
        extensions = {
            ['ui-select'] = {
                require('telescope.themes').get_dropdown(),
            },
        },
    }

    -- Enable Telescope extensions
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    -- Telescope keymaps
    local builtin = require 'telescope.builtin'

    -- Basic search functions
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = 'Find help' })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = 'Find keymaps' })
    vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = 'Find files' })
    vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = 'Find current word' })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = 'Search text (cwd)' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = 'Find diagnostics' })
    vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = 'Resume last search' })
    vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = 'Find recent files' })
    vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = 'Find buffers' })

    -- Advanced search functions
    vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
            winblend = 10,
            previewer = false,
        })
    end, { desc = 'Search current buffer' })

    vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
            grep_open_files = true,
            prompt_title = 'Live Grep in Open Files',
        }
    end, { desc = 'Search open buffers' })

    vim.keymap.set('n', '<leader>ss', function()
        -- Use fallback if Snacks not available
        local cwd = vim.uv.cwd()
        local snacks = require 'snacks'
        if snacks and snacks.git and snacks.git.get_root then
            cwd = snacks.git.get_root() or cwd
        end
        builtin.live_grep {
            cwd = cwd,
            prompt_title = 'Live Grep in Current Project',
        }
    end, { desc = 'Search text (Git root)' })

    -- Neovim config search
    vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = 'Find Neovim config files' })
end
