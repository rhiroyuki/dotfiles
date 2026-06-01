#! /usr/bin/env bash

# Loads the NVIDIA kernel modules from the initramfs (early boot) and keeps the
# initramfs in sync with driver/kernel updates via a pacman hook.
# filepath: install/install_nvidia_early_modules.sh
#
# This pulls module insertion into early userspace instead of the normal boot
# transaction, giving a cleaner Wayland/KMS start. Note: this only loads the
# module code -- it does NOT keep the GPU context warm. Use
# install_nvidia_persistenced.sh for that (the actual fix for slow first-launch).
#
# Run on machines with the NVIDIA proprietary driver. Safe to skip elsewhere.

set -euo pipefail

CONF="/etc/mkinitcpio.conf"
HOOK_SOURCE="install/nvidia_mkinitcpio.hook"
HOOK_TARGET="/etc/pacman.d/hooks/nvidia-mkinitcpio.hook"
MODULES="nvidia nvidia_modeset nvidia_uvm nvidia_drm"

if [ ! -f "$HOOK_SOURCE" ]; then
    echo "Run this from the dotfiles repo root ($HOOK_SOURCE not found)." >&2
    exit 1
fi

if grep -qE '^MODULES=.*nvidia' "$CONF"; then
    echo "MODULES already contains nvidia in $CONF; leaving it as is."
else
    # Insert the modules into the MODULES=( ... ) array, preserving any existing
    # entries.
    sudo sed -i -E "s/^MODULES=\((.*)\)/MODULES=($MODULES \1)/" "$CONF"
    # Collapse any double spaces left when the array was empty.
    sudo sed -i -E 's/  +/ /g; s/\( /(/; s/ \)/)/' "$CONF"
    echo "Added NVIDIA modules to MODULES in $CONF."
fi

sudo install -Dm644 "$HOOK_SOURCE" "$HOOK_TARGET"
echo "Installed pacman hook $HOOK_TARGET (rebuilds initramfs on driver/kernel updates)."

sudo mkinitcpio -P

echo "Initramfs rebuilt. NVIDIA modules will load in early boot from next reboot."
