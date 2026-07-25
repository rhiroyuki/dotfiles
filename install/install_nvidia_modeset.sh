#! /usr/bin/env bash

# Pins NVIDIA DRM kernel mode setting on for Wayland sessions.
# filepath: install/install_nvidia_modeset.sh
#
# Run on machines with the NVIDIA proprietary driver. Safe to skip elsewhere.
# Takes effect on the next boot (the option is read when nvidia_drm loads in
# early userspace; nvidia is not in the initramfs here, so no rebuild needed).

set -euo pipefail

TARGET="/etc/modprobe.d/nvidia-modeset.conf"
# Resolve from this script's own directory so it works regardless of cwd, both
# when executed directly and when sourced by install.sh.
SOURCE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/nvidia_modeset.conf"

if [ -f "$TARGET" ] && cmp -s "$SOURCE" "$TARGET"; then
  echo "$TARGET already matches; nothing to do."
else
  sudo install -Dm644 "$SOURCE" "$TARGET"
  echo "Installed $TARGET. Reboot for nvidia_drm.modeset=1 to take effect."
fi
