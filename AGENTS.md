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

## Package and modification tracking

Whenever a package installation or system modification is requested:

- **Arch Linux packages** — add the package to the appropriate section in `arch_package_install.sh` (pacman) or `arch_config_install.sh` (AUR/config steps).
- **New dotfile or config** — follow the conventions below and update the "Configured tools & their files" table.
- **Install-time setup** (services, symlinks, one-time commands) — add a script under `install/` and wire it into `install.sh` or document it in this file so the setup is reproducible.
- **If a change cannot be scripted** (e.g. manual GUI step, hardware-specific tweak) — document it explicitly in this file under the relevant tool section.
- **Behaviour change to an existing script or config** — whenever you add, change, or remove behaviour (not just files), update the relevant tool section and "Configured tools & their files" row so this doc always reflects current behaviour.

The goal is that a fresh install from this repo reproduces the full environment without any undocumented manual steps.

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
| hyprsunset | `config/hypr/hyprsunset.conf` |
| Sway (Wayland WM) | `config/sway/` (helpers under `bin/`: `launcher`, `powermenu`, `keybindings`, `launch_waybar`, `select_display_mode`/`apply_display_modes`; `brightness` + `temperature-schedule` drive software gamma — see "Brightness on Sway" below) |
| i3 (X11 WM) | `config/i3/` (helpers: `bin/launcher`, `bin/powermenu`, `bin/keybindings`, `bin/polybar`) |
| Waybar | `config/waybar/` (custom modules: `cpu.sh`, `gpu.sh`, `mem.sh`, `disk.sh`, `temp.sh`, `net.sh`, `brightness.sh`, `bluetooth.sh`; `custom/power` opens the session menu via `config/hypr/bin/powermenu` (lock/suspend/reboot/shutdown/log out); `custom/keybindings` opens the Hyprland keybindings cheatsheet via `config/hypr/bin/keybindings` (also bound to `ALT SHIFT, slash`); `startup-gate.sh` blanks JSON modules for the first 15s of a session so heavy scripts don't stall the bar). Launched by `config/hypr/bin/launch_waybar`, which supervises the bar (reload on config change, relaunch on crash with capped backoff, and a render health check that polls `hyprctl layers` for waybar's layer surface to restart a hung-but-alive bar that never drew at first load) |
| Polybar (X11 status bar) | `config/polybar/` (calendar popup script under `polybar-scripts/`) |
| Git | `gitignore`, `gitattributes` |
| Ruby | `gemrc`, `default-gems`, `reek.yml`, `solargraph.yml` |
| asdf | `asdfrc` |
| keyd | `install/keyd_default_conf`, `install/install_keyd_service.sh` |
| fcitx5 | `install/setup_fcitx5_intl.sh` |
| NVIDIA (Wayland) | `install/nvidia_modeset.conf`, `install/install_nvidia_modeset.sh` (pins `nvidia_drm.modeset=1`); `install/install_nvidia_persistenced.sh` (keeps driver warm from boot — fixes slow first GPU launch); `install/install_nvidia_early_modules.sh`, `install/nvidia_mkinitcpio.hook` (load modules in initramfs) |
| fontconfig | `config/fontconfig/fonts.conf` |

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

## NVIDIA (Wayland)

On the NVIDIA-driven Wayland box, `install/install_nvidia_modeset.sh` drops
`install/nvidia_modeset.conf` to `/etc/modprobe.d/nvidia-modeset.conf` to pin
`nvidia_drm.modeset=1`. It is **run manually** (`sudo bash install/install_nvidia_modeset.sh`),
not wired into `install.sh`, because it is hardware-specific and needs root.
Takes effect on the next boot.

`install/install_nvidia_persistenced.sh` enables `nvidia-persistenced.service`.
Without persistence mode the driver de-initializes when the last GPU client
exits, so the first client after boot (e.g. the first Firefox launch) pays a
multi-second cold-init cost on Wayland. The daemon keeps the driver warm from
systemd early boot. This is the fix for "first app to use the GPU is slow".

`install/install_nvidia_early_modules.sh` adds the NVIDIA modules to
`MODULES=(...)` in `/etc/mkinitcpio.conf`, installs a pacman hook
(`install/nvidia_mkinitcpio.hook` → `/etc/pacman.d/hooks/`) that rebuilds the
initramfs on driver/kernel updates, and runs `mkinitcpio -P`. This loads the
modules in early boot for a cleaner KMS/Wayland start; it does **not** keep the
GPU warm (that's the persistence daemon above). Optional.

All three are **run manually** (`sudo bash install/<script>.sh`), not wired into
`install.sh`, because they are hardware-specific and need root.

## Brightness on Sway

This box drives an external monitor and has **no `/sys/class/backlight` device**,
so `brightnessctl` cannot change brightness. Sway therefore dims in software via
**`wl-gammarelay-rs`** (AUR, in the `yay` block of `arch_package_install.sh`),
which holds the `wlr-gamma-control` and exposes `Brightness`/`Temperature` over
D-Bus (`busctl`).

- `config/sway/bin/brightness {up,down}` nudges the `Brightness` property and
  echoes the new percent (used by the `XF86MonBrightness*` keybindings). It also
  writes the percent to `/tmp/hyprsunset_gamma` so Waybar's `custom/brightness.sh`
  display module stays correct.
- `config/sway/bin/temperature-schedule --daemon` is launched from the Sway
  config and applies a day/night color temperature by the hour, mirroring the
  profiles in `config/hypr/hyprsunset.conf` (wl-gammarelay-rs holds a fixed
  temperature and does not transition on its own; this replaces the old
  `wlsunset` scheduling).

Only one `wlr-gamma-control` client may run at a time, so `wl-gammarelay-rs`
**replaces** `wlsunset`. On Hyprland the equivalent job is done by `hyprsunset`
(`config/waybar/custom/brightness.sh` → `hyprctl hyprsunset gamma`); hyprsunset
uses Hyprland's `hyprland-ctm-control-v1` protocol and does **not** work under
Sway, which is why Sway needs its own tool.

## Theme

Catppuccin Macchiato is used consistently across Neovim, Alacritty, WezTerm, Sway, and Rofi.
