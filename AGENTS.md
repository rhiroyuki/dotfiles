# Agent Instructions

## What this repo is

Personal dotfiles for a Linux development environment. The canonical source of truth lives in `~/dotfiles/`; everything is installed via symlinks into the home directory and `~/.config/`.

## Installation

```bash
# Any distro
bash -c "$(curl -fsSL https://raw.githubusercontent.com/rhiroyuki/dotfiles/master/install.sh)"

# Arch Linux packages (run before install.sh — installs pacman/yay packages,
# not config)
bash arch_package_install.sh
```

`install.sh` is the single entry point for configuration. On Arch (detected via
`/etc/arch-release`) or when passed `--arch`, it also sources
`arch_config_install.sh` for the handful of steps that are genuinely
Arch-specific (fcitx5, NetworkManager/iwd, tty1 auto-sway, Hyprland keyboard
variant) — everything else (nvim/sway/rofi configs, tmux.conf, aliases,
XCompose, zshrc) is handled once by `install.sh`'s own `config/*` loop and
`dotfiles` array, so both code paths install the same set of files.
`arch_config_install.sh` can still be run standalone if only the Arch-specific
steps are needed.

There are no tests, linters, or build steps for this repo.

## How installation works

`install.sh` calls helpers from `install/helper.sh`:

- **`ln_file_to_home_directory <file>`** — symlinks `~/dotfiles/<file>` → `~/.<file>`. Backs up any existing file with a timestamp suffix before linking.
- **`install_config <appname>`** — creates `~/.config/<appname>/`, drops a `.dotfile` marker there, then symlinks the contents of `config/<appname>/` into it. The `.dotfile` marker indicates the directory is managed by this repo (safe to replace on reinstall).
- **`append_command_to_file`** — idempotent append; checks for exact line before adding.

Both `install.sh` and `arch_config_install.sh` run under `set -euo pipefail` and
resolve every repo-internal path from `$DOTFILES_DIR`, which is derived from the
script's own location — so they can be run from any working directory. When
`install.sh` is piped into bash (the `curl` bootstrap above) there is no script
file to resolve from, so it clones the repo to `~/dotfiles` and re-execs itself
from the clone. `$DOTFILES_DIR` is exported for the sourced `install/*` scripts;
`install/helper.sh` defaults it to `~/dotfiles` when sourced standalone.

`zshrc_dotfile` is **not** symlinked — every installer appends the canonical
`source ~/dotfiles/zshrc_dotfile` line (`$ZSHRC_SOURCE_LINE` in `install/helper.sh`)
to `~/.zshrc` via `append_command_to_file`, instead.

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
| Sway (Wayland WM) | `config/sway/` (helpers under `bin/`: `keybindings`, `launch_waybar`, `select_display_mode`/`apply_display_modes`; `brightness` + `temperature-schedule` drive software gamma — see "Brightness on Sway" below; app launcher and power menu are the shared `bin/session-launcher` and `bin/session-powermenu`, see "WM adapter registry" below) |
| i3 (X11 WM) | `config/i3/` (helpers: `bin/keybindings`, `bin/polybar`; app launcher and power menu are the shared `bin/session-launcher` and `bin/session-powermenu`, see "WM adapter registry" below) |
| Waybar | `config/waybar/` (custom modules: `lib.sh` (shared `sparkline`/`emit`/`noop`/`state_file` primitives), `cpu.sh`, `gpu.sh`, `mem.sh`, `disk.sh`, `temp.sh`, `net.sh`, `brightness.sh`, `bluetooth.sh`; `custom/power` opens the session menu via the shared `bin/session-powermenu` (lock/suspend/reboot/shutdown/log out); `custom/keybindings` opens the Hyprland keybindings cheatsheet via `config/hypr/bin/keybindings` (also bound to `ALT SHIFT, slash`); `startup-gate.sh` blanks JSON modules for the first 15s of a session so heavy scripts don't stall the bar). Launched by `config/hypr/bin/launch_waybar`, which supervises the bar (reload on config change, relaunch on crash with capped backoff, and a render health check that polls `hyprctl layers` for waybar's layer surface to restart a hung-but-alive bar that never drew at first load) |
| Polybar (X11 status bar) | `config/polybar/` (calendar popup script under `polybar-scripts/`) |
| Git | `gitignore`, `gitattributes` |
| Ruby | `gemrc`, `default-gems`, `reek.yml`, `solargraph.yml` |
| asdf | `asdfrc` |
| keyd | `install/keyd_default_conf`, `install/install_keyd_service.sh` |
| fcitx5 | `install/setup_fcitx5_intl.sh` |
| NVIDIA (Wayland) | `install/nvidia_modeset.conf`, `install/install_nvidia_modeset.sh` (pins `nvidia_drm.modeset=1`); `install/install_nvidia_persistenced.sh` (keeps driver warm from boot — fixes slow first GPU launch); `install/install_nvidia_early_modules.sh`, `install/nvidia_mkinitcpio.hook` (load modules in initramfs) |
| fontconfig | `config/fontconfig/fonts.conf` |
| WM adapter registry | `bin/lib/wm.sh` (`wm_detect`/`wm_get`; see "WM adapter registry" below); decision recorded in `docs/adr/0001-wm-adapter-registry.md` |
| App launcher | `bin/session-launcher` (rofi with dmenu fallback; unifies the formerly byte-identical `config/{hypr,sway,i3}/bin/launcher`). Each WM config invokes it via `$HOME/dotfiles/bin/session-launcher` directly — top-level `bin/` is not symlinked anywhere by `install.sh`, so callers reference the canonical repo path, same as `bin/lib/wm.sh` |

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

