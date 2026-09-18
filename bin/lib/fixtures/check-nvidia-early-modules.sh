#!/usr/bin/env bash
# Exercise the mkinitcpio drop-in installer without root or a real initramfs.
# The main config cases deliberately use different valid MODULES formatting so
# the fixture proves the installer leaves administrator-owned text untouched.
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$here/../../.." && pwd)"
root="$(mktemp -d)"
trap 'rm -rf "$root"' EXIT

mkdir -p "$root/bin" "$root/etc"
printf '%s\n' \
  '#!/usr/bin/env bash' \
  'exec "$@"' > "$root/bin/sudo"
printf '%s\n' \
  '#!/usr/bin/env bash' \
  'printf "%s\\n" "$*" >> "${MKINITCPIO_REBUILD_LOG:?}"' > "$root/bin/mkinitcpio"
chmod +x "$root/bin/sudo" "$root/bin/mkinitcpio"

configs=(
  $'MODULES=(nvidia # inline comment\n  "nvidia_modeset" nvidia_uvm nvidia_drm)\nHOOKS=(base)'
  $'MODULES=(\n  # a comment between entries\n  "nvidia"\n  nvidia_modeset\n  "nvidia_uvm"\n  nvidia_drm\n)\nHOOKS=(base)'
  $'MODULES=("nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm")\nHOOKS=(base)'
)

for index in "${!configs[@]}"; do
  case_root="$root/case-$index"
  mkdir -p "$case_root/etc"
  printf '%s\n' "${configs[index]}" > "$case_root/etc/mkinitcpio.conf"
  cp "$case_root/etc/mkinitcpio.conf" "$case_root/original.conf"
  : > "$case_root/rebuild.log"

  conf="$case_root/etc/mkinitcpio.conf"
  dropin="$case_root/etc/mkinitcpio.conf.d/10-nvidia.conf"
  hook="$case_root/etc/pacman.d/hooks/nvidia-mkinitcpio.hook"
  env \
    PATH="$root/bin:/usr/bin:/bin" \
    MKINITCPIO_CONF_PATH="$conf" \
    MKINITCPIO_DROPIN_TARGET="$dropin" \
    NVIDIA_MKINITCPIO_HOOK_TARGET="$hook" \
    MKINITCPIO_REBUILD_LOG="$case_root/rebuild.log" \
    bash "$repo_root/install/install_nvidia_early_modules.sh" >/dev/null

  cmp -s "$case_root/original.conf" "$conf"
  grep -Fqx 'MODULES+=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)' "$dropin"
  module_dump="$(bash -c 'source "$1"; source "$2"; declare -p MODULES' _ "$conf" "$dropin")"
  for module in nvidia nvidia_modeset nvidia_uvm nvidia_drm; do
    [[ "$module_dump" == *"$module"* ]]
  done
  [[ "$(wc -l < "$case_root/rebuild.log")" -eq 1 ]]

  # A same-content reinstall is a no-op and does not rebuild again.
  env \
    PATH="$root/bin:/usr/bin:/bin" \
    MKINITCPIO_CONF_PATH="$conf" \
    MKINITCPIO_DROPIN_TARGET="$dropin" \
    NVIDIA_MKINITCPIO_HOOK_TARGET="$hook" \
    MKINITCPIO_REBUILD_LOG="$case_root/rebuild.log" \
    bash "$repo_root/install/install_nvidia_early_modules.sh" >/dev/null
  [[ "$(wc -l < "$case_root/rebuild.log")" -eq 1 ]]
done

echo "NVIDIA early-modules check: all OK"
