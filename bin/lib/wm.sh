#!/usr/bin/env bash
# vim: set ft=sh:
#
# WM adapter registry (ADR 0001, docs/adr/0001-wm-adapter-registry.md).
#
# Single source of truth for "which WM am I in, and what are its verbs?".
# Callers source this file, call wm_detect once, then read fields with
# wm_get instead of hardcoding per-WM paths/commands.
#
# Usage:
#   source "$HOME/dotfiles/bin/lib/wm.sh"
#   wm_detect
#   lock_cmd="$(wm_get lock_cmd)"
#
# Fields (per WM): config_file, bind_grammar, dispatch_cmd, lock_cmd,
# exit_cmd, workspace_module, startup_marker, waybar_config.

# wm_detect - resolve the running WM from $XDG_CURRENT_DESKTOP into WM_ID.
#
# XDG_CURRENT_DESKTOP is matched case-insensitively since compositors are
# inconsistent about casing ("Hyprland" vs "sway" vs "i3"). Falls back to
# WM_ID=unknown (non-fatal) when unset or unrecognised; callers must check
# for that value themselves via wm_get.
wm_detect() {
  local desktop="${XDG_CURRENT_DESKTOP:-}"
  case "${desktop,,}" in
    *hyprland*) WM_ID="hyprland" ;;
    *sway*)     WM_ID="sway" ;;
    *i3*)       WM_ID="i3" ;;
    *)          WM_ID="unknown" ;;
  esac
  export WM_ID
}

# wm_get <field> - print the value of <field> for the detected WM_ID.
#
# Requires wm_detect to have run first. Returns 1 and prints nothing (after
# a stderr warning) for WM_ID=unknown or an unknown field, so callers can
# branch on the exit status instead of getting a fatal error.
wm_get() {
  local field="$1"

  if [[ -z "${WM_ID:-}" ]]; then
    echo "wm_get: WM_ID is unset - call wm_detect first" >&2
    return 1
  fi

  case "$WM_ID:$field" in
    hyprland:config_file)      echo "$HOME/.config/hypr/hyprland.conf" ;;
    hyprland:bind_grammar)     echo 'bind[elm]? = MODS, KEY, DISPATCHER[, ARGS...] (comma-separated; optional "submap = NAME" ... "submap = reset" blocks scope a set of binds)' ;;
    hyprland:dispatch_cmd)     echo "hyprctl dispatch" ;;
    hyprland:lock_cmd)         echo "hyprlock" ;;
    hyprland:exit_cmd)         echo "uwsm stop" ;;
    hyprland:workspace_module) echo "hyprland/workspaces" ;;
    hyprland:startup_marker)   echo "/tmp/waybar_start_ts" ;;
    hyprland:waybar_config)    echo "$HOME/.config/waybar/hyprland.jsonc" ;;

    sway:config_file)      echo "$HOME/.config/sway/config" ;;
    sway:bind_grammar)     echo 'bindsym KEY ACTION... ($mod/$mod2 macro-expanded; optional "mode \"NAME\" { ... }" blocks scope a set of binds)' ;;
    sway:dispatch_cmd)     echo "swaymsg" ;;
    sway:lock_cmd)         echo 'swaylock -f --image $HOME/dotfiles/wallpapers/cloudy.png --effect-blur 7x5' ;;
    sway:exit_cmd)         echo "swaymsg exit" ;;
    sway:workspace_module) echo "sway/workspaces" ;;
    sway:startup_marker)   echo "/tmp/waybar_start_ts" ;;
    sway:waybar_config)    echo "$HOME/.config/waybar/sway.jsonc" ;;

    i3:config_file)      echo "$HOME/.config/i3/config" ;;
    i3:bind_grammar)     echo 'bindsym KEY ACTION... (same grammar as sway; optional "mode \"NAME\" { ... }" blocks scope a set of binds)' ;;
    i3:dispatch_cmd)     echo "i3-msg" ;;
    i3:lock_cmd)         echo 'i3lock --nofork -i $HOME/dotfiles/wallpapers/cloudy.png' ;;
    i3:exit_cmd)         echo "i3-msg exit" ;;
    i3:workspace_module) echo "i3/workspaces (rendered via Polybar, not Waybar - i3 has no launch_waybar)" ;;
    i3:startup_marker)   echo "" ;;
    i3:waybar_config)    echo "" ;;

    unknown:*)
      echo "wm_get: unrecognised WM (XDG_CURRENT_DESKTOP='${XDG_CURRENT_DESKTOP:-}') - no adapter entry" >&2
      return 1
      ;;
    *)
      echo "wm_get: no field '$field' for WM_ID='$WM_ID'" >&2
      return 1
      ;;
  esac
}
