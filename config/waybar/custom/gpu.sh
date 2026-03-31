#!/usr/bin/env bash

# NVIDIA
if command -v nvidia-smi &>/dev/null && nvidia-smi &>/dev/null; then
    read -r usage mem_used mem_total < <(
        nvidia-smi --query-gpu=utilization.gpu,memory.used,memory.total \
            --format=csv,noheader,nounits | awk -F', ' '{print $1, $2, $3}'
    )
    echo "GPU: ${usage}% | VRAM: ${mem_used}/${mem_total}MiB"
    exit 0
fi

# AMD (sysfs)
for card in /sys/class/drm/card*/device; do
    vendor=$(cat "$card/vendor" 2>/dev/null)
    [[ "$vendor" != "0x1002" ]] && continue

    usage=$(cat "$card/gpu_busy_percent" 2>/dev/null)
    mem_used=$(cat "$card/mem_info_vram_used" 2>/dev/null)
    mem_total=$(cat "$card/mem_info_vram_total" 2>/dev/null)

    if [[ -n "$usage" && -n "$mem_used" && -n "$mem_total" ]]; then
        mem_used_mib=$(( mem_used / 1024 / 1024 ))
        mem_total_mib=$(( mem_total / 1024 / 1024 ))
        echo "GPU: ${usage}% | VRAM: ${mem_used_mib}/${mem_total_mib}MiB"
        exit 0
    fi
done

echo "GPU: N/A"
