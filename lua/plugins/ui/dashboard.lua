-- Snacks - Swiss army knife for Neovim
-- Dashboard, notifications, and essential utilities with full configuration

return {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    keys = {
        {
            '<leader>wd',
            function()
                Snacks.dashboard.open()
            end,
            desc = '[W]orkspace: Show [D]ashboard',
        },
        {
            '<leader>wf',
            function()
                os.execute('open ' .. Snacks.git.get_root())
            end,
            desc = '[W]orkspace: Open in Finder',
        },
        {
            '<leader>ww',
            function()
                local on_exit = function(obj)
                    if obj.code == 0 then
                        vim.schedule(function()
                            local normalize = string.gsub(obj.stdout, '"', '')
                            vim.notify(normalize, vim.log.levels.INFO, { title = 'Davenport, IA' })
                        end)
                    else
                        vim.schedule(function()
                            vim.notify(vim.json.encode(obj))
                        end)
                    end
                end
                vim.system({ 'curl', '-s', 'https://wttr.in/52803?format="%c%20Actual:%20%t,%20Feels:%20%f%20Precip:%20%p"&u' }, { text = true }, on_exit)
            end,
            desc = '[W]orkspace: Show [W]eather',
        },
        {
            '<leader>nn',
            function()
                Snacks.notifier.show_history()
            end,
            desc = '[N]otifications: Show [N]otifications History',
        },
        {
            '<leader>nh',
            function()
                Snacks.notifier.hide()
            end,
            desc = '[N]otifications: [H]ide',
        },
        {
            '<leader>ng',
            function()
                Snacks.notifier.get_history()
            end,
            desc = '[N]otifications: [G]et History',
        },
        {
            '<leader>gg',
            function()
                if vim.fn.executable 'lazygit' == 1 then
                    Snacks.lazygit { cwd = Snacks.git.get_root() }
                end
            end,
            desc = '[G]it: Lazygit (Root Dir)',
        },
        {
            '<leader>gG',
            function()
                if vim.fn.executable 'lazygit' == 1 then
                    Snacks.lazygit()
                end
            end,
            desc = '[G]it: Lazygit (cwd)',
        },
        {
            '<leader>gb',
            function()
                vim.fn.system 'gh browse'
            end,
            desc = '[G]it: [B]rowse',
        },
    },
    opts = {
        -- Core snacks modules
        indent = { enabled = true },
        dashboard = { enabled = true },
        notifier = { enabled = true },
        scope = { enabled = true },
        scroll = { enabled = true },
        toggle = { enabled = true, map = vim.keymap.set, which_key = true },
        words = { enabled = true },
        quickfile = { enabled = true },
        statuscolumn = { enabled = true },

        -- Lazygit configuration
        lazygit = {
            configure = true,
            config = {
                os = { editPreset = 'nvim-remote' },
                gui = { nerdFontsVersion = '3' },
                theme = {
                    [241] = { fg = 'Special' },
                    activeBorderColor = { fg = 'MatchParen', bold = true },
                    cherryPickedCommitBgColor = { fg = 'Identifier' },
                    cherryPickedCommitFgColor = { fg = 'Function' },
                    defaultFgColor = { fg = 'Normal' },
                    inactiveBorderColor = { fg = 'FloatBorder' },
                    optionsTextColor = { fg = 'Function' },
                    searchingActiveBorderColor = { fg = 'MatchParen', bold = true },
                    selectedLineBgColor = { bg = 'Visual' },
                    unstagedChangesColor = { fg = 'DiagnosticError' },
                },
                win = { style = 'lazygit' },
            },
        },
    },
    config = function(_, opts)
        local snacks = require 'snacks'

        -- Merge dashboard configuration with the rest
        opts.dashboard = vim.tbl_deep_extend('force', opts.dashboard or {}, {
            width = 60,
            row = nil, -- dashboard position. nil for center
            col = nil, -- dashboard position. nil for center
            pane_gap = 4, -- empty columns between vertical panes
            autokeys = '1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ',

            preset = {
                pick = nil,
                keys = {
                    { icon = ' ', key = 'f', desc = 'Find File', action = ":lua Snacks.dashboard.pick('files')" },
                    { icon = ' ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
                    { icon = ' ', key = 'g', desc = 'Find Text', action = ":lua Snacks.dashboard.pick('live_grep')" },
                    { icon = ' ', key = 'r', desc = 'Recent Files', action = ":lua Snacks.dashboard.pick('oldfiles')" },
                    { icon = ' ', key = 'c', desc = 'Config', action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
                    { icon = ' ', key = 's', desc = 'Restore Session', section = 'session' },
                    { icon = '󰒲 ', key = 'L', desc = 'Lazy', action = ':Lazy', enabled = package.loaded.lazy ~= nil },
                    { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
                },
                header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
            },

            -- Dashboard sections
            sections = {
                { section = 'header' },
                { section = 'keys', gap = 1, padding = 1 },
                {
                    pane = 2,
                    icon = ' ',
                    desc = 'Browse Repo',
                    padding = 1,
                    key = 'b',
                    action = function()
                        snacks.gitbrowse()
                    end,
                },
                { pane = 1, icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 1 },
                { pane = 1, icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 1 },
                {
                    pane = 2,
                    icon = ' ',
                    title = 'Git Status',
                    section = 'terminal',
                    enabled = function()
                        return snacks.git.get_root() ~= nil
                    end,
                    cmd = 'git status --short --branch --renames',
                    height = 5,
                    padding = 1,
                    ttl = 5 * 60,
                    indent = 3,
                },
                function()
                    local in_git = snacks.git.get_root() ~= nil
                    local cmds = {
                        {
                            title = 'Notifications',
                            cmd = "nvim --headless -c ':GHNotificationsText' -c 'sleep 20000m' -c 'qa!'",
                            action = function()
                                vim.ui.open 'https://github.com/notifications'
                            end,
                            key = 'n',
                            icon = ' ',
                            height = 8,
                            enabled = true,
                        },
                        {
                            icon = ' ',
                            title = 'Open PRs',
                            cmd = 'gh pr list -L 3',
                            key = 'p',
                            action = function()
                                vim.fn.jobstart('gh pr list --web', { detach = true })
                            end,
                            height = 7,
                        },
                        {
                            icon = ' ',
                            title = 'Git Status',
                            cmd = 'git --no-pager diff --stat -B -M -C',
                            height = 10,
                        },
                    }
                    return vim.tbl_map(function(cmd)
                        return vim.tbl_extend('force', {
                            pane = 2,
                            section = 'terminal',
                            enabled = in_git,
                            padding = 1,
                            ttl = 5 * 60,
                            indent = 3,
                        }, cmd)
                    end, cmds)
                end,
                { section = 'startup' },
            },

            -- Item formatters
            formats = {
                icon = function(item)
                    if item.file and (item.icon == 'file' or item.icon == 'directory') then
                        -- Use default icons if LazyVim config not available
                        if _G.LazyVim and _G.LazyVim.config and _G.LazyVim.config.icons then
                            local icons = vim.deepcopy(_G.LazyVim.config.icons.kinds)
                            if item.icon == 'file' then
                                return icons.File
                            elseif item.icon == 'directory' then
                                return icons.Folder
                            end
                        end
                    end
                    return { item.icon, width = 2, hl = 'icon' }
                end,
                footer = { '%s', align = 'center' },
                header = { '%s', align = 'center' },
                file = function(item, ctx)
                    local fname = vim.fn.fnamemodify(item.file, ':~')
                    fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
                    if #fname > ctx.width then
                        local dir = vim.fn.fnamemodify(fname, ':h')
                        local file = vim.fn.fnamemodify(fname, ':t')
                        if dir and file then
                            file = file:sub(-(ctx.width - #dir - 2))
                            fname = dir .. '/…' .. file
                        end
                    end
                    local dir, file = fname:match '^(.*)/(.+)$'
                    return dir and { { dir .. '/', hl = 'dir' }, { file, hl = 'file' } } or { { fname, hl = 'file' } }
                end,
            },
        })

        -- Setup snacks with the complete configuration
        snacks.setup(opts)
    end,
}
