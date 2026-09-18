#! /usr/bin/env bash

# Installs the keyd configuration and enables its systemd service.
# filepath: install/install_keyd_service.sh

set -euo pipefail

SERVICE_PATH="${KEYD_SERVICE_PATH:-/etc/keyd/default.conf}"
# Resolve from this script's own directory so it works regardless of cwd, both
# when executed directly and when sourced by the installers.
SOURCE_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/keyd_default_conf"

# Compare before changing anything. A same-content reinstall leaves both the
# config and its timestamped backups untouched.
changed=1
if [ -e "$SERVICE_PATH" ] && [ ! -L "$SERVICE_PATH" ] && cmp -s "$SOURCE_PATH" "$SERVICE_PATH"; then
    changed=0
fi

if (( changed )); then
    config_dir="$(dirname "$SERVICE_PATH")"
    sudo install -d -m755 "$config_dir"

    # Build the replacement beside the destination, then atomically rename it
    # into place. The old config remains available while the replacement is
    # prepared, and a copy backup avoids a missing-config window during the
    # swap. Check -L too so a dangling symlink is treated as a change.
    tmp_path="$(sudo mktemp "$config_dir/.default.conf.tmp.XXXXXX")"
    cleanup_tmp() { sudo rm -f "$tmp_path"; }
    trap cleanup_tmp EXIT
    sudo install -m644 "$SOURCE_PATH" "$tmp_path"

    if [ -e "$SERVICE_PATH" ] || [ -L "$SERVICE_PATH" ]; then
        backup_path="${SERVICE_PATH}_backup_$(date +%s)"
        while [ -e "$backup_path" ] || [ -L "$backup_path" ]; do
            backup_path="${SERVICE_PATH}_backup_$(date +%s)_$$"
        done
        sudo cp -a "$SERVICE_PATH" "$backup_path"
    fi
    sudo mv -f "$tmp_path" "$SERVICE_PATH"
    trap - EXIT
fi

# Reload systemd so it picks up the new unit
sudo systemctl daemon-reload

# Enable to start on boot + start immediately
sudo systemctl enable --now keyd

echo "Keyd service installed, enabled, and started."
