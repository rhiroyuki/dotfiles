#! /bin/sh

sudo pacman -S --noconfirm --needed base-devel git wget jq
sudo pacman -S --noconfirm \
            --needed \
               man \
               less \
               tmux \
               zsh \
               inotify-tools \
               ripgrep \
               wlsunset \
               fzf \
               grim \
               blueman \
               dunst \
               firefox \
               wtype \
               ghostty \
               slurp \
               swaybg \
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
               waybar \
               brightnessctl \
               sway \
               networkmanager \
               network-manager-applet \
               libayatana-appindicator \
               foot \
               nemo \
               pavucontrol \
               playerctl \
               bluetui \
               impala

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

sudo fc-cache -fv

yay -S --noconfirm --needed \
  handy-bin \
  rofi-emoji-git

