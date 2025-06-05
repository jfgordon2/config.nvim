-- Editor plugins initialization
-- Automatically loads all editor enhancement plugins

local plugins = {}

-- Collect all plugins from this category
local editor_plugins = {
    'autopairs', -- Auto-pairing
    'hardtime', -- Habit building
    'indent', -- Indentation guides
    'mini', -- Mini.nvim modules
    'neoscroll', -- Smooth scrolling
    'sleuth', -- Auto-detect indentation
    'treesitter', -- Syntax highlighting
}

for _, plugin_name in ipairs(editor_plugins) do
    local ok, plugin_spec = pcall(require, 'plugins.editor.' .. plugin_name)
    if ok and type(plugin_spec) == 'table' then
        if plugin_spec[1] and type(plugin_spec[1]) == 'string' then
            table.insert(plugins, plugin_spec)
        else
            vim.list_extend(plugins, plugin_spec)
        end
    end
end

return plugins
