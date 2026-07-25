#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

iface=$(ip route show default 2>/dev/null | awk 'NR==1{print $5}')
[[ -z "$iface" ]] && iface="wlan0"

rx_bytes=$(awk -v iface="${iface}:" '$1==iface {print $2}' /proc/net/dev 2>/dev/null)
tx_bytes=$(awk -v iface="${iface}:" '$1==iface {print $10}' /proc/net/dev 2>/dev/null)
[[ "$rx_bytes" =~ ^[0-9]+$ && "$tx_bytes" =~ ^[0-9]+$ ]] || noop

now=$(date +%s%N)

read -r prev_rx prev_tx prev_time prev_iface < <(state_file_read net_prev)

if [[ "$prev_iface" == "$iface" && "$prev_rx" =~ ^[0-9]+$ && "$prev_tx" =~ ^[0-9]+$ \
      && "$prev_time" =~ ^[0-9]+$ && "$prev_rx" -le "$rx_bytes" && "$prev_tx" -le "$tx_bytes" ]]; then
    elapsed_ns=$(( now - prev_time ))
    rx_mb=$(awk "BEGIN {printf \"%.1f\", ($rx_bytes - $prev_rx) / 1048576 / ($elapsed_ns / 1e9)}")
    tx_mb=$(awk "BEGIN {printf \"%.1f\", ($tx_bytes - $prev_tx) / 1048576 / ($elapsed_ns / 1e9)}")
else
    rx_mb="0.0"
    tx_mb="0.0"
fi

echo "$rx_bytes $tx_bytes $now $iface" > "$(state_file net_prev)"

emit "▼${rx_mb} ▲${tx_mb} MB/s"
