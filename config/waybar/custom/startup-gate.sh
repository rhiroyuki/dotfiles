#!/usr/bin/env bash
# Startup gate for waybar custom modules.
#
# Suppresses a module's output for the first DELAY seconds of a waybar session,
# then hands off to the real module script. This keeps heavy or hardware-dependent
# scripts (e.g. GPU/sensors querying nvidia-smi before the driver settles) from
# stalling the bar while the session is still coming up.
#
# launch_waybar records the session start time in MARKER once per session, so a
# config-reload restart inside the same session passes through immediately rather
# than re-blanking the bar for another DELAY seconds.
#
# Usage (in config.jsonc):  "exec": "~/.config/waybar/custom/startup-gate.sh gpu.sh"
# Only route return-type:json modules through this; plain-text modules would
# render the literal '{"text": ""}' placeholder.

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

DELAY=15

start=$(state_file_read start_ts)
[[ "$start" =~ ^[0-9]+$ ]] || start=0
now=$(date +%s)

if (( now - start < DELAY )); then
    printf '%s\n' '{"text": ""}'
    exit 0
fi

dir="$(dirname "$0")"
exec "$dir/$1" "${@:2}"
