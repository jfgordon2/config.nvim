-- Enhanced debug - shows plugin names
-- This will show exactly which plugins are loaded

print '🔍 ENHANCED DEBUG: Starting config load...'

-- Initialize LazyVim utilities and config defaults first
_G.LazyVim = require 'config.utils'

-- Load vim options early
require 'config.options'

-- Setup lazy.nvim and load plugins
require 'config.lazy'

-- Check what plugins were loaded with names
vim.defer_fn(function()
    print '\n🔍 DETAILED PLUGIN STATUS:'
    local lazy_ok, lazy = pcall(require, 'lazy')
    if lazy_ok then
        local plugins = lazy.plugins()
        print('📦 Total plugins found: ' .. #plugins)

        local loaded_count = 0
        local not_loaded_count = 0

        for name, plugin in pairs(plugins) do
            if plugin._.loaded then
                print('✅ LOADED: ' .. name)
                loaded_count = loaded_count + 1
            else
                local reason = plugin._.cond == false and '(disabled)' or plugin.lazy and '(lazy)' or '(unknown)'
                print('⏳ NOT LOADED: ' .. name .. ' ' .. reason)
                not_loaded_count = not_loaded_count + 1
            end
        end

        print(string.format('\n📊 SUMMARY: %d loaded, %d not loaded', loaded_count, not_loaded_count))

        -- Test key plugins specifically
        print '\n🧪 KEY PLUGIN TESTS:'
        local key_plugins = {
            'tokyonight.nvim',
            'snacks.nvim',
            'nvim-treesitter',
            'telescope.nvim',
        }

        for _, plugin_name in ipairs(key_plugins) do
            local ok, plugin_mod = pcall(require, plugin_name:gsub('%.nvim', ''):gsub('nvim%-', ''))
            if ok then
                print('✅ CAN REQUIRE: ' .. plugin_name)
            else
                print('❌ CANNOT REQUIRE: ' .. plugin_name)
            end
        end
    else
        print '❌ DEBUG: Could not load lazy.nvim'
    end
end, 1000)

-- Setup autocmds and keymaps after plugins load
vim.api.nvim_create_autocmd('User', {
    pattern = 'VeryLazy',
    callback = function()
        print '🔍 DEBUG: VeryLazy event triggered'
        require 'config.autocmds'
        require 'config.keymaps'

        -- Load colorscheme after all plugins are loaded
        vim.schedule(function()
            local ok, tokyonight = pcall(require, 'tokyonight')
            if ok then
                print '✅ DEBUG: Tokyo Night loaded successfully'
                tokyonight.load()
            else
                print '❌ DEBUG: Tokyo Night not found, using habamax'
                vim.cmd.colorscheme 'habamax'
            end
        end)
    end,
})

print '🔍 DEBUG: Config setup complete'
