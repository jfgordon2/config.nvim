# Introduction

Personal Neovim configuration based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)
and influenced by [LazyVim](https://github.com/LazyVim/LazyVim).

This is [jfgordon2/config.nvim](https://github.com/jfgordon2/config.nvim). The
`main` branch uses lazy.nvim; the [vim-pack branch](https://github.com/jfgordon2/config.nvim/tree/vim-pack)
uses Neovim's native plugin manager.

## Installation

### Install Neovim

Install a current stable release. On macOS, use [Homebrew](https://formulae.brew.sh/formula/neovim):

```sh
brew install neovim
```

### Install External Dependencies

External Requirements:

- Basic tools: `git`, `make`, `unzip`, `tar`, `curl`, and a C compiler (Clang or GCC)
- [Tree-sitter CLI](https://github.com/tree-sitter/tree-sitter/tree/master/crates/cli), installed through your package manager
- [ripgrep](https://github.com/BurntSushi/ripgrep#installation)
- Clipboard tool (xclip/xsel/win32yank or other depending on the platform)
- A [Nerd Font](https://www.nerdfonts.com/): optional, provides various icons
  - configure `vim.g.have_nerd_font` in `lua/config/lazy.lua` to match your terminal font
- Language Setup:
  - If you want to write TypeScript, you need Node.js and `npm`
  - If you want to write Go, you will need `go`
  - etc.

### Install the Configuration

Neovim's configurations are located under the following paths, depending on your OS:

| OS | PATH |
| :-- | :--- |
| Linux, MacOS | `$XDG_CONFIG_HOME/nvim`, `~/.config/nvim` |
| Windows (cmd) | `%LOCALAPPDATA%\nvim\` |
| Windows (PowerShell) | `$env:LOCALAPPDATA\nvim\` |

#### Recommended Step

[Fork](https://docs.github.com/en/get-started/quickstart/fork-a-repo) this repo
so that you have your own copy that you can modify, then install by cloning the
fork to your machine using one of the commands below, depending on your OS.

> **NOTE**
> Your fork's URL will be something like this:
> `https://github.com/<your_github_username>/config.nvim.git`

Keep `lazy-lock.json` in version control so your plugin revisions can be restored.
It is already tracked in this repository.

#### Clone config.nvim
>
> **NOTE**
> If following the recommended step above (i.e., forking the repo), replace
> `jfgordon2` with `<your_github_username>` in the commands below

<details><summary> Linux and Mac </summary>

```sh
git clone --branch main https://github.com/jfgordon2/config.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
```

</details>

<details><summary> Windows </summary>

If you're using `cmd.exe`:

```shell
git clone --branch main https://github.com/jfgordon2/config.nvim.git "%localappdata%\nvim"
```

If you're using `powershell.exe`

```shell
git clone --branch main https://github.com/jfgordon2/config.nvim.git "${env:LOCALAPPDATA}\nvim"
```

</details>

### Post Installation

Start Neovim

```shell
nvim
```

That's it! Lazy will install all the plugins you have. Use `:Lazy` to view
the current plugin status. Hit `q` to close the window.

#### Read The Friendly Documentation

Start with `init.lua`, then explore the modules it loads:

- `lua/config/lazy.lua`: plugin manager and plugin-category imports.
- `lua/config/options.lua`, `keymaps.lua`, and `autocmds.lua`: editor behavior.
- `lua/plugins/`: plugin settings grouped into UI, editor, tools, LSP, and AI.

> [!NOTE]
> For more information about a particular plugin check its repository's documentation.

### Getting Started

[The Only Video You Need to Get Started with Neovim](https://youtu.be/m8C0Cq9Uv9o)

### FAQ

- **What should I do if I already have a Neovim configuration?**

  Back up your configuration before replacing it, or use a separate profile as
  described below. Keep your existing data so you can return to that setup.

- **Can I keep my existing configuration in parallel?**

  Yes. [NVIM_APPNAME](https://neovim.io/doc/user/starting/#%24NVIM_APPNAME)
  selects a separate configuration and matching data, state, and cache directories.
  For example, on Linux or macOS:

  ```sh
  git clone --branch main https://github.com/jfgordon2/config.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}/nvim-config"
  alias nvim-config='NVIM_APPNAME=nvim-config nvim'
  ```

  Run `nvim-config` to launch that profile. Normal `nvim` continues to use the
  configuration in the `nvim` directory.

- **What if I want to uninstall this configuration?**

  Back up your changes, then remove the configuration directory you installed.
  To find its associated directories, launch that profile and inspect
  `:echo stdpath('config')`, `:echo stdpath('data')`, `:echo stdpath('state')`,
  and `:echo stdpath('cache')`. Remove only directories belonging to that profile,
  or restore your previous configuration.

- **Why is the configuration split across multiple Lua files?**

  This configuration has grown beyond Kickstart's single-file layout. Core
  settings live in `lua/config/`, while plugin specifications live in
  `lua/plugins/`. `init.lua` loads the configuration entry point.
