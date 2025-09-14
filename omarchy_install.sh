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

# append_ctrl_as_esc_to_kb_options() {
#   local input_conf="$HOME/.config/hypr/input.conf"
#   if [ -f "$input_conf" ]; then
#     grep -q 'ctrl:esc' "$input_conf" || \
#       sed -i '/^  kb_options =/ s/$/,ctrl:esc/' "$input_conf"
#   fi
# }

main() {
  install_config "nvim"
  ln_file_to_home_directory "tmux.conf"
  ln_file_to_home_directory "aliases"

  # fix cedilla for hyprland
  append_command_to_file "$HOME/.XCompose" "include \"%H/dotfiles/XCompose\""

  append_command_to_file "$HOME/.zshrc" "source $HOME/dotfiles/zshrc_dotfile"

  # Set Hyprland keyboard variant and options
  set_hypr_kb_variant_intl
  # append_ctrl_as_esc_to_kb_options

  echo "Make sure zsh and tmux are installed and set as default shell"
  echo "Finished installation"
}

main
