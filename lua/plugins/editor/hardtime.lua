return {
    'm4xshen/hardtime.nvim',
    lazy = false,
    dependencies = { 'MunifTanjim/nui.nvim' },
    opts = {
        hint = true,
        enabled = true,
        disable_mouse = false,
        restriction_mode = 'hint',
        restricted_keys = {
            ['j'] = false,
            ['k'] = false,
        },
    },
}
