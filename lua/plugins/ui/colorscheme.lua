-- Tokyo Night colorscheme
-- Beautiful dark theme

return {
    'folke/tokyonight.nvim',
    priority = 1000,
    lazy = false,
    config = function()
        require('tokyonight').load()
    end,
}
