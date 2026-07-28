#!/usr/bin/env bash
# vim: set ft=sh:
#
# Fixture-based check for parse_keybindings() in bin/session-keybindings
# (issue 0009). Exercises the Hyprland `hyprctl binds -j` reader (modmask
# decoding, submaps, display-only dispatch) and the Sway/i3 config grammar
# (modes, plus i3's --no-startup-id stripping) without invoking rofi.
# Run directly; exits non-zero on any mismatch.

set -u
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$here/../../.." && pwd)"

# shellcheck source=/dev/null
SESSION_KEYBINDINGS_SOURCE_ONLY=1 source "$repo_root/bin/session-keybindings"

fail=0

check() {
  local name="$1" actual="$2" expected="$3"
  if [[ "$actual" != "$expected" ]]; then
    echo "FAIL: $name"
    echo "--- expected ---"
    echo "$expected"
    echo "--- actual ---"
    echo "$actual"
    fail=1
  else
    echo "OK: $name"
  fi
}

# --- Hyprland: hyprctl binds -j reader ---
hypr_out="$(parse_keybindings "$here/hyprland-binds.json" hyprland)"

check "hyprland: modmask 64 decodes to SUPER" \
  "$(grep -F 'Launcher' <<< "$hypr_out" | cut -f1 | grep -cE '^SUPER \+ Return')" \
  "1"

check "hyprland: compound modmask 9 decodes to ALT + SHIFT in canonical order" \
  "$(grep -F 'Kill focused window' <<< "$hypr_out" | cut -f1 | grep -cE '^ALT \+ SHIFT \+ Q')" \
  "1"

check "hyprland: compound modmask 76 decodes to SUPER + ALT + CTRL" \
  "$(grep -F 'exec' <<< "$hypr_out" | cut -f1 | grep -cE '^SUPER \+ ALT \+ CTRL \+ X')" \
  "1"

check "hyprland: mouse binds are listed" \
  "$(grep -F 'mouse:272' <<< "$hypr_out" | cut -f1 | grep -cE '^ALT \+ mouse:272')" \
  "1"

check "hyprland: submap-scoped bind display carries [resize] prefix" \
  "$(grep -F 'Grow width' <<< "$hypr_out" | cut -f1 | grep -c '\[resize\]')" \
  "1"

check "hyprland: bind outside a submap is unscoped" \
  "$(grep -F 'Launcher' <<< "$hypr_out" | cut -f1 | grep -c '\[')" \
  "0"

check "hyprland: bind without a description falls back to the dispatcher" \
  "$(grep -cF 'exec' <<< "$hypr_out")" \
  "1"

check "hyprland: keycode-only bind renders as code:N" \
  "$(grep -F 'Bound by keycode' <<< "$hypr_out" | cut -f1 | grep -cE '^SUPER \+ code:28')" \
  "1"

check "hyprland: catch_all bind renders as catchall" \
  "$(grep -F 'Swallow everything else' <<< "$hypr_out" | cut -f1 | grep -c 'catchall')" \
  "1"

check "hyprland: over-long descriptions are truncated with an ellipsis" \
  "$(grep -F 'comfortably longer' <<< "$hypr_out" | cut -f1 | grep -c '\.\.\.$')" \
  "1"

# The dispatch column must be empty for every entry: Hyprland reports Lua binds
# as an opaque registry handle, so the cheatsheet is display-only there.
check "hyprland: dispatch column is empty for all entries" \
  "$(cut -f2 <<< "$hypr_out" | grep -c .)" \
  "0"

# --- Sway: mode scoping, no --no-startup-id stripping ---
sway_out="$(parse_keybindings "$here/sway.config" sway)"

check "sway: mod substitution in display" \
  "$(grep -F 'Return' <<< "$sway_out" | head -1 | cut -f1 | grep -c 'Alt+Return')" \
  "1"

check "sway: mode-scoped bind dispatch is untouched" \
  "$(grep -F 'Right' <<< "$sway_out" | cut -f2)" \
  "resize grow width 10px"

check "sway: mode-scoped bind display carries [resize] prefix" \
  "$(grep -F 'Right' <<< "$sway_out" | cut -f1 | grep -c '\[resize\]')" \
  "1"

check "sway: bind after mode close is unscoped" \
  "$(grep -F 'Super+R' <<< "$sway_out" | cut -f1 | grep -c '\[')" \
  "0"

# --- i3: same grammar as sway, but strips --no-startup-id ---
i3_fixture="$here/sway.config"
i3_out_no_strip="$(parse_keybindings "$i3_fixture" i3)"
check "i3: baseline dispatch (no --no-startup-id in this fixture)" \
  "$(grep -F 'Return' <<< "$i3_out_no_strip" | head -1 | cut -f2)" \
  "exec kitty"

tmp_i3="$(mktemp)"
trap 'rm -f "$tmp_i3"' EXIT
cat > "$tmp_i3" <<'EOF'
bindsym $mod+d exec --no-startup-id rofi -show drun
EOF
i3_out="$(parse_keybindings "$tmp_i3" i3)"
check "i3: --no-startup-id kept in dispatch (i3-msg understands it)" \
  "$(cut -f2 <<< "$i3_out")" \
  "exec --no-startup-id rofi -show drun"

check "i3: --no-startup-id stripped from display" \
  "$(cut -f1 <<< "$i3_out" | grep -c -- '--no-startup-id')" \
  "0"

sway_out_same="$(parse_keybindings "$tmp_i3" sway)"
check "sway: --no-startup-id NOT stripped from display" \
  "$(cut -f1 <<< "$sway_out_same" | grep -c -- '--no-startup-id')" \
  "1"

if [[ "$fail" -ne 0 ]]; then
  echo "keybindings parser check: FAILED"
  exit 1
fi

echo "keybindings parser check: all OK"
