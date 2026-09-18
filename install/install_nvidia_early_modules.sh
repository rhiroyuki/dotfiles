#! /usr/bin/env bash

# Loads the NVIDIA kernel modules from the initramfs (early boot) and keeps the
# initramfs in sync with driver/kernel updates via a pacman hook.
# filepath: install/install_nvidia_early_modules.sh
#
# This uses mkinitcpio's supported .conf.d drop-in mechanism instead of
# rewriting /etc/mkinitcpio.conf. The drop-in appends all four NVIDIA modules
# while preserving the administrator's existing MODULES array and formatting.
# It pulls module insertion into early userspace for a cleaner Wayland/KMS
# start. Note: this only loads the module code -- it does NOT keep the GPU
# context warm. Use install_nvidia_persistenced.sh for that.
#
# Run on machines with the NVIDIA proprietary driver. Safe to skip elsewhere.

set -euo pipefail

# Resolve from this script's own directory so it works regardless of cwd, both
# when executed directly and when sourced by install.sh.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

CONF="${MKINITCPIO_CONF_PATH:-/etc/mkinitcpio.conf}"
DROPIN_DIR="${MKINITCPIO_CONF_DIR:-${CONF}.d}"
DROPIN_TARGET="${MKINITCPIO_DROPIN_TARGET:-$DROPIN_DIR/10-nvidia.conf}"
HOOK_SOURCE="$SCRIPT_DIR/nvidia_mkinitcpio.hook"
HOOK_TARGET="${NVIDIA_MKINITCPIO_HOOK_TARGET:-/etc/pacman.d/hooks/nvidia-mkinitcpio.hook}"
DROPIN_SOURCE="$SCRIPT_DIR/nvidia_modules.conf"

changed=false

if [[ -f "$DROPIN_TARGET" && ! -L "$DROPIN_TARGET" ]] && cmp -s "$DROPIN_SOURCE" "$DROPIN_TARGET"; then
    echo "$DROPIN_TARGET already matches; leaving $CONF unchanged."
else
    sudo install -d -m755 "$DROPIN_DIR"

    # Stage beside the destination, then atomically rename the complete file.
    # A pre-existing file (including a dangling symlink) is retained before it
    # is replaced, matching the installers' timestamped-backup convention.
    tmp_path="$(sudo mktemp "$DROPIN_DIR/.10-nvidia.conf.tmp.XXXXXX")"
    cleanup_tmp() { sudo rm -f "$tmp_path"; }
    trap cleanup_tmp EXIT
    sudo install -m644 "$DROPIN_SOURCE" "$tmp_path"

    if [[ -e "$DROPIN_TARGET" || -L "$DROPIN_TARGET" ]]; then
        backup_path="${DROPIN_TARGET}_backup_$(date +%s)"
        while [[ -e "$backup_path" || -L "$backup_path" ]]; do
            backup_path="${DROPIN_TARGET}_backup_$(date +%s)_$$"
        done
        sudo cp -a "$DROPIN_TARGET" "$backup_path"
    fi
    sudo mv -f "$tmp_path" "$DROPIN_TARGET"
    trap - EXIT
    changed=true
    echo "Installed NVIDIA mkinitcpio drop-in $DROPIN_TARGET."
fi

if [ -f "$HOOK_TARGET" ] && cmp -s "$HOOK_SOURCE" "$HOOK_TARGET"; then
    echo "$HOOK_TARGET already matches; nothing to do."
else
    sudo install -Dm644 "$HOOK_SOURCE" "$HOOK_TARGET"
    echo "Installed pacman hook $HOOK_TARGET (rebuilds initramfs on driver/kernel updates)."
    changed=true
fi

if [ "$changed" = true ]; then
    sudo mkinitcpio -P
    echo "Initramfs rebuilt. NVIDIA modules will load in early boot from next reboot."
else
    echo "NVIDIA early modules already configured; skipping initramfs rebuild."
fi
