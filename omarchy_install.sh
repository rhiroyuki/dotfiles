#! /usr/bin/env bash

# Omarchy overwrite installation

set -eu pipefail

source "./install/helper.sh"

install_zshrc() {
  sudo pacman -S zsh tmux

  echo "Run chsh -s \$(which zsh)"
}

# TODO: Adapt current i3 to hyprland shortcuts

main() {
  install_config "nvim"
  install_zshrc
  ln_file_to_home_directory "tmux.conf"
  ln_file_to_home_directory "aliases"
  append_command_to_file "$HOME/.zshrc" "source $HOME/dotfiles/zshrc_dotfile"

  echo "Finished installation"
}

main
