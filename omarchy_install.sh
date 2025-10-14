#! /usr/bin/env bash

# Omarchy overwrite installation

set -eu pipefail

source ./install/helper.sh

set_hypr_kb_variant_intl() {
  local input_conf="$HOME/.config/hypr/input.conf"
  if [ -f "$input_conf" ]; then
    # Only replace if not already set to intl
    grep -q '^  kb_variant = intl$' "$input_conf" || \
      sed -i '/^  kb_variant =/c\  kb_variant = intl' "$input_conf"
  fi
}

main() {
  # Remove unwanted applications (only those actually installed)
  sudo pacman -Rns --noconfirm obsidian obs-studio kdenlive 1password-beta 1password-cli typora xournalpp || true

  # Hyprland keybinds and unbinds
  append_command_to_file "$HOME/.config/hypr/hyprland.conf" "bind = SUPER, h, movefocus, l"
  append_command_to_file "$HOME/.config/hypr/hyprland.conf" "bind = SUPER, j, movefocus, d"
  append_command_to_file "$HOME/.config/hypr/hyprland.conf" "bind = SUPER, k, movefocus, u"
  append_command_to_file "$HOME/.config/hypr/hyprland.conf" "bind = SUPER, l, movefocus, r"
  append_command_to_file "$HOME/.config/hypr/hyprland.conf" "unbind = SUPER, K"
  append_command_to_file "$HOME/.config/hypr/hyprland.conf" "bindd = SUPER SHIFT, K, Show key bindings, exec, omarchy-menu-keybindings"
  append_command_to_file "$HOME/.config/hypr/hyprland.conf" "unbind = SUPER, J"

  install_config "nvim"
  ln_file_to_home_directory "tmux.conf"
  ln_file_to_home_directory "aliases"

  # fix cedilla for hyprland
  append_command_to_file "$HOME/.XCompose" "include \"%H/dotfiles/XCompose\""

  append_command_to_file "$HOME/.zshrc" "source $HOME/dotfiles/zshrc_dotfile"

  # Set Hyprland keyboard variant and options
  set_hypr_kb_variant_intl

  install_config "kanata.kbd"
  source ./install/install_kanata_service.sh

  echo "Make sure zsh, tmux, kanata are installed and zsh is set as default shell"
  echo "Finished installation"
}

main
