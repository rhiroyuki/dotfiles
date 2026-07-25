#!/usr/bin/env bash
# Shared primitives for waybar custom/*.sh modules. Sourced on every module
# tick, so keep this file cheap to parse and free of subshell-heavy work.

_waybar_blocks=("▁" "▂" "▃" "▄" "▅" "▆" "▇" "█")

# sparkline <percent>
# Echoes a single block glyph for a 0-100 percentage. Out-of-range input is
# clamped instead of indexing past the array (negative) or aborting (>100).
sparkline() {
    local pct=$1 idx
    idx=$(( pct * 7 / 100 ))
    (( idx < 0 )) && idx=0
    (( idx > 7 )) && idx=7
    printf '%s' "${_waybar_blocks[$idx]}"
}

# emit <text> [tooltip] [class]
# Prints a single line of waybar JSON via jq, so text/tooltip are always
# correctly escaped regardless of quotes, backslashes or newlines.
emit() {
    local text=$1 tooltip=${2:-} class=${3:-}
    if [[ -n "$class" ]]; then
        jq -cn --arg text "$text" --arg tooltip "$tooltip" --arg class "$class" \
            '{"text": $text, "tooltip": $tooltip, "class": $class}'
    else
        jq -cn --arg text "$text" --arg tooltip "$tooltip" \
            '{"text": $text, "tooltip": $tooltip}'
    fi
}

# noop
# Emits the degraded/empty payload and exits the module immediately.
noop() {
    printf '%s\n' '{"text": "", "tooltip": ""}'
    exit 0
}

# state_file <name>
# Returns a consistently prefixed /tmp path for a module's scratch state.
state_file() {
    printf '/tmp/waybar_%s' "$1"
}

# state_file_read <name>
# Reads a state file's contents, tolerating a missing or corrupt file by
# printing nothing instead of erroring.
state_file_read() {
    local file
    file=$(state_file "$1")
    [[ -f "$file" ]] && cat "$file" 2>/dev/null
    return 0
}
