local M = {}

---@param kind string
function M.pick(kind)
  return function()
    local actions = require 'CopilotChat.actions'
    local items = actions[kind .. '_actions']()
    if not items then
      Snacks.notify.warn('No ' .. kind .. ' found on the current line')
      return
    end
    local ok = pcall(require, 'fzf-lua')
    require('CopilotChat.integrations.' .. (ok and 'fzflua' or 'telescope')).pick(items)
  end
end

return {
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'main',
    cmd = 'CopilotChat',
    opts = function()
      local user = vim.env.USER or 'User'
      user = user:sub(1, 1):upper() .. user:sub(2)
      return {
        auto_insert_mode = true,
        question_header = '  ' .. user .. ' ',
        answer_header = '  Copilot ',
        window = {
          width = 0.4,
        },
      }
    end,
    keys = {
      { '<c-s>', '<CR>', ft = 'copilot-chat', desc = 'Submit Prompt', remap = true },
      { '<leader>a', '', desc = '+[a]i', mode = { 'n', 'v' } },
      {
        '<leader>aa',
        function()
          return require('CopilotChat').toggle()
        end,
        desc = '[a]i: Toggle (CopilotChat)',
        mode = { 'n', 'v' },
      },
      {
        '<leader>ac',
        function()
          return require('CopilotChat').reset()
        end,
        desc = '[a]i: [C]lear (CopilotChat)',
        mode = { 'n', 'v' },
      },
      {
        '<leader>aq',
        function()
          local input = vim.fn.input 'Quick Chat: '
          if input ~= '' then
            require('CopilotChat').ask(input)
          end
        end,
        desc = '[a]i: [Q]uick Chat (CopilotChat)',
        mode = { 'n', 'v' },
      },
      {
        '<leader>cc',
        ':CopilotChatFixDiagnostic<CR>',
        desc = '[C]ode: [C]opilot fix diagnostic',
        mode = { 'n', 'v' },
      },
      -- Show prompts actions with telescope
      { '<leader>ap', M.pick 'prompt', desc = '[a]i: [P]rompt Actions (CopilotChat)', mode = { 'n', 'v' } },
    },
    config = function(_, opts)
      local chat = require 'CopilotChat'

      vim.api.nvim_create_autocmd('BufEnter', {
        pattern = 'copilot-chat',
        callback = function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
        end,
      })

      chat.setup(opts)
    end,
  },

  -- Edgy integration
  {
    'folke/edgy.nvim',
    optional = true,
    opts = function(_, opts)
      opts.right = opts.right or {}
      table.insert(opts.right, {
        ft = 'copilot-chat',
        title = 'Copilot Chat',
        size = { width = 50 },
      })
    end,
  },
}
