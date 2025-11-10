#! /bin/bash

set +e

# top bar (start first for faster render)
/bin/bash ~/.config/mango/launch_waybar.sh &

# wallpaper
swaybg -i ~/dotfiles/wallpapers/cloudy.png &

# obs
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots

# notify
# swaync &

# input method
fcitx5 -d &

# speech-to-text
handy &

# keep clipboard content
wl-clip-persist --clipboard regular --reconnect-tries 0 >/dev/null 2>&1  &

# clipboard content manager
wl-paste --type text --watch cliphist store &

wlsunset -T 5700 -t 4500 -g 0.8 -l 48.1 -L 11.6 &
