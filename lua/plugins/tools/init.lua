-- Tools plugins initialization
-- Automatically loads all development tool plugins

local plugins = {}

-- Collect all plugins from this category
local tool_plugins = {
    'debug',
    'file-browser',
    'fzf',
    'git',
    'github',
    'oil',
    'search-replace',
    'session',
    'telescope',
    'venv-selector',
}

for _, plugin_name in ipairs(tool_plugins) do
    local ok, plugin_spec = pcall(require, 'plugins.tools.' .. plugin_name)
    if ok and type(plugin_spec) == 'table' then
        if plugin_spec[1] and type(plugin_spec[1]) == 'string' then
            table.insert(plugins, plugin_spec)
        else
            vim.list_extend(plugins, plugin_spec)
        end
    end
end

return plugins
