-- Neo-tree - File explorer
-- Modern file browser with git integration

return {
    'nvim-neo-tree/neo-tree.nvim',
    version = '*',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons',
        'MunifTanjim/nui.nvim',
    },
    cmd = 'Neotree',
    keys = {
        { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
        {
            '<leader>ee',
            function()
                require('neo-tree.command').execute { toggle = true, dir = vim.uv.cwd() }
            end,
            desc = '[E]xplorer NeoTree (Root Dir)',
        },
        {
            '<leader>eE',
            function()
                require('neo-tree.command').execute { toggle = true, dir = vim.uv.cwd() }
            end,
            desc = '[E]xplorer NeoTree (cwd)',
        },
        {
            '<leader>eg',
            function()
                require('neo-tree.command').execute { source = 'git_status', toggle = true }
            end,
            desc = '[E]xplorer [G]it',
        },
        {
            '<leader>eb',
            function()
                require('neo-tree.command').execute { source = 'buffers', toggle = true }
            end,
            desc = '[E]xplorer [B]uffers',
        },
    },
    opts = {
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
                    added = _G.LazyVim.config.icons.git.added,
                    deleted = _G.LazyVim.config.icons.git.removed,
                    modified = _G.LazyVim.config.icons.git.modified,
                    untracked = _G.LazyVim.config.icons.git.untracked,
                    ignored = _G.LazyVim.config.icons.git.ignored,
                    unstaged = _G.LazyVim.config.icons.git.unstaged,
                    staged = _G.LazyVim.config.icons.git.staged,
                    conflict = _G.LazyVim.config.icons.git.conflict,
                },
            },
        },
    },
}
