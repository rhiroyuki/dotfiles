#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

# Shared with config/sway/bin/brightness; issue 0012 owns unifying this path,
# so it deliberately stays outside lib.sh's state_file prefix.
STATE_FILE="/tmp/hyprsunset_gamma"
STEP=5
MIN=10
MAX=100

current=$(cat "$STATE_FILE" 2>/dev/null)
[[ "$current" =~ ^[0-9]+$ ]] || current=100

case "$1" in
    up)
        new=$(( current + STEP > MAX ? MAX : current + STEP ))
        echo "$new" > "$STATE_FILE"
        hyprctl hyprsunset gamma "$new" &>/dev/null
        ;;
    down)
        new=$(( current - STEP < MIN ? MIN : current - STEP ))
        echo "$new" > "$STATE_FILE"
        hyprctl hyprsunset gamma "$new" &>/dev/null
        ;;
    *)
        percent=$current
        if   (( percent <= 25 )); then icon="󰃚"
        elif (( percent <= 50 )); then icon="󰃛"
        elif (( percent <= 75 )); then icon="󰃜"
        else                           icon="󰃝"
        fi
        echo "${icon} ${percent}%"
        ;;
esac
