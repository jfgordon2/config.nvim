return {
    'iamkarasik/sonarqube.nvim',
    config = function()
        require('sonarqube').setup {
            lsp = {
                cmd = {
                    'sonarlint-language-server',
                    '-stdio',
                    '-analyzers',
                    vim.fn.expand '$MASON/share/sonarlint-analyzers/go.jar',
                    vim.fn.expand '$MASON/share/sonarlint-analyzers/html.jar',
                    vim.fn.expand '$MASON/share/sonarlint-analyzers/iac.jar',
                    vim.fn.expand '$MASON/share/sonarlint-analyzers/java.jar',
                    vim.fn.expand '$MASON/share/sonarlint-analyzers/javascript.jar',
                    vim.fn.expand '$MASON/share/sonarlint-analyzers/php.jar',
                    vim.fn.expand '$MASON/share/sonarlint-analyzers/python.jar',
                    vim.fn.expand '$MASON/share/sonarlint-analyzers/text.jar',
                    vim.fn.expand '$MASON/share/sonarlint-analyzers/xml.jar',
                },
                -- capabilities = require("cmp_nvim_lsp").default_capabilities(),
                log_level = 'OFF',
                handlers = {
                    -- Custom handler to show rule description
                    -- The `res` argument contains various keys containing html that can be rendered in your favourite neovim html plugin
                    -- Alternatively, open the rule in the browser using your favourite sonarqube rule website (example below)
                    ['sonarlint/showRuleDescription'] = function(err, res, ctx, cfg)
                        local uri = 'https://sonar.optum.com/coding_rules?open=%s%3A%s'
                        local lang = res.languageKey
                        local spec = string.match(res.key, 'S(%d+)')
                        vim.ui.open(string.format(uri, lang, spec))
                    end,
                },
            },
            rules = { enabled = true },
            csharp = {
                enabled = false,
                omnisharpDirectory = vim.fn.expand '$MASON/packages/sonarlint-language-server/extension/omnisharp',
                csharpOssPath = vim.fn.expand '$MASON/share/sonarlint-analyzers/sonarcsharp.jar',
                csharpEnterprisePath = vim.fn.expand '$MASON/share/sonarlint-analyzers/csharpenterprise.jar',
            },
            go = {
                enabled = true,
            },
            html = {
                enabled = true,
            },
            iac = {
                -- Docker analysis only works on 'Dockerfile'
                -- All supported files: https://github.com/SonarSource/sonar-iac
                enabled = true,
            },
            java = {
                enabled = true,
                await_jdtls = true,
            },
            javascript = {
                enabled = true, -- Requires node >= 18.17.0
                clientNodePath = vim.fn.exepath 'node',
            },
            php = {
                enabled = true,
            },
            python = {
                enabled = true,
            },
            text = {
                enabled = true,
            },
            xml = {
                enabled = true,
            },
        }
    end,
}
