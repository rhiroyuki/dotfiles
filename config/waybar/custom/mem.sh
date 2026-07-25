#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

MAX_SAMPLES=10

[[ -r /proc/meminfo ]] || noop

mem_info=$(</proc/meminfo)
mem_total=$(awk '/^MemTotal:/ {print $2}' <<< "$mem_info")
mem_available=$(awk '/^MemAvailable:/ {print $2}' <<< "$mem_info")
[[ "$mem_total" =~ ^[0-9]+$ && "$mem_available" =~ ^[0-9]+$ && "$mem_total" -gt 0 ]] || noop

mem_used=$(( mem_total - mem_available ))
mem_used_gib=$(awk "BEGIN {printf \"%.1f\", $mem_used / 1024 / 1024}")
mem_total_gib=$(awk "BEGIN {printf \"%.1f\", $mem_total / 1024 / 1024}")
usage=$(( mem_used * 100 / mem_total ))

mapfile -t history < <(state_file_read mem_history | grep -E '^[0-9]+$')
history+=("$usage")

if (( ${#history[@]} > MAX_SAMPLES )); then
    history=("${history[@]: -$MAX_SAMPLES}")
fi

printf '%s\n' "${history[@]}" > "$(state_file mem_history)"

sparkline_out=""
for val in "${history[@]}"; do
    sparkline_out+="$(sparkline "$val")"
done

top_proc=$(ps -eo rss,pid,comm --sort=-rss | awk 'NR>=2 && NR<=4 {rss=$1; pid=$2; $1=""; $2=""; sub(/^[[:space:]]+/, ""); printf "%s (PID %s): %.1f MiB\n", $0, pid, rss/1024}')

emit "Mem: ${mem_used_gib}/${mem_total_gib}GiB ${sparkline_out}" "$top_proc"
