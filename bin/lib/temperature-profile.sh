#!/usr/bin/env bash
# vim: set ft=sh:
#
# Single source of the day/night colour-temperature schedule (issue 0013).
# Canonical values are Hyprland's: commit
# 0049973 ("raise night temperature to 4200K") is evidence the Hyprland
# schedule is current intent, while the Sway script had drifted to 3300K at
# night under a comment falsely claiming it mirrored this table.
#
# Each entry is "hour:kelvin:gamma:label". hour is the local hour (0-23) at
# which the entry takes effect; the schedule wraps around midnight, so the
# last entry of the day stays in effect until the first entry of the next
# day. gamma is hyprsunset's per-profile dimming multiplier (1.0 = no extra
# dimming beyond temperature); Sway's backend (wl-gammarelay-rs, via
# bin/gamma) has no equivalent knob, so Sway callers ignore this field.
#
# Consumers:
#   - config/sway/bin/temperature-schedule sources this file and applies
#     profile_temp_for_hour's result via `bin/gamma temp`, the single owner
#     of colour temperature.
#   - config/hypr/hyprsunset.conf is generated from this table by
#     bin/lib/generate-hyprsunset-conf.sh. hyprsunset is a daemon that reads
#     its conf once at startup (not a script), so this repo regenerates the
#     conf file on disk rather than having the daemon consult this table
#     live -- run the generator manually after editing TEMPERATURE_PROFILE,
#     the same way you'd re-run any other codegen step in this repo.
#
# The hour used for lookups is injectable for testing: PROFILE_HOUR
# overrides `date +%-H` (see profile_current_hour).

TEMPERATURE_PROFILE=(
  "6:6500:1.0:Morning/startup — no filter until work begins"
  "9:5100:1.0:Work hours — mild filter for bright room"
  "17:4200:1.0:After work — gradual warmth as ambient light drops"
  "20:4200:0.85:Night — strong filter for wind-down"
)

# profile_current_hour - the hour to schedule for: PROFILE_HOUR if set
# (testing), else the real local hour.
profile_current_hour() {
  if [[ -n "${PROFILE_HOUR:-}" ]]; then
    echo "$PROFILE_HOUR"
  else
    date +%-H
  fi
}

# profile_field_for_hour <hour> <field> - walks TEMPERATURE_PROFILE in
# order and returns <field> (hour|kelvin|gamma|label) of the last entry
# whose hour is <= <hour>; wraps to the schedule's last entry if <hour> is
# before the first entry of the day (e.g. 2am uses last night's 20:00
# entry).
profile_field_for_hour() {
  local hour="$1" field="$2"
  local entry ehour ekelvin egamma elabel result=""

  for entry in "${TEMPERATURE_PROFILE[@]}"; do
    IFS=: read -r ehour ekelvin egamma elabel <<< "$entry"
    if (( hour >= ehour )); then
      result="$(profile_pick_field "$field" "$ehour" "$ekelvin" "$egamma" "$elabel")"
    fi
  done

  if [[ -z "$result" ]]; then
    entry="${TEMPERATURE_PROFILE[-1]}"
    IFS=: read -r ehour ekelvin egamma elabel <<< "$entry"
    result="$(profile_pick_field "$field" "$ehour" "$ekelvin" "$egamma" "$elabel")"
  fi

  echo "$result"
}

profile_pick_field() {
  case "$1" in
    hour)   echo "$2" ;;
    kelvin) echo "$3" ;;
    gamma)  echo "$4" ;;
    label)  echo "$5" ;;
  esac
}

profile_temp_for_hour()  { profile_field_for_hour "$1" kelvin; }
profile_gamma_for_hour() { profile_field_for_hour "$1" gamma; }
profile_label_for_hour() { profile_field_for_hour "$1" label; }
