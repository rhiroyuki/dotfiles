#! /usr/bin/env bash

# Configures fcitx5 with the us-intl keyboard layout so that dead keys
# (e.g. apostrophe + c → ç) work in Wayland-native GTK apps like Ghostty.

set -eu

FCITX5_PROFILE="$HOME/.config/fcitx5/profile"
IM_ENV="$HOME/.config/environment.d/im.conf"

setup_im_env() {
  mkdir -p "$(dirname "$IM_ENV")"

  if [ ! -f "$IM_ENV" ]; then
    echo "Creating $IM_ENV"
    cat > "$IM_ENV" <<EOF
XMODIFIERS=@im=fcitx
QT_IM_MODULE=fcitx
EOF
  else
    echo "$IM_ENV already exists, skipping"
  fi
}

setup_fcitx5_profile() {
  mkdir -p "$(dirname "$FCITX5_PROFILE")"

  # Kill fcitx5 before writing — it overwrites its profile on exit
  pkill fcitx5 2>/dev/null || true
  sleep 0.5

  echo "Writing $FCITX5_PROFILE with keyboard-us-intl"
  cat > "$FCITX5_PROFILE" <<EOF
[Groups/0]
# Group Name
Name=Default
# Layout
Default Layout=us-intl
# Default Input Method
DefaultIM=keyboard-us-intl

[Groups/0/Items/0]
# Name
Name=keyboard-us-intl
# Layout
Layout=

[GroupOrder]
0=Default

EOF

  echo "Starting fcitx5"
  fcitx5 -d
}

setup_im_env
setup_fcitx5_profile

echo "fcitx5 us-intl setup complete"
