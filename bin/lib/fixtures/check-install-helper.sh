#!/usr/bin/env bash
# Exercise installer backup and directory ownership behavior in a temp HOME.
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$here/../../.." && pwd)"
root="$(mktemp -d)"
trap 'rm -rf "$root"' EXIT

mkdir -p "$root/source/config/demo" "$root/home/.config"
printf '%s\n' visible > "$root/source/config/demo/settings"
printf '%s\n' hidden > "$root/source/config/demo/.hidden"
printf '%s\n' 'user file' > "$root/home/.config/demo"

export HOME="$root/home" DOTFILES_DIR="$root/source"
source "$repo_root/install/helper.sh"
install_config demo

[[ -L "$HOME/.config/demo/settings" ]]
[[ -L "$HOME/.config/demo/.hidden" ]]
compgen -G "$HOME/.config/demo_backup_*" >/dev/null

printf '%s\n' runtime > "$HOME/.config/demo/runtime"
ln -s "$root/source/config/demo/removed" "$HOME/.config/demo/removed"
install_config demo
[[ -f "$HOME/.config/demo/runtime" ]]
[[ -L "$HOME/.config/demo/settings" ]]
[[ ! -e "$HOME/.config/demo/removed" && ! -L "$HOME/.config/demo/removed" ]]

mkdir -p "$root/source/config/empty"
install_config empty
[[ ! -e "$HOME/.config/empty/*" ]]

ln -s "$root/missing" "$HOME/.config/dangling"
printf '%s\n' target > "$root/source/target"
ln_file_to_home_directory target "$HOME/.config/dangling"
[[ -L "$HOME/.config/dangling" ]]
[[ -e "$HOME/.config/dangling_backup_*" ]] || compgen -G "$HOME/.config/dangling_backup_*" >/dev/null

echo "install helper check: all OK"
