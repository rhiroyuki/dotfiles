#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

# Display-only: bin/gamma is the single owner of brightness state. Waybar's scroll actions call `bin/gamma nudge
# up|down` directly (see config/waybar/config.jsonc); this module only reads
# the current value via `bin/gamma get`.
percent=$("$HOME/dotfiles/bin/gamma" get)

if   (( percent <= 25 )); then icon="󰃚"
elif (( percent <= 50 )); then icon="󰃛"
elif (( percent <= 75 )); then icon="󰃜"
else                           icon="󰃝"
fi
echo "${icon} ${percent}%"
