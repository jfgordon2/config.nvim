# Introduction

Personal Neovim configuration based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)
and influenced by [LazyVim](https://github.com/LazyVim/LazyVim).

This is [jfgordon2/config.nvim](https://github.com/jfgordon2/config.nvim), using
Neovim's native `vim.pack` plugin manager.

## Installation

### Install Neovim

Neovim **0.12 or newer** is required. On macOS, use [Homebrew](https://formulae.brew.sh/formula/neovim):

```sh
brew install neovim
```

Check the installed version with `nvim --version`.

### Install External Dependencies

External requirements:

- Basic tools: `git`, `make`, `unzip`, `tar`, `curl`, and a C compiler (Clang or GCC).
- [Tree-sitter CLI](https://github.com/tree-sitter/tree-sitter/tree/master/crates/cli), installed through your package manager.
- [ripgrep](https://github.com/BurntSushi/ripgrep#installation) for searching.
- A clipboard provider appropriate to your platform, such as xclip, xsel, or win32yank.
- A [Nerd Font](https://www.nerdfonts.com/) for icons. Configure `vim.g.have_nerd_font`
  in `lua/config/init.lua` to match your terminal font.
- Language toolchains as needed: Node.js/npm, Python 3 with pip/venv, Go, and Rust/Cargo.
  Python debugging also uses `uv`.

Mason installs the configured language servers, linters, formatters, and debugger
adapters. Some tools still come from their language toolchains, such as `rustfmt`
and `gofmt`. Use `:Mason` to inspect tool installation.

### Install the Configuration

Neovim's default configuration directory depends on your OS:

| OS | Path |
| :-- | :--- |
| Linux, macOS | `$XDG_CONFIG_HOME/nvim`, or `~/.config/nvim` |
| Windows (cmd) | `%LOCALAPPDATA%\nvim\` |
| Windows (PowerShell) | `$env:LOCALAPPDATA\nvim\` |

Back up an existing configuration before replacing it. To try this configuration in
parallel, use the separate-profile example in the FAQ below.

#### Recommended Step

[Fork](https://docs.github.com/en/get-started/quickstart/fork-a-repo) this repository
so you have your own copy to modify, then clone your fork using the commands below.
Replace `jfgordon2` with your GitHub username in the commands below.

Your fork's URL will look like `https://github.com/<your_github_username>/config.nvim.git`.
Keep `nvim-pack-lock.json` in version control so plugin revisions can be restored.

#### Clone config.nvim

<details><summary> Linux and Mac </summary>

```sh
git clone https://github.com/jfgordon2/config.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
```

</details>

<details><summary> Windows </summary>

If you're using `cmd.exe`:

```bat
git clone https://github.com/jfgordon2/config.nvim.git "%LOCALAPPDATA%\nvim"
```

If you're using PowerShell:

```powershell
git clone https://github.com/jfgordon2/config.nvim.git "${env:LOCALAPPDATA}\nvim"
```

</details>

### Post Installation

Start Neovim:

```sh
nvim
```

On first startup, `vim.pack` downloads the configured plugins at the revisions in
`nvim-pack-lock.json`. Build hooks compile LuaSnip's regular-expression support
and Telescope's native sorter, and update Tree-sitter parsers. Mason installs
the configured external tools. Allow these installations to finish.

Use `:PackStatus` to inspect plugins and `:Mason` to inspect external tools.

#### Managing Plugins

| Command | Action |
| :--- | :--- |
| `:PackStatus` | Inspect plugins without fetching updates. |
| `:PackUpdate` | Fetch and review updates; `:write` applies them and `:quit` cancels. |
| `:PackRestore` | Review restoring revisions from the current native lockfile, offline. |
| `:PackBuild LuaSnip` | Rebuild LuaSnip's regular-expression support. |
| `:PackBuild telescope-fzf-native.nvim` | Rebuild Telescope's native sorter. |
| `:PackBuild nvim-treesitter` | Update Tree-sitter parsers. |

Restart Neovim after updating plugins and commit the updated lockfile. To restore
an older plugin set, restore that version of `nvim-pack-lock.json`, restart, and
run `:PackRestore`.

Add repositories in `lua/config/packages.lua` and their setup modules in
`lua/config/pack.lua`. To remove a plugin, remove its inventory entry and setup,
restart, then delete its installation with `:lua vim.pack.del({'plugin-name'})`.
See `:help vim.pack` for the native API.

#### Read The Friendly Documentation

Start with `init.lua`, then explore the modules it loads:

- `lua/config/packages.lua`: plugin inventory.
- `lua/config/pack.lua` and `pack_build.lua`: setup order, commands, and build hooks.
- `lua/config/tools.lua` and `mason.lua`: language tools and installation.
- `lua/config/options.lua`, `keymaps.lua`, and `autocmds.lua`: editor behavior.
- `lua/config/icons.lua` and `buffers.lua`: shared icons and buffer actions.
- `lua/config/json.lua`: native JSON formatting shared by the JSON mappings and Conform.
- `lua/plugins/`: plugin settings grouped into UI, editor, tools, LSP, and AI.

For more information about a particular plugin, check its repository's documentation.

### Getting Started

[The Only Video You Need to Get Started with Neovim](https://youtu.be/m8C0Cq9Uv9o)

The leader key is **Space**. Press it and wait to see available mappings.

Groups use plain task names, and descriptions use verb-first wording. Key names
are case-sensitive; for example, `cJ` and `cj` perform different actions.

| Prefix | Group | Prefix | Group |
| :--- | :--- | :--- | :--- |
| `a` | AI | `b` | Buffers |
| `B` | Debug | `c` | Code |
| `d` | Document | `e` | Explorer |
| `g` | Git | `h` | Help |
| `k` | Notebook (notebook/cell buffers only) | `m` | Markdown |
| `n` | Notifications | `N` | Tests |
| `q` | Sessions | `r` | Refactor |
| `s` | Search | `t` | Toggles |
| `u` | Utilities | `v` | Terminals |
| `w` | Workspace | `x` | Diagnostics and lists |

`<leader>ee` opens the file explorer at the current file's Git root (falling back
to cwd); `<leader>eE` uses cwd. `<leader>nn` shows notification history, and
`<leader>gs` stages a hunk. `F7` toggles the debug UI; `<leader>BB` sets a
conditional breakpoint.

| Mapping | Action |
| :--- | :--- |
| `<leader>cf` | Format the current buffer, or the selected range in Visual mode. |
| `<leader>cF` | Show the selected formatters. |
| `<leader>cj` | Format JSON in the whole buffer or the exact Visual selection. |
| `<leader>c4` | Convert leading indentation to spaces and use four-space tab stops. |
| `<leader>ct` | Convert leading indentation to tabs displayed four columns wide. |
| `<leader>cJ` | Split/join arguments between single-line and multiline layouts. |
| `<leader>uc` | Pick color (Shades). |
| `<leader>ei` | Preview image at cursor. |
| `<leader>gi` | Preview Git hunk inline. |
| `<leader>ef` | Browse files in the current buffer’s directory. |
| `<leader>uw` | Show weather. |

JSON formatting uses native `vim.json` APIs and the buffer's indentation settings.
JSONC uses Biome to preserve comments. Native JSON formatting accepts one complete
JSON value; key sorting is disabled, but decoding and re-encoding may still change
object key order. Other formatters can enforce their own indentation styles.

Open `.ipynb` files to edit notebooks with `ipynb.nvim`. Use `:checkhealth ipynb`
to check dependencies. Kernel execution requires `jupyter_client` and an installed
Jupyter kernel in the Python environment selected for the notebook.

### FAQ

- **What should I do if I already have a Neovim configuration?**

  Back up your configuration before replacing it, or use a separate profile as
  described below. Keep your existing data so you can return to that setup.

- **Can I keep my existing configuration in parallel?**

  Yes. [NVIM_APPNAME](https://neovim.io/doc/user/starting/#%24NVIM_APPNAME)
  selects a separate configuration and matching data, state, and cache directories.
  For example, on Linux or macOS:

  ```sh
  git clone https://github.com/jfgordon2/config.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}/nvim-pack-test"
  alias nvim-pack-test='NVIM_APPNAME=nvim-pack-test nvim'
  ```

  Run `nvim-pack-test` to launch that profile. Normal `nvim` continues to use the
  configuration in the `nvim` directory.

- **How do I use the minimal or debug entry points with a separate profile?**

  Keep `NVIM_APPNAME` set when using `-u`:

  ```sh
  NVIM_APPNAME=nvim-pack-test nvim -u "${XDG_CONFIG_HOME:-$HOME/.config}/nvim-pack-test/init-minimal.lua"
  NVIM_APPNAME=nvim-pack-test nvim -u "${XDG_CONFIG_HOME:-$HOME/.config}/nvim-pack-test/init-debug.lua"
  ```

- **What if I want to uninstall this configuration?**

  Back up your changes, then remove the configuration directory you installed.
  To find its associated directories, launch that profile and inspect
  `:echo stdpath('config')`, `:echo stdpath('data')`, `:echo stdpath('state')`,
  and `:echo stdpath('cache')`. Remove only directories belonging to that profile,
  or restore your previous configuration.

- **Why is the configuration split across multiple Lua files?**

  This configuration has grown beyond Kickstart's single-file layout. Core
  settings live in `lua/config/`, while plugin setup lives in `lua/plugins/`.
  `init.lua` loads the configuration entry point.

## Testing

The integration runner targets the `nvim-pack-test` profile shown above. After
its plugins and tools finish installing, run:

```sh
python3 "${XDG_CONFIG_HOME:-$HOME/.config}/nvim-pack-test/tests/run.py"
```

It checks keymap descriptions and groups, explorer paths, JSON formatting, notebook editing and saving,
Lua/Python/TypeScript/Rust LSP attachment,
first-save Lua formatting, native plugin components, and Markdown/text diagnostics.
AI authentication and real project debug/test sessions require a manual check.
