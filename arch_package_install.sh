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
               nemo \
               pavucontrol \
               playerctl \
               bluetui \
               impala \
               python-pip \
               python-pipx \
               tree-sitter-cli \
               lm_sensors

if ! command -v yay >/dev/null 2>&1; then
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si
  cd ..
fi

sudo fc-cache -fv

yay -S --noconfirm --needed \
  waybar-git \
  handy-bin \
  rofi-emoji-git \
  hyprlauncher \
  hyprpolkitagent \
  ttf-ms-fonts

