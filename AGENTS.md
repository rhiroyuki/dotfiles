# Agent Instructions

## What this repo is

Personal dotfiles for a Linux development environment. The canonical source of truth lives in `~/dotfiles/`; everything is installed via symlinks into the home directory and `~/.config/`.

## Installation

```bash
# Any distro
bash -c "$(curl -fsSL https://raw.githubusercontent.com/rhiroyuki/dotfiles/master/install.sh)"

# Arch Linux packages (run before install.sh)
bash arch_package_install.sh
bash arch_config_install.sh
```

There are no tests, linters, or build steps for this repo.

## How installation works

`install.sh` calls helpers from `install/helper.sh`:

- **`ln_file_to_home_directory <file>`** — symlinks `~/dotfiles/<file>` → `~/.<file>`. Backs up any existing file with a timestamp suffix before linking.
- **`install_config <appname>`** — creates `~/.config/<appname>/`, drops a `.dotfile` marker there, then symlinks the contents of `config/<appname>/` into it. The `.dotfile` marker indicates the directory is managed by this repo (safe to replace on reinstall).
- **`append_command_to_file`** — idempotent append; checks for exact line before adding.

`zshrc_dotfile` is **not** symlinked — `install.sh` appends `source ~/dotfiles/zshrc_dotfile` to `~/.zshrc` instead.

## Key conventions

### Adding a new dotfile
- Place the file at the repo root (no leading dot).
- Add its name to the `dotfiles=( ... )` array in `install.sh`.
- It will be symlinked as `~/.<filename>`.

### Adding a new `~/.config/` app
- Create `config/<appname>/` with the app's config files.
- `install.sh` automatically iterates `config/*/` and calls `install_config` for each — no manual registration needed.

### Backups
Existing files/dirs are renamed with a Unix-timestamp suffix (`_backup_1234567890`) rather than deleted.

## Configured tools & their files

| Tool | File(s) |
|------|---------|
| Zsh | `zshrc_dotfile`, `aliases` |
| Tmux | `tmux.conf`, `tmux.colorscheme.conf` |
| Neovim | `config/nvim/` |
| Alacritty | `alacritty.toml` (in repo but not in the install symlink list) |
| WezTerm | `wezterm.lua` |
| Ghostty | `config/ghostty/config` |
| Sway (Wayland WM) | `config/sway/` |
| i3 (X11 WM) | `config/i3/` |
| Waybar | `config/waybar/` |
| Git | `gitignore`, `gitattributes` |
| Ruby | `gemrc`, `default-gems`, `reek.yml`, `solargraph.yml` |
| asdf | `asdfrc` |
| keyd | `install/keyd_default_conf`, `install/install_keyd_service.sh` |
| fcitx5 | `install/setup_fcitx5_intl.sh` |

## Zsh

Plugins are bootstrapped at shell startup (no plugin manager like oh-my-zsh):
- **pure** — prompt theme
- **zsh-autosuggestions** — fish-like suggestions
- **zsh-completions** — extra completions
- **git-completion** — enhanced git tab completion

Plugins are cloned to `~/.zsh/` on first run if missing. VI mode is enabled (`bindkey -v`). The shell auto-attaches to a tmux session named `main` on login.

## Neovim

Plugin manager: **lazy.nvim** (auto-installs on first launch).

Structure:
```
config/nvim/
├── init.lua                  # loads config.options, core.lazy, config.keymaps, config.autocmds
├── lua/
│   ├── config/               # options, keymaps, autocmds
│   ├── core/lazy.lua         # lazy.nvim bootstrap
│   └── plugins/              # one file per plugin or plugin group
└── ftplugin/                 # filetype-specific settings (elixir, eruby)
```

Notable plugins: GitHub Copilot, CodeCompanion, Telescope, nvim-lspconfig, blink-cmp, LuaSnip, nvim-treesitter, nvim-tmux-navigator.

The Copilot plugin uses dynamic Node.js path detection to work with asdf-managed Node versions (see `config/nvim/lua/plugins/`).

## Theme

Catppuccin Macchiato is used consistently across Neovim, Alacritty, WezTerm, Sway, and Rofi.
