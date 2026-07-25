#!/usr/bin/env bash

# Bluetooth status indicator for Waybar with color states

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

if ls /sys/class/bluetooth/hci* &>/dev/null 2>&1; then
    # Active (green)
    emit "󰂯" "Bluetooth is active" "active"
else
    # Inactive (gray)
    emit "󰂲" "Bluetooth is inactive" "inactive"
fi
