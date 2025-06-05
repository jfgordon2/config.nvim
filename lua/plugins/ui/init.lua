-- UI plugins initialization
-- Automatically loads all UI-related plugins

local plugins = {}

-- Collect all plugins from this category
local ui_plugins = {
    'bufferline',
    'colorscheme',
    'dashboard',
    'diagnostics',
    'markview',
    'neo-tree',
    'todo-comments',
    'trouble',
    'which-key',
}

for _, plugin_name in ipairs(ui_plugins) do
    local ok, plugin_spec = pcall(require, 'plugins.ui.' .. plugin_name)
    if ok and type(plugin_spec) == 'table' then
        -- Handle both single plugin and array of plugins
        if plugin_spec[1] and type(plugin_spec[1]) == 'string' then
            -- Single plugin spec
            table.insert(plugins, plugin_spec)
        else
            -- Array of plugin specs
            vim.list_extend(plugins, plugin_spec)
        end
    end
end

return plugins
