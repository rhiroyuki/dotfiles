#!/usr/bin/env bash

blocks=("▁" "▂" "▃" "▄" "▅" "▆" "▇" "█")

get_stats() {
    grep "^cpu" /proc/stat
}

stats1=$(get_stats)
sleep 1
stats2=$(get_stats)

overall=""
sparkline=""

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
        idx=$((usage * 7 / 100))
        sparkline+="${blocks[$idx]}"
    fi
done <<< "$stats1"

jq -cn --arg text "CPU: ${overall}% ${sparkline}" '{"text": $text}'
