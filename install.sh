#! /usr/bin/env bash

set -eu pipefail

source ./install/helper.sh

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
  if [ ! -d "$HOME/dotfiles" ]; then
    git clone https://github.com/rhiroyuki/dotfiles.git "$HOME/dotfiles"
  fi

  install_dotfiles

  for dir in "$HOME/dotfiles/config"/*; do
    echo "Installing $(basename "$dir")"
    install_config "$(basename "$dir")"
  done

  # Install general-purpose scripts from bin/ onto ~/.local/bin (user PATH).
  if [[ -d "$HOME/dotfiles/bin" ]]; then
    mkdir -p "$HOME/.local/bin"
    for script in "$HOME/dotfiles"/bin/*; do
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

  source ./install/install_keyd_service.sh

  echo "Finished installation"
}

main
