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
  install_config "nvim"
  install_config "sway"
  install_config "rofi"
  ln_file_to_home_directory "tmux.conf"
  ln_file_to_home_directory "aliases"

  # fix cedilla for hyprland
  append_command_to_file "$HOME/.XCompose" "include \"%H/dotfiles/XCompose\""

  append_command_to_file "$HOME/.zshrc" "source $HOME/dotfiles/zshrc_dotfile"

  # Auto-start sway on TTY1 login
  append_command_to_file "$HOME/.zprofile" "if [ -z \"\$DISPLAY\" ] && [ \"\$(tty)\" = \"/dev/tty1\" ]; then exec sway --unsupported-gpu; fi"

  # Set Hyprland keyboard variant and options
  set_hypr_kb_variant_intl

  source ./install/install_keyd_service.sh
  source ./install/setup_fcitx5_intl.sh

  # Configure NetworkManager to use iwd as wifi backend and enable it
  sudo mkdir -p /etc/NetworkManager/conf.d
  echo -e "[device]\nwifi.backend=iwd" | sudo tee /etc/NetworkManager/conf.d/iwd.conf > /dev/null
  sudo systemctl enable --now NetworkManager

  echo "Make sure zsh, tmux, keyd are installed and zsh is set as default shell"
  echo "Finished installation"
}

main
