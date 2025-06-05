-- Nvim-lint - Asynchronous linting
-- Code linting with support for multiple linters

return {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPost', 'BufNewFile', 'BufWritePost' },
    opts = {
        events = { 'BufWritePost', 'BufReadPost', 'InsertLeave' },
        linters_by_ft = {
            markdown = { 'markdownlint' },
            docker = { 'hadolint' },
            hcl = { 'terraform_validate' },
            javascript = { 'eslint' },
            json = { 'jsonlint' },
            python = { 'ruff' },
            sh = { 'shellcheck' },
            terraform = { 'terraform_validate' },
            yaml = { 'actionlint', 'yamllint' },
            ansible = { 'ansible-lint' },
            text = { 'vale' },
        },
        linters = {
            actionlint = {
                condition = function(ctx)
                    return string.match(ctx.filename, '%.github/workflows/.*%.ya?ml$')
                end,
            },
            yamllint = {
                condition = function(ctx)
                    return string.match(ctx.filename, '%.ya?ml$') and not string.match(ctx.filename, '%.github/workflows/.*%.ya?ml$')
                end,
            },
            markdownlint = {
                args = { '--stdin', '--disable', 'MD013', 'MD033' },
            },
        },
    },
    config = function(_, opts)
        local lint = require 'lint'

        -- Setup linters
        for name, linter in pairs(opts.linters) do
            if type(linter) == 'table' and type(lint.linters[name]) == 'table' then
                lint.linters[name] = vim.tbl_deep_extend('force', lint.linters[name], linter)
                if type(linter.prepend_args) == 'table' then
                    lint.linters[name].args = lint.linters[name].args or {}
                    vim.list_extend(lint.linters[name].args, linter.prepend_args)
                end
            else
                lint.linters[name] = linter
            end
        end
        lint.linters_by_ft = opts.linters_by_ft

        -- Debounced lint function
        local function debounce(ms, fn)
            local timer = vim.uv.new_timer()
            return function(...)
                local argv = { ... }
                timer:start(ms, 0, function()
                    timer:stop()
                    vim.schedule_wrap(fn)(unpack(argv))
                end)
            end
        end

        local function lint_current_buffer()
            local names = lint._resolve_linter_by_ft(vim.bo.filetype)
            names = vim.list_extend({}, names)

            -- Add fallback linters
            if #names == 0 then
                vim.list_extend(names, lint.linters_by_ft['_'] or {})
            end

            -- Add global linters
            vim.list_extend(names, lint.linters_by_ft['*'] or {})

            -- Filter out invalid linters
            local ctx = { filename = vim.api.nvim_buf_get_name(0) }
            ctx.dirname = vim.fn.fnamemodify(ctx.filename, ':h')

            names = vim.tbl_filter(function(name)
                local linter = lint.linters[name]
                if not linter then
                    if _G.LazyVim and _G.LazyVim.warn then
                        _G.LazyVim.warn('Linter not found: ' .. name, { title = 'nvim-lint' })
                    else
                        vim.notify('Linter not found: ' .. name, vim.log.levels.WARN)
                    end
                    return false
                end
                return not (type(linter) == 'table' and linter.condition and not linter.condition(ctx))
            end, names)

            -- Run linters
            if #names > 0 then
                lint.try_lint(names)
            end
        end

        -- Setup autocmd for linting
        vim.api.nvim_create_autocmd(opts.events, {
            group = vim.api.nvim_create_augroup('nvim-lint', { clear = true }),
            callback = debounce(100, lint_current_buffer),
        })
    end,
}
