#!/usr/bin/env bash
# vim: set ft=sh:
#
# Fixture-based check for bin/lib/temperature-profile.sh (issue 0013,
# docs/adr/0002-gamma-contract.md): every boundary hour, including the
# midnight wrap, resolves to the canonical Hyprland values, and both
# consumers (config/sway/bin/temperature-schedule and the generated
# config/hypr/hyprsunset.conf) agree for the same hour. Runs without a real
# backend -- PROFILE_HOUR forces the hour, GAMMA_STATE_FILE and a stubbed
# busctl/hyprctl keep bin/gamma from touching the live session. Run
# directly; exits non-zero on any mismatch.

set -u
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$here/../../.." && pwd)"

# shellcheck source=../temperature-profile.sh
source "$repo_root/bin/lib/temperature-profile.sh"

fail=0

check() {
  local name="$1" actual="$2" expected="$3"
  if [[ "$actual" != "$expected" ]]; then
    echo "FAIL: $name (expected '$expected', got '$actual')"
    fail=1
  else
    echo "OK: $name"
  fi
}

# --- profile_temp_for_hour / profile_gamma_for_hour at every boundary ---

check "hour 6 (boundary)"  "$(profile_temp_for_hour 6)"  "6500"
check "hour 8 (before 9)"  "$(profile_temp_for_hour 8)"  "6500"
check "hour 9 (boundary)"  "$(profile_temp_for_hour 9)"  "5100"
check "hour 16 (before 17)" "$(profile_temp_for_hour 16)" "5100"
check "hour 17 (boundary)" "$(profile_temp_for_hour 17)" "4200"
check "hour 19 (before 20)" "$(profile_temp_for_hour 19)" "4200"
check "hour 20 (boundary)" "$(profile_temp_for_hour 20)" "4200"
check "hour 23 (late night)" "$(profile_temp_for_hour 23)" "4200"
check "hour 0 (midnight wrap)" "$(profile_temp_for_hour 0)" "4200"
check "hour 5 (before morning)" "$(profile_temp_for_hour 5)" "4200"

check "gamma at hour 17 (day)" "$(profile_gamma_for_hour 17)" "1.0"
check "gamma at hour 20 (night)" "$(profile_gamma_for_hour 20)" "0.85"
check "gamma at hour 2 (midnight wrap)" "$(profile_gamma_for_hour 2)" "0.85"

# --- both consumers agree for the same (forced) hour ---

stub_dir="$(mktemp -d)"
state_file="$(mktemp -u)"
trap 'rm -rf "$stub_dir"; rm -f "$state_file"' EXIT

cat > "$stub_dir/busctl" <<'EOF'
#!/usr/bin/env bash
exit 1
EOF
cat > "$stub_dir/hyprctl" <<'EOF'
#!/usr/bin/env bash
[[ "$*" == "hyprsunset gamma" ]] && exit 0
echo "$@" >> "$HYPRCTL_LOG"
exit 0
EOF
chmod +x "$stub_dir/busctl" "$stub_dir/hyprctl"

hyprctl_log="$(mktemp -u)"
: > "$hyprctl_log"

# Sway's script, forced to hour 20, via a stubbed backend.
PATH="$stub_dir:$PATH" GAMMA_STATE_FILE="$state_file" PROFILE_HOUR=20 \
  HYPRCTL_LOG="$hyprctl_log" \
  bash "$repo_root/config/sway/bin/temperature-schedule" >/dev/null

applied="$(awk '{print $3}' "$hyprctl_log" | tail -n1)"
check "sway schedule at hour 20 applies profile temp via bin/gamma" "$applied" "4200"

# Generated hyprsunset.conf must carry the same 20:00 value.
hypr_temp="$(awk '/time = 20:00/{f=1} f && /temperature/{print $3; exit}' \
  "$repo_root/config/hypr/hyprsunset.conf")"
check "hyprsunset.conf 20:00 matches profile table" "$hypr_temp" "4200"

if [[ "$fail" -ne 0 ]]; then
  echo "temperature profile check: FAILED"
  exit 1
fi

echo "temperature profile check: all OK"
