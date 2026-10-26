# System dependencies

Install these through your OS package manager or the relevant language toolchain.
The configuration does not install system packages.

## Core tools and runtimes

| Dependency | Used for |
| :--- | :--- |
| Neovim 0.12 or newer | Native `vim.pack` and editor APIs. |
| Git | Plugin downloads and Git features. |
| C compiler (Clang or GCC) and `make` | Native plugin extensions and Tree-sitter parsers. |
| `curl`, `tar`, and `unzip` | Downloading and extracting plugins, parsers, and Mason tools. |
| Node.js and npm | Mason's npm packages, TypeScript tools, and Copilot. |
| Python 3 with pip and venv | Mason's Python packages and Python tooling. |
| Go | Mason's Go packages and Go tooling, including `gofmt`. |
| Java | Running the SonarLint language server. |
| `ripgrep` (`rg`), `fd`, and `fzf` | File search and configured pickers. |
| A Nerd Font selected in your terminal | Icons; set `vim.g.have_nerd_font` in `lua/config/init.lua` to match. |
| A platform clipboard provider | System clipboard integration; macOS provides `pbcopy`/`pbpaste`, while Linux may need `wl-clipboard`, `xclip`, or `xsel`. |

## Dependencies for specific features

| Dependency | Used for |
| :--- | :--- |
| `lazygit` | LazyGit keymaps. |
| GitHub CLI (`gh`), authenticated | GitHub notifications, dashboard pull requests, and repository browsing. |
| Rust/Cargo and `rustfmt` | Building Rust projects and formatting Rust buffers. |
| Terraform CLI | Terraform validation and formatting. |
| Fish, including `fish_indent` | Formatting Fish scripts. |
| `uv` | Python debugging. |
| `jupyter_client` and a Jupyter kernel in the notebook's selected Python environment | Notebook execution; check with `:checkhealth ipynb`. |
| An AI CLI, such as `codex` | Sidekick CLI sessions; `tmux` is optional for persistent sessions. |

Python formatting normally uses Mason's Ruff. `black` and `isort` are optional
fallbacks when Ruff is unavailable.

## Managed by the configuration

- `vim.pack` installs plugins at the revisions in `nvim-pack-lock.json`.
- Mason installs the packages selected in `lua/config/tools.lua`, including
  `tree-sitter-cli`. Inspect them with `:Mason` or retry with `:MasonToolsInstall`.
- `nvim-treesitter` builds and installs parsers using that CLI and your C compiler.
  On first setup, let Mason finish and restart Neovim before opening notebooks.

The former `language_servers.sh` has been retired. Use this list for system
dependencies and `lua/config/tools.lua` for Mason-managed tools.
