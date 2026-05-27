#!/usr/bin/env bash

noop() { printf '%s\n' '{"text": "", "tooltip": ""}'; exit 0; }

command -v nvidia-smi >/dev/null 2>&1 || noop
command -v jq         >/dev/null 2>&1 || noop

read -r usage mem_used mem_total < <(
    nvidia-smi --query-gpu=utilization.gpu,memory.used,memory.total \
        --format=csv,noheader,nounits 2>/dev/null | awk -F', ' '{print $1, $2, $3}'
)
[[ -z "$usage" ]] && noop

# pmon -s m: gpu pid type fb(MB) ccpm command
top_vram=$(nvidia-smi pmon -c 1 -s m 2>/dev/null \
    | awk 'NR>2 && $2~/^[0-9]/ {print $4, $2, $6}' \
    | sort -rn | head -3 \
    | awk '{printf "%s (PID %s): %s MB\n", $3, $2, $1}')
[[ -z "$top_vram" ]] && top_vram="No GPU processes"

# pmon -s u: gpu pid type sm mem enc dec jpg ofa command
top_gpu=$(nvidia-smi pmon -c 1 -s u 2>/dev/null \
    | awk 'NR>2 && $2~/^[0-9]/ {val=($4=="-"?0:$4); print val, $2, $10}' \
    | sort -rn | head -3 \
    | awk '{printf "%s (PID %s): %s%%\n", $3, $2, $1}')
[[ -z "$top_gpu" ]] && top_gpu="No GPU processes"

tooltip="$(printf "Top VRAM:\n%s\n\nTop GPU:\n%s" "$top_vram" "$top_gpu")"

jq -cn --arg text "GPU: ${usage}% | VRAM: ${mem_used}/${mem_total}MiB" \
       --arg tooltip "$tooltip" \
       '{"text": $text, "tooltip": $tooltip}'
