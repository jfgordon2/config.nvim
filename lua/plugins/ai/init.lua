-- AI plugins initialization
-- Automatically loads all AI-powered tool plugins

local plugins = {}

-- Collect all plugins from this category
local ai_plugins = {
    'codecompanion', -- AI coding assistant
    'copilot', -- GitHub Copilot
    'mcphub', -- MCP integration
}

for _, plugin_name in ipairs(ai_plugins) do
    local ok, plugin_spec = pcall(require, 'plugins.ai.' .. plugin_name)
    if ok and type(plugin_spec) == 'table' then
        if plugin_spec[1] and type(plugin_spec[1]) == 'string' then
            table.insert(plugins, plugin_spec)
        else
            vim.list_extend(plugins, plugin_spec)
        end
    end
end

return plugins
