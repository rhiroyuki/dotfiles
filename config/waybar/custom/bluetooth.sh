#!/bin/bash

# Bluetooth status indicator for Waybar with color states

if ls /sys/class/bluetooth/hci* &>/dev/null 2>&1; then
    # Active (green)
    echo '{"text":"󰂯","tooltip":"Bluetooth is active","class":"active"}'
else
    # Inactive (gray)
    echo '{"text":"󰂲","tooltip":"Bluetooth is inactive","class":"inactive"}'
fi
