#! /usr/bin/env bash

# Pins NVIDIA DRM kernel mode setting on for Wayland sessions.
# filepath: install/install_nvidia_modeset.sh
#
# Run on machines with the NVIDIA proprietary driver. Safe to skip elsewhere.
# Takes effect on the next boot (the option is read when nvidia_drm loads in
# early userspace; nvidia is not in the initramfs here, so no rebuild needed).

set -euo pipefail

TARGET="/etc/modprobe.d/nvidia-modeset.conf"
SOURCE="install/nvidia_modeset.conf"

if [ ! -f "$SOURCE" ]; then
    echo "Run this from the dotfiles repo root ($SOURCE not found)." >&2
    exit 1
fi

sudo install -Dm644 "$SOURCE" "$TARGET"

echo "Installed $TARGET. Reboot for nvidia_drm.modeset=1 to take effect."
