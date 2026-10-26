-- Hooks must precede the first vim.pack call, including lockfile installs.
require('config.pack_build').setup()
vim.pack.add(require 'config.packages')
require('config.mason').setup()

-- Explicit dependency order. Buffer features are ready before the first file.
local modules = {
    'plugins.ui.colorscheme',
    'plugins.tools.fortune',
    'plugins.ui.which-key',
    'plugins.ui.snacks',
    'plugins.editor.mini',
    'plugins.tools.git',
    'plugins.editor.guess-indent',
    'plugins.editor.hardtime',
    'plugins.editor.autopairs',
    'plugins.editor.luasnip',
    'plugins.ui.markview',
    'plugins.editor.treesitter',
    'plugins.ai.copilot',
    'plugins.ai.sidekick',
    'plugins.lsp.blink',
    'plugins.lsp.lspconfig',
    'plugins.lsp.sonarqube',
    'plugins.lsp.formatting',
    'plugins.lsp.linting',
    'plugins.tools.telescope',
    'plugins.tools.file-browser',
    'plugins.tools.debug',
    'plugins.tools.neotest',
    'plugins.tools.fzf',
    'plugins.tools.github',
    'plugins.tools.mdpick',
    'plugins.tools.minty',
    'plugins.tools.search-replace',
    'plugins.tools.session',
    'plugins.tools.ts-comments',
    'plugins.tools.venv-selector',
    'plugins.tools.vim-coach',
    'plugins.tools.vsterm',
    'plugins.ui.bufferline',
    'plugins.ui.neo-tree',
    'plugins.ui.nvim-highlight-colors',
    'plugins.ui.todo-comments',
    'plugins.ui.trouble',
}
for _, module in ipairs(modules) do
    require(module)()
end

vim.api.nvim_create_user_command('PackUpdate', function()
    vim.pack.update()
end, { desc = 'Review plugin updates; write to apply, quit to cancel' })
vim.api.nvim_create_user_command('PackStatus', function()
    vim.pack.update(nil, { offline = true })
end, { desc = 'Inspect native plugins without fetching updates' })
vim.api.nvim_create_user_command('PackRestore', function()
    vim.pack.update(nil, { offline = true, target = 'lockfile' })
end, { desc = 'Review restoring plugin revisions from the native lockfile' })
vim.api.nvim_create_user_command('PackBuild', function(command)
    require('config.pack_build').build(command.args)
end, {
    nargs = 1,
    complete = function()
        return { 'LuaSnip', 'nvim-treesitter', 'telescope-fzf-native.nvim' }
    end,
    desc = 'Rebuild a native plugin',
})
