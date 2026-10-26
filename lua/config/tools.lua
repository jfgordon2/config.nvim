-- Tool selections and Mason identities shared by LSP, linting, and formatting.
local M = {}
local cucumber = {
    features = {
        'integration_tests/features/**/*.feature',
    },
    glue = {
        'integration_tests/steps/**/*.py',
    },
    parameterTypes = {
        { name = '{string}', regexp = '".*"' },
        { name = '{sentence}', regexp = '".*"' },
        { name = '{multilineText}', regexp = '((?:.+\\n)*.+)' },
        { name = '{string1}', regexp = '"[^"]*"' },
    },
}
M.servers = {
    ansiblels = {},
    basedpyright = {},
    bashls = {},
    biome = {
        settings = {
            json = {
                format = {
                    enable = true,
                    defaultConfig = {
                        indent_size = '2',
                        indent_style = 'space',
                    },
                },
            },
        },
    },
    -- This server no longer has a config in the installed lspconfig.
    codeqlls = {
        cmd = {
            'codeql',
            'execute',
            'language-server',
            '--check-errors=ON_CHANGE',
            '-q',
            '--common-caches=' .. vim.fn.stdpath 'cache' .. '/codeql',
        },
        filetypes = { 'ql' },
        root_markers = { 'qlpack.yml', '.git' },
    },
    cssls = {},
    cucumber_language_server = {
        enable = true,
        settings = vim.tbl_extend('force', { cucumber = cucumber }, cucumber),
    },
    docker_compose_language_service = {},
    dockerls = {},
    eslint = {},
    gh_actions_ls = {},
    gopls = {},
    harper_ls = {
        enable = true,
        settings = {
            ['harper-ls'] = {
                markdown = {
                    IgnoreLinkTitle = true,
                },
                linters = {
                    AnA = false,
                    CorrectNumberSyntax = false,
                    LongSentences = false,
                    Matcher = false,
                    RepeatedWords = true,
                    SentenceCapitalization = false,
                    Spaces = false,
                    SpellCheck = false,
                    SpelledNumbers = false,
                    ToDoHyphen = false,
                    UnclosedQuotes = false,
                    WrongQuotes = false,
                },
                codeActions = {
                    ForceStable = false,
                },
                diagnosticSeverity = 'hint',
                isolateEnglish = false,
                dialect = 'American',
                maxFileLength = 120000,
            },
        },
    },
    html = {},
    -- htmx = {},
    jqls = {},
    jsonls = {},
    lua_ls = {
        settings = {
            Lua = {
                completion = {
                    callSnippet = 'Replace',
                },
                format = {
                    enable = true,
                    defaultConfig = {
                        indent_style = 'space',
                        indent_size = '4',
                    },
                },
            },
        },
    },
    ruff = {},
    sqlls = {},
    tailwindcss = {},
    taplo = {},
    -- terraformls = {},
    -- Vale requires project-specific rules from .vale.ini.
    vale_ls = { workspace_required = true },
    yamlls = {
        settings = {
            yaml = {
                customTags = {
                    '!And sequence',
                    '!And',
                    '!If',
                    '!If sequence',
                    '!Not',
                    '!Not sequence',
                    '!Equals',
                    '!Equals sequence',
                    '!Or',
                    '!Or sequence',
                    '!FindInMap',
                    '!FindInMap sequence',
                    '!Base64',
                    '!Join',
                    '!Join sequence',
                    '!Cidr',
                    '!Ref',
                    '!Sub',
                    '!Sub sequence',
                    '!GetAtt',
                    '!GetAZs',
                    '!ImportValue',
                    '!ImportValue sequence',
                    '!Select',
                    '!Select sequence',
                    '!Split',
                    '!Split sequence',
                },
                schemas = {
                    ['https://raw.githubusercontent.com/kedro-org/kedro/develop/static/jsonschema/kedro-catalog-0.17.json'] = 'conf/**/*catalog*',
                    ['https://json.schemastore.org/github-workflow.json'] = '/.github/workflows/*',
                },
            },
        },
    },
}
M.linters_by_ft = {
    markdown = { 'markdownlint' },
    docker = { 'hadolint' },
    hcl = { 'terraform_validate' },
    json = { 'jsonlint' },
    sh = { 'shellcheck' },
    terraform = { 'terraform_validate' },
    yaml = { 'actionlint', 'yamllint' },
    ansible = { 'ansible-lint' },
}
M.formatters_by_ft = {
    css = { 'biome' },
    fish = { 'fish_indent' },
    graphql = { 'biome' },
    go = { 'goimports', 'gofmt' },
    hcl = { 'terraform_fmt' },
    html = { 'biome' },
    lua = { 'stylua' },
    rust = { 'rustfmt', lsp_format = 'fallback' },
    javascript = { 'biome' },
    javascriptreact = { 'biome' },
    json = { 'json_native' },
    jsonc = { 'biome' },
    markdown = { 'markdownlint-cli2' },
    ['markdown.mdx'] = { 'markdownlint-cli2' },
    mysql = { 'sqlfluff' },
    plsql = { 'sqlfluff' },
    python = function(bufnr)
        if require('conform').get_formatter_info('ruff_format', bufnr).available then
            return { 'ruff_format', 'ruff_organize_imports' }
        else
            return { 'isort', 'black' }
        end
    end,
    sh = { 'shfmt' },
    sql = { 'sqlfluff' },
    svelte = { 'biome' },
    terraform = { 'terraform_fmt' },
    ['terraform-vars'] = { 'terraform_fmt' },
    tf = { 'terraform_fmt' },
    toml = { 'taplo' },
    typescript = { 'biome' },
    typescriptreact = { 'biome' },
    vue = { 'biome' },
    yaml = { 'yamlfmt' },
    -- ['*'] = { 'codespell' },
    ['_'] = { 'trim_whitespace' },
}
M.server_packages = {
    ansiblels = 'ansible-language-server',
    basedpyright = 'basedpyright',
    bashls = 'bash-language-server',
    biome = 'biome',
    codeqlls = 'codeql',
    cssls = 'css-lsp',
    cucumber_language_server = 'cucumber-language-server',
    docker_compose_language_service = 'docker-compose-language-service',
    dockerls = 'dockerfile-language-server',
    eslint = 'eslint-lsp',
    gh_actions_ls = 'gh-actions-language-server',
    gopls = 'gopls',
    harper_ls = 'harper-ls',
    html = 'html-lsp',
    jqls = 'jq-lsp',
    jsonls = 'json-lsp',
    lua_ls = 'lua-language-server',
    ruff = 'ruff',
    sqlls = 'sqlls',
    tailwindcss = 'tailwindcss-language-server',
    taplo = 'taplo',
    vale_ls = 'vale-ls',
    yamlls = 'yaml-language-server',
}
M.linter_packages = {
    actionlint = 'actionlint',
    jsonlint = 'jsonlint',
    markdownlint = 'markdownlint',
    shellcheck = 'shellcheck',
    yamllint = 'yamllint',
    hadolint = 'hadolint',
    ['ansible-lint'] = 'ansible-lint',
    terraform_validate = false,
}
M.formatter_packages = {
    json_native = false, -- Native Lua formatter; no Mason package.
    biome = 'biome',
    goimports = 'goimports',
    stylua = 'stylua',
    ['markdownlint-cli2'] = 'markdownlint-cli2',
    sqlfluff = 'sqlfluff',
    ruff_format = 'ruff',
    ruff_organize_imports = 'ruff',
    shfmt = 'shfmt',
    taplo = 'taplo',
    yamlfmt = 'yamlfmt',
    -- These executables come from a toolchain or are optional Python fallbacks.
    fish_indent = false,
    gofmt = false,
    terraform_fmt = false,
    rustfmt = false,
    black = false,
    isort = false,
    trim_whitespace = false,
}
-- Tools used by Rustaceanvim, DAP, TypeScript Tools, and SonarQube.
M.extra_packages = { 'rust-analyzer', 'delve', 'typescript-language-server', 'sonarlint-language-server', 'vale' }
function M.packages()
    local packages = {}
    for _, mapping in ipairs { M.server_packages, M.linter_packages, M.formatter_packages } do
        for _, package in pairs(mapping) do
            if package then
                packages[package] = true
            end
        end
    end
    for _, package in ipairs(M.extra_packages) do
        packages[package] = true
    end
    local names = vim.tbl_keys(packages)
    table.sort(names)
    return names
end
return M
