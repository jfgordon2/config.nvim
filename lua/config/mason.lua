-- One installer for all language servers, linters, formatters, and adapters.
local M = {}
function M.setup()
    require('mason').setup { ui = { icons = require('config.icons').mason } }
    require('mason-tool-installer').setup { ensure_installed = require('config.tools').packages() }
end
return M
