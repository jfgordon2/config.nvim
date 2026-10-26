-- Dependencies are configured earlier in config.pack, before the first buffer.
return function()
    vim.cmd.packadd 'nvim-treesitter'
    require('ipynb').setup {}
    -- The first notebook can open before ipynb's deferred auto-install runs.
    if not pcall(vim.treesitter.language.inspect, 'ipynb') then
        require('nvim-treesitter').install({ 'ipynb' }):wait(30000)
    end
end
