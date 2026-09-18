#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

command -v nvidia-smi >/dev/null 2>&1 || noop

read -r usage mem_used mem_total < <(
    timeout -k 1 2 nvidia-smi --query-gpu=utilization.gpu,memory.used,memory.total \
        --format=csv,noheader,nounits 2>/dev/null | awk -F', ' '{print $1, $2, $3}'
)
[[ -z "$usage" ]] && noop

# Process accounting is much more expensive than the summary query above.
# Cache tooltip data briefly while keeping the visible summary responsive.
cache_dir="${XDG_RUNTIME_DIR:-/tmp}/waybar-gpu"
mkdir -p "$cache_dir"
now=$(date +%s)
cache_ts=0
[[ -r "$cache_dir/ts" ]] && cache_ts=$(<"$cache_dir/ts")
if [[ ! "$cache_ts" =~ ^[0-9]+$ || $(( now - cache_ts )) -ge 10 || ! -s "$cache_dir/vram" || ! -s "$cache_dir/util" ]]; then
    top_vram=$(timeout -k 1 2 nvidia-smi pmon -c 1 -s m 2>/dev/null \
        | awk 'NR>2 && $2~/^[0-9]/ {print $4, $2, $6}' \
        | sort -rn | head -3 \
        | awk '{printf "%s (PID %s): %s MB\n", $3, $2, $1}')
    top_gpu=$(timeout -k 1 2 nvidia-smi pmon -c 1 -s u 2>/dev/null \
        | awk 'NR>2 && $2~/^[0-9]/ {val=($4=="-"?0:$4); print val, $2, $10}' \
        | sort -rn | head -3 \
        | awk '{printf "%s (PID %s): %s%%\n", $3, $2, $1}')
    [[ -z "$top_vram" ]] && top_vram="No GPU processes"
    [[ -z "$top_gpu" ]] && top_gpu="No GPU processes"
    printf '%s\n' "$top_vram" > "$cache_dir/vram.tmp.$$" && mv -f "$cache_dir/vram.tmp.$$" "$cache_dir/vram"
    printf '%s\n' "$top_gpu" > "$cache_dir/util.tmp.$$" && mv -f "$cache_dir/util.tmp.$$" "$cache_dir/util"
    printf '%s\n' "$now" > "$cache_dir/ts.tmp.$$" && mv -f "$cache_dir/ts.tmp.$$" "$cache_dir/ts"
else
    top_vram=$(<"$cache_dir/vram")
    top_gpu=$(<"$cache_dir/util")
fi

tooltip="$(printf "Top VRAM:\n%s\n\nTop GPU:\n%s" "$top_vram" "$top_gpu")"

emit "GPU: ${usage}% | VRAM: ${mem_used}/${mem_total}MiB" "$tooltip"
