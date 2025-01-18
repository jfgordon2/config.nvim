return {
  'rachartier/tiny-inline-diagnostic.nvim',
  event = 'LspAttach', -- Or `VeryLazy`
  priority = 1000, -- needs to be loaded in first
  config = function()
    require('tiny-inline-diagnostic').setup {
      preset = 'classic',
      options = {
        add_messages = true,
        multiple_diag_under_cursor = false,
        multilines = {
          enabled = true,
          always_show = false,
        },
      },
    }
    vim.diagnostic.config { virtual_text = false } -- Only if needed in your configuration, if you already have native LSP diagnostics
  end,
}

