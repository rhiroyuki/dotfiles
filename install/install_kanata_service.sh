#! /usr/bin/env bash

# creates a systemd service and timer to run kanata at startup
# filepath: install/install-kanata-service.sh

SERVICE_PATH="/etc/systemd/system/kanata.service"
SOURCE_PATH="install/kanata.service"

# Remove existing file or symlink if present
if [ -e "$SERVICE_PATH" ]; then
    sudo rm "$SERVICE_PATH"
fi
sudo cp "$SOURCE_PATH" "$SERVICE_PATH"

# Reload systemd so it picks up the new unit
sudo systemctl daemon-reload

# Enable to start on boot + start immediately
sudo systemctl enable --now kanata.service

echo "Kanata service installed, enabled, and started."
