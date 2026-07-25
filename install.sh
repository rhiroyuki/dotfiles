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

add_source_to_zshrc() {
  local zshrc_file="$HOME/.zshrc"
  local source_line="source ~/dotfiles/zshrc_dotfile"

  if ! grep -Fxq "$source_line" "$zshrc_file"; then
    echo "Adding source line to .zshrc"
    echo "$source_line" >> "$zshrc_file"
  else
    echo "Source line already present in .zshrc"
  fi
}

main () {
  install_dotfiles

  for dir in "$DOTFILES_DIR/config"/*; do
    echo "Installing $(basename "$dir")"
    install_config "$(basename "$dir")"
  done

  add_source_to_zshrc

  source "$DOTFILES_DIR/install/install_keyd_service.sh"

  echo "Finished installation"
}

main "$@"
