-- Treesitter - Parser management and syntax features

local parsers = {
    'bash',
    'c',
    'diff',
    'dockerfile',
    'git_config',
    'git_rebase',
    'gitattributes',
    'gitcommit',
    'gitignore',
    'go',
    'gomod',
    'gosum',
    'html',
    'javascript',
    'jsdoc',
    'json',
    'lua',
    'luadoc',
    'luap',
    'make',
    'markdown',
    'markdown_inline',
    'printf',
    'python',
    'query',
    'regex',
    'rust',
    'sql',
    'toml',
    'tsx',
    'typescript',
    'vim',
    'vimdoc',
    'xml',
    'yaml',
}

local function enable_features(buf)
    if not vim.api.nvim_buf_is_valid(buf) or vim.bo[buf].buftype ~= '' then
        return
    end

    local ok = pcall(vim.treesitter.start, buf)
    if ok then
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
end

local function install_missing_parsers(nvim_treesitter)
    local installed = {}
    for _, parser in ipairs(nvim_treesitter.get_installed 'parsers') do
        installed[parser] = true
    end

    local missing = {}
    for _, parser in ipairs(parsers) do
        if not installed[parser] then
            table.insert(missing, parser)
        end
    end

    if #missing > 0 then
        nvim_treesitter.install(missing)
    end
end

local function setup_treesitter()
    local nvim_treesitter = require 'nvim-treesitter'
    nvim_treesitter.setup {
        install_dir = vim.fn.stdpath 'data' .. '/site',
    }

    install_missing_parsers(nvim_treesitter)

    local group = vim.api.nvim_create_augroup('custom_treesitter', { clear = true })
    vim.api.nvim_create_autocmd('FileType', {
        group = group,
        pattern = '*',
        callback = function(event)
            enable_features(event.buf)
        end,
    })

    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) then
            enable_features(buf)
        end
    end
end

return {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    dependencies = { 'OXY2DEV/markview.nvim' },
    build = ':TSUpdate',
    lazy = false,
    config = setup_treesitter,
}
