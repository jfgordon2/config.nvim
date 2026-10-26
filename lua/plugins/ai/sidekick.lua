local function patch_sidekick_mux()
    local config = require 'sidekick.config'
    local session = require 'sidekick.cli.session'
    local terminal = require 'sidekick.cli.terminal'
    local session_backends = {
        tmux = 'sidekick.cli.session.tmux',
        zellij = 'sidekick.cli.session.zellij',
    }

    ---@diagnostic disable-next-line: duplicate-set-field
    session.setup = function()
        if session.did_setup then
            return
        end

        session.did_setup = true
        config.tools()

        local backend = config.cli.mux.enabled and config.cli.mux.backend or nil
        local module = backend and session_backends[backend] or nil

        if backend and module and vim.fn.executable(backend) == 1 then
            session.register(backend, require(module))
        end

        session.register('terminal', terminal)
    end
end

return function()
    local opts = {
        cli = {
            mux = {
                backend = 'tmux',
                enabled = true,
                create = 'terminal',
                split = {
                    vertical = true,
                    size = 0.3,
                },
            },
            tools = {
                codex = {
                    cmd = { 'codex' },
                },
            },
        },
        copilot = {
            status = {
                enabled = false,
            },
        },
    }
    patch_sidekick_mux()
    require('sidekick').setup(opts)

    vim.keymap.set({ 'n', 't', 'i', 'x' }, '<c-.>', function()
        require('sidekick.cli').focus()
    end, { desc = 'Focus AI CLI' })
    vim.keymap.set('n', '<leader>aa', function()
        require('sidekick.cli').toggle()
    end, { desc = 'Toggle AI CLI' })
    vim.keymap.set('n', '<leader>as', function()
        require('sidekick.cli').select()
    end, { desc = 'Choose AI CLI' })
    vim.keymap.set('n', '<leader>ad', function()
        require('sidekick.cli').close()
    end, { desc = 'Detach AI CLI session' })
    vim.keymap.set({ 'x', 'n' }, '<leader>at', function()
        require('sidekick.cli').send { msg = '{this}' }
    end, { desc = 'Send current context to AI' })
    vim.keymap.set('n', '<leader>af', function()
        require('sidekick.cli').send { msg = '{file}' }
    end, { desc = 'Send file to AI' })
    vim.keymap.set({ 'x' }, '<leader>av', function()
        require('sidekick.cli').send { msg = '{selection}' }
    end, { desc = 'Send selection to AI' })
    vim.keymap.set({ 'n', 'x' }, '<leader>ap', function()
        require('sidekick.cli').prompt()
    end, { desc = 'Choose AI prompt' })
    vim.keymap.set('n', '<leader>ac', function()
        require('sidekick.cli').toggle { name = 'codex', focus = true }
    end, { desc = 'Toggle Codex CLI' })
end
