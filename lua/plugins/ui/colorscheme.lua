-- Tokyo Night colorscheme
-- Beautiful dark theme

return function()
    local tokyonight = require 'tokyonight'
    ---@type tokyonight.Config
    local opts = {
        transparent = false,
    }
    tokyonight.setup(opts)
    tokyonight.load()
end
