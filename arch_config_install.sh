#! /usr/bin/env bash

# Arch-specific configuration steps that go beyond the shared config/* loop
# in install.sh. Invoked automatically by install.sh on Arch Linux (or via
# --arch), and can still be run standalone.

set -euo pipefail

script_source="${BASH_SOURCE[0]}"
DOTFILES_DIR="$(cd "$(dirname "$script_source")" && pwd)"
export DOTFILES_DIR

source "$DOTFILES_DIR/install/helper.sh"

# NOTE: ~/.config/hypr/input.conf is not owned by this repo — it belongs to
# Omarchy. See AGENTS.md's "Hyprland input.conf (Omarchy-owned)" section.
set_hypr_kb_variant_intl() {
  local input_conf="$HOME/.config/hypr/input.conf"
  if [ -f "$input_conf" ]; then
    # Only replace if not already set to intl
    grep -q '^  kb_variant = intl$' "$input_conf" || \
      sed -i '/^  kb_variant =/c\  kb_variant = intl' "$input_conf"
  fi
}

main() {
  # Auto-start sway on TTY1 login
  append_command_to_file "$HOME/.zprofile" "if [ -z \"\$DISPLAY\" ] && [ \"\$(tty)\" = \"/dev/tty1\" ]; then exec sway --unsupported-gpu; fi"

  # Set Hyprland keyboard variant and options
  set_hypr_kb_variant_intl

  source "$DOTFILES_DIR/install/setup_fcitx5_intl.sh"

  # Configure NetworkManager to use iwd as wifi backend and enable it
  sudo mkdir -p /etc/NetworkManager/conf.d
  echo -e "[device]\nwifi.backend=iwd" | sudo tee /etc/NetworkManager/conf.d/iwd.conf > /dev/null
  sudo systemctl enable --now NetworkManager

  echo "Arch-specific configuration complete"
}

main
