#!/usr/bin/env bash

STATE_FILE="/tmp/hyprsunset_gamma"
STEP=5
MIN=10
MAX=100

[[ ! -f "$STATE_FILE" ]] && echo "100" > "$STATE_FILE"
current=$(cat "$STATE_FILE")

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
