return function()
    require('luasnip').setup {
        history = true,
        updateevents = 'TextChanged,TextChangedI',
        enable_autosnippets = true,
        ext_opts = {
            [require('luasnip.util.types').choiceNode] = {
                active = {
                    virt_text = { { '●', 'Comment' } },
                },
            },
        },
    }

    require('luasnip.loaders.from_vscode').lazy_load()
end
