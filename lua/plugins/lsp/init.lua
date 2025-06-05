-- LSP plugins initialization
-- Automatically loads all LSP and language support plugins

local plugins = {}

-- Collect all plugins from this category
local lsp_plugins = {
    'completion', -- Blink CMP
    'formatting', -- Conform
    'linting', -- Nvim-lint
    'main', -- Main LSP configuration
}

for _, plugin_name in ipairs(lsp_plugins) do
    local ok, plugin_spec = pcall(require, 'plugins.lsp.' .. plugin_name)
    if ok and type(plugin_spec) == 'table' then
        if plugin_spec[1] and type(plugin_spec[1]) == 'string' then
            table.insert(plugins, plugin_spec)
        else
            vim.list_extend(plugins, plugin_spec)
        end
    end
end

return plugins
