#! /usr/bin/env bash

set -euo pipefail

REPO_URL="https://github.com/rhiroyuki/dotfiles.git"

# Resolve the repo from this script's own location. When the script is piped
# into bash (`bash -c "$(curl ...)"`) there is no source file, so fall back to
# the default clone location.
script_source="${BASH_SOURCE[0]:-}"
if [ -n "$script_source" ] && [ -f "$script_source" ]; then
  DOTFILES_DIR="$(cd "$(dirname "$script_source")" && pwd)"
else
  DOTFILES_DIR="$HOME/dotfiles"
fi

# curl-pipe bootstrap: nothing to source yet, so clone first and re-exec from
# the clone.
if [ ! -f "$DOTFILES_DIR/install/helper.sh" ]; then
  if [ ! -d "$DOTFILES_DIR" ]; then
    git clone "$REPO_URL" "$DOTFILES_DIR"
  fi
  exec bash "$DOTFILES_DIR/install.sh" "$@"
fi

export DOTFILES_DIR

source "$DOTFILES_DIR/install/helper.sh"

install_dotfiles () {
  dotfiles=( default-gems tmux.conf aliases gitignore gitattributes XCompose Xmodmap )

  for dotfile in "${dotfiles[@]}";
  do
    ln_file_to_home_directory "$dotfile"
  done
}

main () {
  install_dotfiles

  for dir in "$DOTFILES_DIR/config"/*; do
    echo "Installing $(basename "$dir")"
    install_config "$(basename "$dir")"
  done

  append_command_to_file "$HOME/.zshrc" "$ZSHRC_SOURCE_LINE"

  source "$DOTFILES_DIR/install/install_keyd_service.sh"

  # Run the remaining Arch-specific steps when on Arch, or when explicitly
  # asked. Everything else Arch used to hand-pick (nvim/sway/rofi configs,
  # tmux.conf, aliases, XCompose, zshrc) is already covered above.
  if [ "${1:-}" = "--arch" ] || [ -f /etc/arch-release ]; then
    source "$DOTFILES_DIR/arch_config_install.sh"
  fi

  echo "Finished installation"
}

main "$@"
