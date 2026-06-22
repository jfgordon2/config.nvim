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

return {
    {
        'folke/sidekick.nvim',
        lazy = false,
        opts = {
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
        },
        config = function(_, opts)
            patch_sidekick_mux()
            require('sidekick').setup(opts)
        end,
        keys = {
            {
                '<c-.>',
                function()
                    require('sidekick.cli').focus()
                end,
                desc = 'Sidekick Focus',
                mode = { 'n', 't', 'i', 'x' },
            },
            {
                '<leader>aa',
                function()
                    require('sidekick.cli').toggle()
                end,
                desc = 'Sidekick Toggle CLI',
            },
            {
                '<leader>as',
                function()
                    require('sidekick.cli').select()
                end,
                desc = 'Select CLI',
            },
            {
                '<leader>ad',
                function()
                    require('sidekick.cli').close()
                end,
                desc = 'Detach a CLI Session',
            },
            {
                '<leader>at',
                function()
                    require('sidekick.cli').send { msg = '{this}' }
                end,
                mode = { 'x', 'n' },
                desc = 'Send This',
            },
            {
                '<leader>af',
                function()
                    require('sidekick.cli').send { msg = '{file}' }
                end,
                desc = 'Send File',
            },
            {
                '<leader>av',
                function()
                    require('sidekick.cli').send { msg = '{selection}' }
                end,
                mode = { 'x' },
                desc = 'Send Visual Selection',
            },
            {
                '<leader>ap',
                function()
                    require('sidekick.cli').prompt()
                end,
                mode = { 'n', 'x' },
                desc = 'Sidekick Select Prompt',
            },
            {
                '<leader>ac',
                function()
                    require('sidekick.cli').toggle { name = 'codex', focus = true }
                end,
                desc = 'Sidekick Toggle Codex',
            },
        },
    },
}
