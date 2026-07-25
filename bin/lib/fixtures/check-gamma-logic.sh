#!/usr/bin/env bash
# vim: set ft=sh:
#
# Fixture-based check for bin/gamma's pure logic (issue 0011, ADR 0002):
# integer clamping and argument validation, plus the degraded-mode
# decisions when no backend is present. Runs without a real backend --
# clamp/is_int are exercised in-process; the verb/degraded-mode checks
# stub busctl and hyprctl on PATH so no D-Bus/hyprctl call ever happens.
# Run directly; exits non-zero on any mismatch.

set -u
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$here/../../.." && pwd)"

# shellcheck source=/dev/null
GAMMA_SOURCE_ONLY=1 source "$repo_root/bin/gamma"

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

# --- pure logic: clamp / is_int, in-process ---

check "clamp: below MIN clamps to 10" "$(clamp 5)" "10"
check "clamp: above MAX clamps to 100" "$(clamp 150)" "100"
check "clamp: negative clamps to 10" "$(clamp -5)" "10"
check "clamp: in-range passes through" "$(clamp 42)" "42"
check "clamp: MIN boundary is unchanged" "$(clamp 10)" "10"
check "clamp: MAX boundary is unchanged" "$(clamp 100)" "100"

is_int 42 && check "is_int: positive integer" ok ok || check "is_int: positive integer" fail ok
is_int -5 && check "is_int: negative integer" ok ok || check "is_int: negative integer" fail ok
is_int "" && check "is_int: empty string" fail ok || check "is_int: empty string" ok ok
is_int abc && check "is_int: non-numeric" fail ok || check "is_int: non-numeric" ok ok
is_int 5.5 && check "is_int: decimal" fail ok || check "is_int: decimal" ok ok

# --- degraded-mode + argument validation: stub busctl/hyprctl on PATH ---

stub_dir="$(mktemp -d)"
state_file="$(mktemp -u)"
trap 'rm -rf "$stub_dir"; rm -f "$state_file"' EXIT

cat > "$stub_dir/busctl" <<'EOF'
#!/usr/bin/env bash
exit 1
EOF
cat > "$stub_dir/hyprctl" <<'EOF'
#!/usr/bin/env bash
exit 1
EOF
chmod +x "$stub_dir/busctl" "$stub_dir/hyprctl"

gamma() {
  env PATH="$stub_dir:$PATH" GAMMA_STATE_FILE="$state_file" "$repo_root/bin/gamma" "$@"
}

out="$(gamma get)"; code=$?
check "degraded: get prints DEFAULT" "$out" "100"
check "degraded: get exits 0" "$code" "0"

out="$(gamma set 50)"; code=$?
check "degraded: set still succeeds and writes state" "$out" "50"
check "degraded: set exits 0" "$code" "0"
check "degraded: state file was written" "$(cat "$state_file")" "50"

out="$(gamma set abc 2>/dev/null)"; code=$?
check "degraded: set with non-integer exits 1" "$code" "1"

out="$(gamma nudge up)"; code=$?
check "degraded: nudge up from DEFAULT clamps at MAX" "$out" "100"
check "degraded: nudge exits 0" "$code" "0"

out="$(gamma nudge down)"; code=$?
check "degraded: nudge down from DEFAULT" "$out" "95"

out="$(gamma nudge sideways 2>/dev/null)"; code=$?
check "degraded: nudge with bad direction exits 1" "$code" "1"

out="$(gamma temp 4200)"; code=$?
check "degraded: temp prints requested kelvin without applying" "$out" "4200"
check "degraded: temp exits 0" "$code" "0"

out="$(gamma temp abc 2>/dev/null)"; code=$?
check "degraded: temp with non-integer exits 1" "$code" "1"

gamma >/dev/null 2>&1; code=$?
check "no verb exits 2" "$code" "2"

gamma bogus >/dev/null 2>&1; code=$?
check "unrecognised verb exits 2" "$code" "2"

if [[ "$fail" -ne 0 ]]; then
  echo "gamma logic check: FAILED"
  exit 1
fi

echo "gamma logic check: all OK"
