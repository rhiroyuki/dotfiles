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

install_dunst_conf () {
  install_config "dunst"
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

  # Install general-purpose scripts from bin/ onto ~/.local/bin (user PATH).
  if [[ -d "$DOTFILES_DIR/bin" ]]; then
    mkdir -p "$HOME/.local/bin"
    for script in "$DOTFILES_DIR"/bin/*; do
      [[ -f "$script" ]] || continue
      name="$(basename "$script")"
      target="$HOME/.local/bin/$name"
      # Back up any pre-existing real file (not our symlink) before linking.
      if [[ -e "$target" && ! -L "$target" ]]; then
        mv "$target" "${target}_backup_$(date +%s)"
      fi
      ln -sf "$script" "$target"
      echo "linked ~/.local/bin/${name} -> bin/${name}"
    done
  fi
  install_dunst_conf

  add_source_to_zshrc

  source "$DOTFILES_DIR/install/install_keyd_service.sh"

  echo "Finished installation"
}

main "$@"
