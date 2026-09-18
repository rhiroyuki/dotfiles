#! /usr/bin/env bash

set -euo pipefail

sudo pacman -S --noconfirm --needed base-devel git wget jq
sudo pacman -S --noconfirm \
            --needed \
               man \
               less \
               curl \
               tmux \
               zsh \
               neovim \
               libnotify \
               yad \
               unzip \
               inotify-tools \
               ripgrep \
               fd \
               hyprsunset \
               fzf \
               grim \
               blueman \
               dunst \
               firefox \
               wtype \
               ghostty \
               slurp \
               hyprpaper \
               swaylock \
               swayidle \
               fcitx5 fcitx5-gtk fcitx5-configtool \
               noto-fonts noto-fonts-cjk \
               noto-fonts-emoji noto-fonts-extra \
               ttf-liberation ttf-dejavu ttf-roboto \
               ttf-jetbrains-mono ttf-fira-code \
               ttf-hack adobe-source-code-pro-fonts \
               otf-font-awesome ttf-arimo-nerd noto-fonts \
               wl-clipboard \
               wayland \
               wayland-protocols \
               libinput \
               libdrm \
               libxkbcommon \
               pixman \
               libdisplay-info \
               libliftoff \
               hwdata \
               seatd \
               pcre2 \
               xorg-xwayland \
               keyd \
               libxcb \
               rofi \
               cliphist \
               swappy \
               brightnessctl \
               sway \
               uwsm \
               hyprland \
               hyprlock \
               hypridle \
               xdg-desktop-portal-hyprland \
               xdg-desktop-portal-gtk \
               networkmanager \
               network-manager-applet \
               libayatana-appindicator \
               foot \
               nemo nemo-fileroller file-roller \
               pavucontrol \
               playerctl \
               bluetui \
               impala \
               python-pip \
               python-pipx \
               tree-sitter-cli \
               lm_sensors

if ! command -v yay >/dev/null 2>&1; then
  yay_build_dir=$(mktemp -d)
  trap 'rm -rf "$yay_build_dir"' EXIT
  git clone https://aur.archlinux.org/yay.git "$yay_build_dir/yay"
  (cd "$yay_build_dir/yay" && makepkg -si --noconfirm)
fi

sudo fc-cache -fv

# waybar-git (not extra/waybar): only master fixes hyprland/workspaces clicks
# under a Lua Hyprland config. Switch back once a release carries the fix.
yay -S --noconfirm --needed \
  handy-bin \
  waybar-git \
  wl-gammarelay-rs \
  rofi-emoji-git \
  hyprlauncher \
  hyprpolkitagent \
  ttf-ms-fonts
