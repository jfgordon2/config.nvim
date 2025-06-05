-- Core utilities
-- Shared utilities used throughout the configuration

---@class LazyVim
local M = {}

-- Make LazyVim globally available
_G.LazyVim = M

-- Set up the config reference that plugins expect
M.config = require 'config.defaults'

-- Basic utility functions that don't depend on Lazy.nvim
function M.get_plugin(name)
    local ok, config = pcall(require, 'lazy.core.config')
    if not ok then
        return nil
    end
    return config.spec.plugins[name]
end

function M.get_plugin_path(name, path)
    local plugin = M.get_plugin(name)
    path = path and '/' .. path or ''
    return plugin and (plugin.dir .. path)
end

function M.has(plugin)
    return M.get_plugin(plugin) ~= nil
end

function M.is_loaded(name)
    local ok, config = pcall(require, 'lazy.core.config')
    if not ok then
        return false
    end
    return config.plugins[name] and config.plugins[name]._.loaded
end

function M.on_load(name, fn)
    if M.is_loaded(name) then
        fn(name)
    else
        vim.api.nvim_create_autocmd('User', {
            pattern = 'LazyLoad',
            callback = function(event)
                if event.data == name then
                    fn(name)
                    return true
                end
            end,
        })
    end
end

function M.on_very_lazy(fn)
    vim.api.nvim_create_autocmd('User', {
        pattern = 'VeryLazy',
        callback = function()
            fn()
        end,
    })
end

-- Notification utilities
function M.lazy_notify()
    local notifs = {}
    local function temp(...)
        table.insert(notifs, vim.F.pack_len(...))
    end

    local orig = vim.notify
    vim.notify = temp

    local timer = vim.uv.new_timer()
    local check = assert(vim.uv.new_check())

    local replay = function()
        timer:stop()
        check:stop()
        if vim.notify == temp then
            vim.notify = orig
        end
        vim.schedule(function()
            for _, notif in ipairs(notifs) do
                vim.notify(vim.F.unpack_len(notif))
            end
        end)
    end

    check:start(function()
        if vim.notify ~= temp then
            replay()
        end
    end)
    timer:start(500, 0, replay)
end

-- Utility functions
function M.dedup(list)
    local ret = {}
    local seen = {}
    for _, v in ipairs(list) do
        if not seen[v] then
            table.insert(ret, v)
            seen[v] = true
        end
    end
    return ret
end

function M.extend(t, key, values)
    local keys = vim.split(key, '.', { plain = true })
    for i = 1, #keys do
        local k = keys[i]
        t[k] = t[k] or {}
        if type(t) ~= 'table' then
            return
        end
        t = t[k]
    end
    return vim.list_extend(t, values)
end

function M.opts(name)
    local plugin = M.get_plugin(name)
    if not plugin then
        return {}
    end
    local ok, Plugin = pcall(require, 'lazy.core.plugin')
    if not ok then
        return {}
    end
    return Plugin.values(plugin, 'opts', false)
end

-- Mason utilities
function M.get_pkg_path(pkg, path, opts)
    pcall(require, 'mason')
    local root = vim.env.MASON or (vim.fn.stdpath 'data' .. '/mason')
    opts = opts or {}
    opts.warn = opts.warn == nil and true or opts.warn
    path = path or ''
    local ret = root .. '/packages/' .. pkg .. '/' .. path
    if opts.warn and not vim.loop.fs_stat(ret) then
        M.warn(('Mason package path not found for **%s**:\n- `%s`\nYou may need to force update the package.'):format(pkg, path))
    end
    return ret
end

-- Notification functions with fallbacks
function M.info(msg, opts)
    opts = opts or {}
    opts.title = opts.title or 'INFO'
    vim.notify(msg, vim.log.levels.INFO, opts)
end

function M.warn(msg, opts)
    opts = opts or {}
    opts.title = opts.title or 'WARN'
    vim.notify(msg, vim.log.levels.WARN, opts)
end

function M.error(msg, opts)
    opts = opts or {}
    opts.title = opts.title or 'ERROR'
    vim.notify(msg, vim.log.levels.ERROR, opts)
end

-- Memoization utility
local cache = {}
function M.memoize(fn)
    return function(...)
        local key = vim.inspect { ... }
        cache[fn] = cache[fn] or {}
        if cache[fn][key] == nil then
            cache[fn][key] = fn(...)
        end
        return cache[fn][key]
    end
end

-- Set up metatable to load utilities
setmetatable(M, {
    __index = function(t, k)
        -- Try to load from lazy.core.util if available
        local ok, lazy_util = pcall(require, 'lazy.core.util')
        if ok and lazy_util[k] then
            return lazy_util[k]
        end

        -- Try to load from lib utilities
        local lib_ok, lib = pcall(require, 'lib')
        if lib_ok and lib[k] then
            t[k] = lib[k]
            return lib[k]
        end

        -- Try to load submodule from lib/ directly (fallback)
        local module_ok, mod = pcall(require, 'lib.' .. k)
        if module_ok then
            t[k] = mod
            return mod
        end

        return nil
    end,
})

return M
