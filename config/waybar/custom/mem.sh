#!/usr/bin/env bash

blocks=("▁" "▂" "▃" "▄" "▅" "▆" "▇" "█")
HISTORY_FILE="/tmp/waybar_mem_history"
MAX_SAMPLES=60  # 5 min at 5s interval

mem_info=$(</proc/meminfo)
mem_total=$(awk '/^MemTotal:/ {print $2}' <<< "$mem_info")
mem_available=$(awk '/^MemAvailable:/ {print $2}' <<< "$mem_info")
mem_used=$(( mem_total - mem_available ))
mem_used_gib=$(awk "BEGIN {printf \"%.1f\", $mem_used / 1024 / 1024}")
usage=$(( mem_used * 100 / mem_total ))

history=()
if [[ -f "$HISTORY_FILE" ]]; then
    mapfile -t history < "$HISTORY_FILE"
fi
history+=("$usage")

if (( ${#history[@]} > MAX_SAMPLES )); then
    history=("${history[@]: -$MAX_SAMPLES}")
fi

printf '%s\n' "${history[@]}" > "$HISTORY_FILE"

sparkline=""
for val in "${history[@]}"; do
    idx=$(( val * 7 / 100 ))
    (( idx > 7 )) && idx=7
    sparkline+="${blocks[$idx]}"
done

jq -cn --arg text "Mem: ${mem_used_gib}GiB ${sparkline}" '{"text": $text}'
