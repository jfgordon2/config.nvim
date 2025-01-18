return {
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      columns = {
        'icon',
        -- "permissions",
        'size',
        'mtime',
      },
      delete_to_trash = true,
      view_options = {
        show_hidden = true,
      },
      win_options = {
        wrap = true,
      },
    },
    dependencies = {
      { 'echasnovski/mini.icons', opts = {} },
    },
  },
  {
    vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' }),
  },
}
