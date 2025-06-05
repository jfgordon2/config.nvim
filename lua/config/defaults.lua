-- Shared configuration
-- Icons, defaults, and shared settings used across plugins

local M = {}

-- Additional filetype settings
vim.filetype.add {
    extension = {
        jsonc = 'jsonc',
        feature = 'feature',
    },
}

-- Icons used by other plugins
M.icons = {
    misc = {
        dots = '󰇘',
        circle = '●',
        lightning = '󱐋',
    },
    ft = {
        octo = '',
        dotenv = '',
        dotkeep = '󰊢',
        devcontainer = '',
    },
    dap = {
        Stopped = { '󰁕 ', 'DiagnosticWarn', 'DapStoppedLine' },
        Breakpoint = { ' ', 'DiagnosticInfo', 'DapBreakpoint' },
        BreakpointCondition = ' ',
        BreakpointRejected = { ' ', 'DiagnosticError' },
        LogPoint = '.>',
    },
    dapui = {
        icons = {
            expanded = '▾',
            collapsed = '▸',
            current_frame = '*',
        },
        controls = {
            pause = '⏸',
            play = '▶',
            step_into = '⏎',
            step_over = '⏭',
            step_out = '⏮',
            step_back = 'b',
            run_last = '▶▶',
            terminate = '⏹',
            disconnect = '⏏',
        },
    },
    diagnostics = {
        Error = ' ',
        Warn = ' ',
        Hint = ' ',
        Info = ' ',
    },
    git = {
        added = ' ',
        modified = ' ',
        removed = ' ',
        topdelete = '‾',
        changedelete = '~',
    },
    mason = {
        package_installed = '✓',
        package_pending = '➜',
        package_uninstalled = '✗',
    },
    kinds = {
        Array = ' ',
        Boolean = '󰨙 ',
        Class = ' ',
        Codeium = '󰘦 ',
        Color = ' ',
        Control = ' ',
        Collapsed = ' ',
        Constant = '󰏿 ',
        Constructor = ' ',
        Copilot = ' ',
        Enum = ' ',
        EnumMember = ' ',
        Event = ' ',
        Field = ' ',
        File = ' ',
        Folder = ' ',
        Function = '󰊕 ',
        Interface = ' ',
        Key = ' ',
        Keyword = ' ',
        Method = '󰊕 ',
        Module = ' ',
        Namespace = '󰦮 ',
        Null = ' ',
        Number = '󰎠 ',
        Object = ' ',
        Operator = ' ',
        Package = ' ',
        Property = ' ',
        Reference = ' ',
        Snippet = '󱄽 ',
        String = ' ',
        Struct = '󰆼 ',
        Supermaven = ' ',
        TabNine = '󰏚 ',
        Text = ' ',
        TypeParameter = ' ',
        Unit = ' ',
        Value = ' ',
        Variable = '󰀫 ',
    },
}

-- Kind filter configuration for different file types
M.kind_filter = {
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
        'Property',
        'Struct',
        'Trait',
    },
}

-- Colorscheme configuration
M.colorscheme = function()
    local ok, tokyonight = pcall(require, 'tokyonight')
    if ok then
        tokyonight.load()
    else
        vim.cmd.colorscheme 'habamax'
    end
end

-- Default loading settings
M.defaults = {
    autocmds = true,
    keymaps = true,
}

-- Utility function to get kind filter for a buffer
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
    return type(M.kind_filter) == 'table' and type(M.kind_filter.default) == 'table' and M.kind_filter.default or nil
end

return M
