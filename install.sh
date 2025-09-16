#! /usr/bin/env bash

set -eu pipefail

source ./install/helper.sh

install_dotfiles () {
  dotfiles=( asdfrc default-gems gemrc tmux.conf aliases gitignore solargraph.yml reek.yml gitattributes wezterm.lua XCompose )

  for dotfile in "${dotfiles[@]}";
  do
    ln_file_to_home_directory "$dotfile"
  done
}

install_dunst_conf () {
  mkdir -p "$HOME/.config/dunst"
  wget "https://raw.githubusercontent.com/catppuccin/dunst/b0b838d38f134136322ad3df2b6dc57c4ca118cf/src/macchiato.conf" -O ~/.config/dunst/dunstrc
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
  install_dunst_conf

  add_source_to_zshrc

  install_config "kanata.kbd"
  source ./install/install_kanata_service.sh

  echo "Finished installation"
}

main
