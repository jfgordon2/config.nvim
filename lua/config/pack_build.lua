-- Authentication remains an explicit command, independent of builds.
local M = {}
local function make(path, args)
    local result = vim.system(vim.list_extend({ 'make' }, args or {}), { cwd = path, text = true }):wait()
    if result.code ~= 0 then
        error(('Build failed in %s:\n%s\n%s'):format(path, result.stdout or '', result.stderr or ''))
    end
end
local builders = {
    ['telescope-fzf-native.nvim'] = function(path)
        make(path)
    end,
    LuaSnip = function(path)
        make(path, { 'install_jsregexp' })
    end,
    ['nvim-treesitter'] = function()
        vim.cmd.packadd 'nvim-treesitter'
        require('nvim-treesitter').setup { install_dir = vim.fn.stdpath 'data' .. '/site' }
        require('nvim-treesitter').update(nil, { summary = true })
    end,
}
function M.build(name, path)
    local builder = assert(builders[name], 'No build hook for ' .. name)
    builder(path or (vim.fn.stdpath 'data' .. '/site/pack/core/opt/' .. name))
end
function M.setup()
    vim.api.nvim_create_autocmd('PackChanged', {
        group = vim.api.nvim_create_augroup('native-pack-build', { clear = true }),
        desc = 'Build plugins after native installation or updates',
        callback = function(event)
            local data = event.data
            if (data.kind == 'install' or data.kind == 'update') and builders[data.spec.name] then
                M.build(data.spec.name, data.path)
            end
        end,
    })
end
return M
