-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
    'folke/snacks.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
    {
      '<leader>ee',
      function()
        require('neo-tree.command').execute { toggle = true, dir = Snacks.git.get_root() }
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
    file_size = { enabled = false },
    last_modified = { enabled = false },
    created = { enabled = false },
    filesystem = {
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_by_name = {
          '.git',
          '.DS_Store',
        },
        never_show = {
          '.swp',
        },
      },
      follow_current_file = {
        enabled = true,
      },
      use_libuv_file_watcher = true,
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
  },
}
