-- Detect tabstop and shiftwidth automatically

return function()
    require('guess-indent').setup {
        auto_cmd = true,
    }
end
