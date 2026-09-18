#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

state_dir="${XDG_RUNTIME_DIR:-/tmp}"
state_file="$state_dir/waybar_cpu_stat"
stats2=$(awk '/^cpu([0-9]*)[[:space:]]/ {print}' /proc/stat 2>/dev/null)
[[ -z "$stats2" ]] && noop
stats1=""
[[ -r "$state_file" ]] && stats1=$(<"$state_file")
tmp_state="${state_file}.tmp.$$"
printf '%s\n' "$stats2" > "$tmp_state" && mv -f "$tmp_state" "$state_file"
[[ -z "$stats1" ]] && noop

overall=""
sparkline_out=""

while read -r name usage; do
    if [[ "$name" == "cpu" ]]; then
        overall="$usage"
    else
        sparkline_out+="$(sparkline "$usage")"
    fi
done < <(awk '
  NR == FNR { if ($1 ~ /^cpu([0-9]*)$/) { for (i=2;i<=8;i++) old[$1,i]=$i } next }
  $1 ~ /^cpu([0-9]*)$/ {
    total=0; active=0
    for (i=2;i<=8;i++) { d=$i-old[$1,i]; total+=d; if (i != 5 && i != 6) active+=d }
    printf "%s %d\n", $1, total > 0 ? active*100/total : 0
  }
' <(printf '%s\n' "$stats1") <(printf '%s\n' "$stats2"))

top_procs=$(ps -eo pcpu,pid,comm --sort=-pcpu | awk 'NR>=2 && NR<=4 {cpu=$1; pid=$2; $1=""; $2=""; sub(/^[[:space:]]+/, ""); printf "%s (PID %s): %s%%\n", $0, pid, cpu}')

emit "CPU: ${overall}% ${sparkline_out}" "$top_procs"
