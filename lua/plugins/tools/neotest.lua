return function()
    require('neotest').setup {
        adapters = {
            require 'neotest-jest' {
                jestCommand = 'npm test --',
                jestConfigFile = 'custom.jest.config.ts',
                env = { CI = true },
                cwd = function(path)
                    return vim.fn.getcwd()
                end,
            },
            require('neotest-playwright').adapter {
                options = {
                    persist_project_selection = true,
                    enable_dynamic_test_discovery = true,
                },
            },
            require 'neotest-plenary',
            require 'neotest-python' {
                dap = { justMyCode = false },
            },
            require 'neotest-vim-test' {
                ignore_file_types = { 'python', 'vim', 'lua' },
            },
        },
    }
    vim.keymap.set('n', '<leader>Nt', function()
        require('neotest').run.run()
    end, { desc = 'Run nearest test' })
    vim.keymap.set('n', '<leader>Nf', function()
        require('neotest').run.run(vim.fn.expand '%')
    end, { desc = 'Run tests in current file' })
    vim.keymap.set('n', '<leader>Nd', function()
        require('neotest').run.run { strategy = 'dap' }
    end, { desc = 'Debug nearest test' })
    vim.keymap.set('n', '<leader>Ns', function()
        require('neotest').run.stop()
    end, { desc = 'Stop nearest test' })
    vim.keymap.set('n', '<leader>Na', function()
        require('neotest').run.attach()
    end, { desc = 'Attach to nearest test' })
end
