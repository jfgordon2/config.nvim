-- Session management. This saves your session in the background,
-- keeping track of open buffers, window arrangement, and more.
-- You can restore sessions when returning through the dashboard.
return {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    opts = {},
  -- stylua: ignore
  keys = {
    -- load the session for the current directory
    { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
    -- select a session to load
    { "<leader>qS", function() require("persistence").select() end,desc = "Select Session" },
    -- load the last session
    { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
    -- stop Persistence => session won't be saved on exit
    { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
  },
}