Treesitter uses the plugins' `main` branches, installs the Ruby parser, enables
highlighting for available parsers, and provides text-object selection and
navigation keymaps from `config/nvim/lua/plugins/nvim-treesitter.lua`. Vim's
legacy syntax highlighting is disabled so Treesitter owns highlighting.

## NVIDIA (Wayland)

On the NVIDIA-driven Wayland box, `install.sh --nvidia` runs the three
NVIDIA-specific setup steps via `install/install_nvidia.sh`, in order. This is
opt-in (not auto-detected) because it is hardware-specific and needs root; run
it explicitly on machines with the NVIDIA proprietary driver
(`bash install.sh --nvidia`, combinable with `--arch`). Each step is
idempotent and detects when it has already been applied, so re-running
`--nvidia` is always safe.

1. `install/install_nvidia_modeset.sh` drops `install/nvidia_modeset.conf` to
   `/etc/modprobe.d/nvidia-modeset.conf` to pin `nvidia_drm.modeset=1`. Takes
   effect on the next boot.
2. `install/install_nvidia_persistenced.sh` enables
   `nvidia-persistenced.service`. Without persistence mode the driver
   de-initializes when the last GPU client exits, so the first client after
   boot (e.g. the first Firefox launch) pays a multi-second cold-init cost on
   Wayland. The daemon keeps the driver warm from systemd early boot. This is
   the fix for "first app to use the GPU is slow".
3. `install/install_nvidia_early_modules.sh` adds the NVIDIA modules to
   `MODULES=(...)` in `/etc/mkinitcpio.conf`, installs a pacman hook
   (`install/nvidia_mkinitcpio.hook` → `/etc/pacman.d/hooks/`) that rebuilds
   the initramfs on driver/kernel updates, and runs `mkinitcpio -P` (only when
   something changed). This loads the modules in early boot for a cleaner
   KMS/Wayland start; it does **not** keep the GPU warm (that's the
   persistence daemon above). Runs last since it rebuilds the initramfs after
   any other system changes above.

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

**Pending unification:** `config/sway/bin/brightness` and
`config/waybar/custom/brightness.sh` are two independent implementations with
different units (0-1 float vs percent) and step sizes (`0.05`/`0.10` vs
`5`/`10`) that happen to share `/tmp/hyprsunset_gamma` as state. The contract
for a single `bin/gamma` module that owns both (percent 0-100, step 5, min
10, state file unchanged, verbs `get`/`set`/`nudge`/`temp`, degraded mode
falls back to 100%, backend selected by direct probe rather than through
`bin/lib/wm.sh`) is decided in `docs/adr/0002-gamma-contract.md`. The module
itself and the caller rewiring described above are not yet built — see
issues 0011 and 0012.

## Hyprland input.conf (Omarchy-owned)

`arch_config_install.sh`'s `set_hypr_kb_variant_intl` sed-patches
`~/.config/hypr/input.conf` to set `kb_variant = intl`. This file is **not**
owned by this repo — it's generated/managed by Omarchy, so it lives outside
`config/hypr/` and is never symlinked. The script only edits it in place (and
only if it already exists), matching a single `kb_variant =` line so Omarchy
updates to the rest of the file are undisturbed. If Omarchy ever changes that
line's format, this patch silently no-ops (guarded by the `[ -f "$input_conf" ]`
check) rather than corrupting the file.

## WM adapter registry

`bin/lib/wm.sh` is the single source of truth for "which WM am I in, and
what are its verbs?" — see `docs/adr/0001-wm-adapter-registry.md` for the
full decision writeup. Callers `source` it, call `wm_detect` (resolves
`$XDG_CURRENT_DESKTOP`, matched case-insensitively, into `WM_ID`), then read
fields with `wm_get <field>` instead of hardcoding per-WM paths/commands.
Covers hyprland, sway, and i3 with: `config_file`, `bind_grammar`,
`dispatch_cmd`, `lock_cmd`, `exit_cmd`, `workspace_module`,
`startup_marker`. An unset/unrecognised `XDG_CURRENT_DESKTOP` resolves to
`WM_ID=unknown`, which is non-fatal — `wm_get` warns on stderr and returns 1
rather than erroring out.

`config/hypr/bin/powermenu` was the first caller (a tracer proving the seam
works end-to-end); it read `lock_cmd`/`exit_cmd` from the table and used
bash (`#!/usr/bin/env bash`), not `#!/bin/sh`, because `wm.sh` uses bash-only
syntax. It has since been unified into `bin/session-powermenu` (issue 0008),
alongside `bin/session-launcher` (issue 0007), which reads the same table.
The remaining keybindings/launch_waybar duplicates across
`config/{hypr,sway,i3}/` are intentionally not yet unified onto this
table — that is future work (issues 0009, 0016).

## Architecture Decision Records

Decisions with lasting design consequences (detection mechanisms, seam
placement, supported-target calls) are recorded under `docs/adr/` as
numbered ADRs (`NNNN-title.md`). See `docs/adr/0001-wm-adapter-registry.md`
for the format.

## Theme

Catppuccin Macchiato is used consistently across Neovim, Alacritty, WezTerm, Sway, and Rofi.
