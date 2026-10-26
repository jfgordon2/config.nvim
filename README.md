# Native Neovim test configuration

This is an independent migration of your existing configuration to Neovim 0.12+
`vim.pack`. Launch it with:

```sh
NVIM_APPNAME=nvim-pack-test nvim
```

Normal `nvim` continues to use your original Lazy configuration. `NVIM_APPNAME`
also gives this configuration separate plugins, Mason tools, parsers, sessions,
undo, shada, cache, and logs. Keep the environment variable when using `-u`:

```sh
NVIM_APPNAME=nvim-pack-test nvim -u ~/.config/nvim-pack-test/init-minimal.lua
NVIM_APPNAME=nvim-pack-test nvim -u ~/.config/nvim-pack-test/init-debug.lua
```

## Layout

- `lua/config/packages.lua`: flat native repository/version inventory, including dependencies.
- `lua/config/pack_build.lua`: install/update build hooks, registered before any native package operation.
- `lua/config/pack.lua`: explicit setup order and convenience commands.
- `lua/config/tools.lua`: shared language-server, linter, formatter, and Mason package selections.
- `lua/config/mason.lua`: the one tool installer, including debug adapters.
- `lua/config/icons.lua`: icon definitions imported locally by consumers.
- `lua/config/buffers.lua`: shared buffer actions.
- `lua/data/fortunes.lua`: fortune content kept separate from plugin setup.
- `lua/plugins/`: existing plugin settings and mappings, expressed as plain setup functions.
- `nvim-pack-lock.json`: native lockfile, generated from the original plugin revisions.

There is no Lazy, compatibility layer, manager wrapper, or custom lazy loader.
Plugin code is made available at startup; setup happens before the first file
opens so formatting, linting, sessions, and LSP work on the first event. The
Python virtualenv mapping remains buffer-local. Floaterm remains disabled.

## Managing plugins

- `:PackStatus`: native offline plugin review; does not fetch.
- `:PackUpdate`: fetch and review updates. Use `:write` to apply or `:quit` to cancel.
- `:PackRestore`: review restoring the current native lockfile's revisions, offline.
- `:PackBuild LuaSnip`, `:PackBuild telescope-fzf-native.nvim`, or `:PackBuild nvim-treesitter`: rerun a build.
- Remove an entry from `packages.lua`, restart, then call `:lua vim.pack.del({'plugin-name'})` to delete it.

After updates, restart Neovim. Track `nvim-pack-lock.json` along with the config.
To roll back, restore an earlier lockfile, restart, and run `:PackRestore`.

Build hooks compile Telescope's native sorter and LuaSnip's jsregexp library,
and update installed Tree-sitter parsers. Copilot authentication is explicit:
`:CopilotSignin` / `:CopilotSignout`. The separate app may require signing in
again. Existing authentication files are not copied by this migration.

The dashboard's Plugins action opens the native review buffer. Its Lazy-specific
startup statistics were removed. There is no automatic plugin update checker.

Two existing LSP configuration problems were corrected in this copy: Harper's
settings key is `harper-ls`, and CodeQL has an explicit native server definition.

`<leader>cj` formats JSON in the whole buffer in Normal mode, or only the active
characterwise/linewise selection in Visual mode. It uses native `vim.json` APIs
with the buffer's indentation settings, preserves surrounding text and indentation,
and leaves the buffer unchanged on invalid JSON. Input must be one complete JSON
value. Key sorting is disabled, though native decoding and re-encoding may still
change object key order.

`<leader>cf` and format-on-save also use this native formatter for `json` buffers
through Conform. JSONC uses Biome to preserve comments. `<leader>cF` shows the
formatter selected for the current buffer.

`<leader>c4` converts the current buffer's leading indentation to spaces (four per
tab stop); `<leader>ct` converts it to tabs with a display width of four. Both set
buffer-local indentation options for subsequent edits. Formatters still apply
their configured indentation style when formatting or saving.

## Testing

The migration is checked with real startup/file-open runs for Lua, Python, TypeScript, and Rust; original keymaps; first-save Lua formatting; LSP attachment;
native completion/snippet/sorter libraries; and fresh-install/lockfile-reinstall
build hooks. `tests/smoke.lua` is the integration check entry point, driven by
an isolated test runner during the migration. Run it with
`python3 ~/.config/nvim-pack-test/tests/run.py`. The checks use the current plugin inventory and native lockfile.
Interactive AI authentication and
actual project debug/test sessions still need a manual check.

Plugins and existing tools were seeded as independent copies, not symlinks or
hard links to the default installation. The inventory now contains 66 plugins after removing standalone mini.icons,
indent-blankline, and Neoscroll. The existing mini.nvim provides icons; Snacks
provides indentation and scrolling. Remaining plugin revisions are preserved.

Rustaceanvim owns Rust LSP and Cargo integration. Ruff, Biome, and Vale use LSP
for diagnostics; Conform owns formatting. Vale starts only in projects with
`.vale.ini`. External tools marked `false` in the shared tool definitions are
provided by system toolchains or are optional Python formatting fallbacks.
