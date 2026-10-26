return function()
    local opts = {
        hint = true,
        enabled = true,
        disable_mouse = false,
        restriction_mode = 'hint',
        restricted_keys = {
            ['j'] = false,
            ['k'] = false,
        },
    }
    require('hardtime').setup(opts)
end
