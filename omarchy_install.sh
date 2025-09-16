#! /usr/bin/env bash

# Omarchy overwrite installation

set -eu pipefail

source "./install/helper.sh"

set_hypr_kb_variant_intl() {
  local input_conf="$HOME/.config/hypr/input.conf"
  if [ -f "$input_conf" ]; then
    # Only replace if not already set to intl
    grep -q '^  kb_variant = intl$' "$input_conf" || \
      sed -i '/^  kb_variant =/c\  kb_variant = intl' "$input_conf"
  fi
}

main() {
  install_config "nvim"
  ln_file_to_home_directory "tmux.conf"
  ln_file_to_home_directory "aliases"

  # fix cedilla for hyprland
  append_command_to_file "$HOME/.XCompose" "include \"%H/dotfiles/XCompose\""

  append_command_to_file "$HOME/.zshrc" "source $HOME/dotfiles/zshrc_dotfile"

  # Set Hyprland keyboard variant and options
  set_hypr_kb_variant_intl

  install_config "kanata.kbd"

  echo "Make sure zsh, tmux, kanata are installed and zsh is set as default shell"
  echo "Finished installation"
}

main
