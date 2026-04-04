#!/usr/bin/env bash

blocks=("▁" "▂" "▃" "▄" "▅" "▆" "▇" "█")

read -r total used avail _ <<< "$(df -BG / | awk 'NR==2 {gsub(/G/,"",$2); gsub(/G/,"",$3); gsub(/G/,"",$4); print $2, $3, $4}')"

usage=$(( used * 100 / total ))
idx=$(( usage * 7 / 100 ))
(( idx > 7 )) && idx=7
block="${blocks[$idx]}"

jq -cn --arg text "Disk: ${usage}% ${block}" \
       --arg tooltip "Used: ${used}G / ${total}G (${avail}G free)" \
       '{"text": $text, "tooltip": $tooltip}'
