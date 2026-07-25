#! /usr/bin/env bash

# Enables the NVIDIA persistence daemon so the driver stays initialized from
# early boot onward.
# filepath: install/install_nvidia_persistenced.sh
#
# Without persistence mode the NVIDIA kernel driver tears down GPU state
# whenever the last GPU client exits. The first client afterwards (e.g. the
# first Firefox launch after boot) then pays the full driver/EGL init cost,
# which on Wayland is several seconds. nvidia-persistenced keeps the driver
# initialized in the background, starting in systemd's early-boot stage --
# long before the login prompt -- so that cold-init cost is paid once at boot.
#
# Run on machines with the NVIDIA proprietary driver. Safe to skip elsewhere.

set -euo pipefail

if systemctl is-enabled --quiet nvidia-persistenced.service 2>/dev/null && \
   systemctl is-active --quiet nvidia-persistenced.service 2>/dev/null; then
  echo "nvidia-persistenced.service already enabled and active; nothing to do."
else
  sudo systemctl enable --now nvidia-persistenced.service
  echo "Enabled nvidia-persistenced.service. Persistence mode is now warm from boot."
fi
