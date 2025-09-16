#! /usr/bin/env bash

# creates a systemd service and timer to run kanata at startup
# filepath: install/install-kanata-service.sh

SERVICE_PATH="/etc/systemd/system/kanata.service"
SOURCE_PATH="install/kanata.service"

# Remove existing file or symlink if present
if [ -e "$SERVICE_PATH" ]; then
    sudo rm "$SERVICE_PATH"
fi
# Create symbolic link to the service file
sudo ln -s "$(realpath "$SOURCE_PATH")" "$SERVICE_PATH"

sudo systemctl daemon-reload
sudo systemctl enable kanata.service
sudo systemctl start kanata.service

echo "Kanata service installed, enabled, and started."
