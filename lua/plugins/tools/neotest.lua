return {
    'nvim-neotest/neotest',
    dependencies = {
        'antoinemadec/FixCursorHold.nvim',
        'nvim-lua/plenary.nvim',
        'nvim-neotest/neotest-jest',
        'nvim-neotest/neotest-plenary',
        'nvim-neotest/neotest-python',
        'nvim-neotest/neotest-vim-test',
        'nvim-neotest/nvim-nio',
        'nvim-treesitter/nvim-treesitter',
        'thenbe/neotest-playwright',
    },
    config = function()
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
        end, { desc = '[N]eotest: Run nearest [t]est' })
        vim.keymap.set('n', '<leader>Nf', function()
            require('neotest').run.run(vim.fn.expand '%')
        end, { desc = '[N]eotest: Run current [f]ile' })
        vim.keymap.set('n', '<leader>Nd', function()
            require('neotest').run.run { strategy = 'dap' }
        end, { desc = '[N]eotest: [D]ebug nearest test' })
        vim.keymap.set('n', '<leader>Ns', function()
            require('neotest').run.stop()
        end, { desc = '[N]eotest: [S]top nearest test' })
        vim.keymap.set('n', '<leader>Na', function()
            require('neotest').run.attach()
        end, { desc = '[N]eotest: [A]ttach nearest test' })
    end,
}
