#! /usr/bin/env bash

# creates a systemd service and timer to run keyd at startup
# filepath: install/install_keyd_service.sh

SERVICE_PATH="/etc/keyd/default.conf"
# Resolve from this script's own directory so it works regardless of cwd, both
# when executed directly and when sourced by the installers.
SOURCE_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/keyd_default_conf"

# Remove existing file or symlink if present
if [ -e "$SERVICE_PATH" ]; then
    sudo rm "$SERVICE_PATH"
fi
sudo cp "$SOURCE_PATH" "$SERVICE_PATH"

# Reload systemd so it picks up the new unit
sudo systemctl daemon-reload

# Enable to start on boot + start immediately
sudo systemctl enable --now keyd

echo "Keyd service installed, enabled, and started."
