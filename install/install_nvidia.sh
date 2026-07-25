#! /usr/bin/env bash

# Orchestrates the opt-in NVIDIA setup steps, in the order they must run:
# modeset pin, then persistence daemon, then early-boot module loading (which
# rebuilds the initramfs last, after any other system changes above).
# filepath: install/install_nvidia.sh
#
# Invoked by install.sh when passed --nvidia. Each step is idempotent and
# detects whether it has already been applied.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/install_nvidia_modeset.sh"
source "$SCRIPT_DIR/install_nvidia_persistenced.sh"
source "$SCRIPT_DIR/install_nvidia_early_modules.sh"

echo "NVIDIA setup complete."
