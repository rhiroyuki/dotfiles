#!/usr/bin/env bash

blocks=("▁" "▂" "▃" "▄" "▅" "▆" "▇" "█")
HISTORY_FILE="/tmp/waybar_mem_history"
MAX_SAMPLES=10

mem_info=$(</proc/meminfo)
mem_total=$(awk '/^MemTotal:/ {print $2}' <<< "$mem_info")
mem_available=$(awk '/^MemAvailable:/ {print $2}' <<< "$mem_info")
mem_used=$(( mem_total - mem_available ))
mem_used_gib=$(awk "BEGIN {printf \"%.1f\", $mem_used / 1024 / 1024}")
mem_total_gib=$(awk "BEGIN {printf \"%.1f\", $mem_total / 1024 / 1024}")
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

top_proc=$(ps -eo rss,pid,comm --sort=-rss | awk 'NR>=2 && NR<=4 {rss=$1; pid=$2; $1=""; $2=""; sub(/^[[:space:]]+/, ""); printf "%s (PID %s): %.1f MiB\n", $0, pid, rss/1024}')

jq -cn --arg text "Mem: ${mem_used_gib}/${mem_total_gib}GiB ${sparkline}" \
       --arg tooltip "$top_proc" \
       '{"text": $text, "tooltip": $tooltip}'
