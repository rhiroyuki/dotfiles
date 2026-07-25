#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

command -v df >/dev/null 2>&1 || noop

read -r total used avail _ <<< "$(df -BG / 2>/dev/null | awk 'NR==2 {gsub(/G/,"",$2); gsub(/G/,"",$3); gsub(/G/,"",$4); print $2, $3, $4}')"
[[ "$total" =~ ^[0-9]+$ && "$total" -gt 0 && "$used" =~ ^[0-9]+$ ]] || noop

usage=$(( used * 100 / total ))
block="$(sparkline "$usage")"

emit "Disk: ${usage}% ${block}" "Used: ${used}G / ${total}G (${avail}G free)"
