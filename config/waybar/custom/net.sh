#!/usr/bin/env bash

PREV_FILE="/tmp/waybar_net_prev"

iface=$(ip route show default 2>/dev/null | awk 'NR==1{print $5}')
[[ -z "$iface" ]] && iface="wlan0"

rx_bytes=$(awk -v iface="${iface}:" '$1==iface {print $2}' /proc/net/dev)
tx_bytes=$(awk -v iface="${iface}:" '$1==iface {print $10}' /proc/net/dev)
now=$(date +%s%N)

if [[ -f "$PREV_FILE" ]]; then
    read -r prev_rx prev_tx prev_time prev_iface < "$PREV_FILE"
    if [[ "$prev_iface" == "$iface" && "$prev_rx" -le "$rx_bytes" && "$prev_tx" -le "$tx_bytes" ]]; then
        elapsed_ns=$(( now - prev_time ))
        rx_mb=$(awk "BEGIN {printf \"%.1f\", ($rx_bytes - $prev_rx) / 1048576 / ($elapsed_ns / 1e9)}")
        tx_mb=$(awk "BEGIN {printf \"%.1f\", ($tx_bytes - $prev_tx) / 1048576 / ($elapsed_ns / 1e9)}")
    else
        rx_mb="0.0"
        tx_mb="0.0"
    fi
else
    rx_mb="0.0"
    tx_mb="0.0"
fi

echo "$rx_bytes $tx_bytes $now $iface" > "$PREV_FILE"

jq -cn --arg text "▼${rx_mb} ▲${tx_mb} MB/s" '{"text": $text}'
