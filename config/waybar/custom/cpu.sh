#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

get_stats() {
    grep "^cpu" /proc/stat 2>/dev/null
}

stats1=$(get_stats)
[[ -z "$stats1" ]] && noop

sleep 1
stats2=$(get_stats)
[[ -z "$stats2" ]] && noop

overall=""
sparkline_out=""

while read -r line; do
    name=$(awk '{print $1}' <<< "$line")
    line2=$(grep "^${name} " <<< "$stats2")

    read -ra s1 <<< "$line"
    read -ra s2 <<< "$line2"

    user=$((s2[1] - s1[1]))
    nice=$((s2[2] - s1[2]))
    system=$((s2[3] - s1[3]))
    idle=$((s2[4] - s1[4]))
    iowait=$((s2[5] - s1[5]))
    irq=$((s2[6] - s1[6]))
    softirq=$((s2[7] - s1[7]))

    total=$((user + nice + system + idle + iowait + irq + softirq))
    active=$((total - idle - iowait))

    if [[ $total -eq 0 ]]; then
        usage=0
    else
        usage=$((active * 100 / total))
    fi

    if [[ "$name" == "cpu" ]]; then
        overall="$usage"
    else
        sparkline_out+="$(sparkline "$usage")"
    fi
done <<< "$stats1"

top_procs=$(ps -eo pcpu,pid,comm --sort=-pcpu | awk 'NR>=2 && NR<=4 {cpu=$1; pid=$2; $1=""; $2=""; sub(/^[[:space:]]+/, ""); printf "%s (PID %s): %s%%\n", $0, pid, cpu}')

emit "CPU: ${overall}% ${sparkline_out}" "$top_procs"
