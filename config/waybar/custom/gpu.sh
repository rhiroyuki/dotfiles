#!/usr/bin/env bash

read -r usage mem_used mem_total < <(
    nvidia-smi --query-gpu=utilization.gpu,memory.used,memory.total \
        --format=csv,noheader,nounits | awk -F', ' '{print $1, $2, $3}'
)

top_procs=$(nvidia-smi pmon -c 1 -s m 2>/dev/null \
    | awk 'NR>2 && $3!="No" {print $4, $2, $6}' \
    | sort -rn | head -3 \
    | awk '{printf "%s (PID %s): %s MiB\n", $3, $2, $1}')
[[ -z "$top_procs" ]] && top_procs="No GPU processes"

jq -cn --arg text "GPU: ${usage}% | VRAM: ${mem_used}/${mem_total}MiB" \
       --arg tooltip "$top_procs" \
       '{"text": $text, "tooltip": $tooltip}'
