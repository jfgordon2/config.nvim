_G.LazyVim = require 'custom.utils'

---@class LazyVimConfig: LazyVimOptions
local M = {}

LazyVim.config = M

vim.filetype.add {
    extension = {
        jsonc = 'jsonc',
        feature = 'feature',
    },
}

---@class LazyVimOptions
local defaults = {
    -- colorscheme can be a string like `catppuccin` or a function that will load the colorscheme
    ---@type string|fun()
    colorscheme = function()
        require('tokyonight').load()
    end,
    -- load the default settings
    defaults = {
        autocmds = true, -- custom.config.autocmds
        keymaps = true, -- custom.config.keymaps
        -- custom.config.options can't be configured here since that's loaded before lazyvim setup
        -- if you want to disable loading options, add `package.loaded["custom.config.options"] = true` to the top of your init.lua
    },
  -- icons used by other plugins
  -- stylua: ignore
  icons = {
    misc = {
      dots = "󰇘",
    },
    ft = {
      octo = "",
    },
    dap = {
      Stopped             = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
      Breakpoint          = " ",
      BreakpointCondition = " ",
      BreakpointRejected  = { " ", "DiagnosticError" },
      LogPoint            = ".>",
    },
    diagnostics = {
      Error = " ",
      Warn  = " ",
      Hint  = " ",
      Info  = " ",
    },
    git = {
      added    = " ",
      modified = " ",
      removed  = " ",
    },
    kinds = {
      Array         = " ",
      Boolean       = "󰨙 ",
      Class         = " ",
      Codeium       = "󰘦 ",
      Color         = " ",
      Control       = " ",
      Collapsed     = " ",
      Constant      = "󰏿 ",
      Constructor   = " ",
      Copilot       = " ",
      Enum          = " ",
      EnumMember    = " ",
      Event         = " ",
      Field         = " ",
      File          = " ",
      Folder        = " ",
      Function      = "󰊕 ",
      Interface     = " ",
      Key           = " ",
      Keyword       = " ",
      Method        = "󰊕 ",
      Module        = " ",
      Namespace     = "󰦮 ",
      Null          = " ",
      Number        = "󰎠 ",
      Object        = " ",
      Operator      = " ",
      Package       = " ",
      Property      = " ",
      Reference     = " ",
      Snippet       = "󱄽 ",
      String        = " ",
      Struct        = "󰆼 ",
      Supermaven    = " ",
      TabNine       = "󰏚 ",
      Text          = " ",
      TypeParameter = " ",
      Unit          = " ",
      Value         = " ",
      Variable      = "󰀫 ",
    },
  },
    ---@type table<string, string[]|boolean>?
    kind_filter = {
        default = {
            'Class',
            'Constructor',
            'Enum',
            'Field',
            'Function',
            'Interface',
            'Method',
            'Module',
            'Namespace',
            'Package',
            'Property',
            'Struct',
            'Trait',
        },
        markdown = false,
        help = false,
        -- you can specify a different filter for each filetype
        lua = {
            'Class',
            'Constructor',
            'Enum',
            'Field',
            'Function',
            'Interface',
            'Method',
            'Module',
            'Namespace',
            -- "Package", -- remove package since luals uses it for control flow structures
            'Property',
            'Struct',
            'Trait',
        },
    },
}

---@type LazyVimOptions
local options
local lazy_clipboard

---@param opts? LazyVimOptions
function M.setup(opts)
    options = vim.tbl_deep_extend('force', defaults, opts or {}) or {}

    -- autocmds can be loaded lazily when not opening a file
    local lazy_autocmds = vim.fn.argc(-1) == 0
    if not lazy_autocmds then
        M.load 'autocmds'
    end

    local group = vim.api.nvim_create_augroup('LazyVim', { clear = true })
    vim.api.nvim_create_autocmd('User', {
        group = group,
        pattern = 'VeryLazy',
        callback = function()
            if lazy_autocmds then
                M.load 'autocmds'
            end
            M.load 'keymaps'
            if lazy_clipboard ~= nil then
                vim.opt.clipboard = lazy_clipboard
            end

            LazyVim.format.setup()

            vim.api.nvim_create_user_command('LazyHealth', function()
                vim.cmd [[Lazy! load all]]
                vim.cmd [[checkhealth]]
            end, { desc = 'Load all plugins and run :checkhealth' })

            local health = require 'lazy.health'
            vim.list_extend(health.valid, {
                'recommended',
                'desc',
                'vscode',
            })
        end,
    })

    LazyVim.track 'colorscheme'
    LazyVim.try(function()
        if type(M.colorscheme) == 'function' then
            M.colorscheme()
        else
            vim.cmd.colorscheme(M.colorscheme)
        end
    end, {
        msg = 'Could not load your colorscheme',
        on_error = function(msg)
            LazyVim.error(msg)
            vim.cmd.colorscheme 'habamax'
        end,
    })
    LazyVim.track()
end

---@param buf? number
---@return string[]|boolean|nil
function M.get_kind_filter(buf)
    buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
    local ft = vim.bo[buf].filetype
    if M.kind_filter == false then
        return nil
    end
    if M.kind_filter[ft] == false then
        return nil
    end
    if type(M.kind_filter[ft]) == 'table' then
        return M.kind_filter[ft]
    end
    ---@diagnostic disable-next-line: return-type-mismatch
    return type(M.kind_filter) == 'table' and type(M.kind_filter.default) == 'table' and M.kind_filter.default or nil
end

---@param name "autocmds" | "options" | "keymaps" | "health"
function M.load(name)
    local function _load(mod)
        if require('lazy.core.cache').find(mod)[1] then
            LazyVim.try(function()
                require(mod)
            end, { msg = 'Failed loading ' .. mod })
        end
    end
    local pattern = 'LazyVim' .. name:sub(1, 1):upper() .. name:sub(2)
    -- always load lazyvim, then user file
    if M.defaults[name] or name == 'options' then
        _load('custom.config.' .. name)
        vim.api.nvim_exec_autocmds('User', { pattern = pattern .. 'Defaults', modeline = false })
    end
    _load('config.' .. name)
    if vim.bo.filetype == 'lazy' then
        -- HACK: LazyVim may have overwritten options of the Lazy ui, so reset this here
        vim.cmd [[do VimResized]]
    end
    vim.api.nvim_exec_autocmds('User', { pattern = pattern, modeline = false })
end

M.did_init = false
function M.init()
    if M.did_init then
        return
    end
    M.did_init = true
    local plugin = require('lazy.core.config').spec.plugins.LazyVim
    if plugin then
        vim.opt.rtp:append(plugin.dir)
    end

    -- delay notifications till vim.notify was replaced or after 500ms
    LazyVim.lazy_notify()

    -- load options here, before lazy init while sourcing plugin modules
    -- this is needed to make sure options will be correctly applied
    -- after installing missing plugins
    M.load 'options'
    -- defer built-in clipboard handling: "xsel" and "pbcopy" can be slow
    lazy_clipboard = vim.opt.clipboard
    vim.opt.clipboard = ''

    LazyVim.plugin.setup()
end

setmetatable(M, {
    __index = function(_, key)
        if options == nil then
            return vim.deepcopy(defaults)[key]
        end
        ---@cast options LazyVimConfig
        return options[key]
    end,
})

return M
