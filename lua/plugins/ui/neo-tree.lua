local icons = require 'config.icons'

-- Neo-tree - File explorer
-- Modern file browser with git integration

return function()
    local opts = {
        open_files_do_not_replace_types = { 'terminal', 'trouble', 'qf', 'edgy' },
        filesystem = {
            filtered_items = {
                hide_dotfiles = false,
                hide_gitignored = false,
                hide_by_name = { '.git', '.DS_Store' },
                never_show = { '.swp' },
            },
            follow_current_file = { enabled = true },
            use_libuv_file_watcher = true,
            window = {
                mappings = { ['\\'] = 'close_window' },
            },
        },
        default_component_configs = {
            git_status = {
                symbols = {
                    added = icons.git.added,
                    deleted = icons.git.removed,
                    modified = icons.git.modified,
                    untracked = icons.git.untracked,
                    ignored = icons.git.ignored,
                    unstaged = icons.git.unstaged,
                    staged = icons.git.staged,
                    conflict = icons.git.conflict,
                },
            },
        },
    }
    require('neo-tree').setup(opts)
    vim.keymap.set('n', '\\', ':Neotree reveal<CR>', { desc = 'Reveal current file in explorer', silent = true })
    vim.keymap.set('n', '<leader>ee', function()
        local root = Snacks.git.get_root(vim.api.nvim_buf_get_name(0)) or vim.uv.cwd()
        require('neo-tree.command').execute { toggle = true, dir = root }
    end, { desc = 'Toggle file explorer (Git root)' })
    vim.keymap.set('n', '<leader>eE', function()
        require('neo-tree.command').execute { toggle = true, dir = vim.uv.cwd() }
    end, { desc = 'Toggle file explorer (cwd)' })
    vim.keymap.set('n', '<leader>eg', function()
        require('neo-tree.command').execute { source = 'git_status', toggle = true }
    end, { desc = 'Toggle Git status explorer' })
    vim.keymap.set('n', '<leader>eb', function()
        require('neo-tree.command').execute { source = 'buffers', toggle = true }
    end, { desc = 'Toggle buffer explorer' })
end
