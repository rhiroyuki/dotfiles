#! /bin/sh

sudo pacman -S --noconfirm --needed base-devel git wget
sudo pacman -S --noconfirm \
               man \
               less \
               tmux \
               zsh \
               inotify-tools \
               ripgrep \
               wlsunset \
               fzf \
               flameshot \
               blueman \
               firefox \
               wtype \
               ghostty \
               swaybg \
               swaylock \
               swayidle \
               fcitx5 fcitx5-gtk fcitx5-configtool \
               noto-fonts noto-fonts-cjk \
               noto-fonts-emoji noto-fonts-extra \
               ttf-liberation ttf-dejavu ttf-roboto \
               ttf-jetbrains-mono ttf-fira-code \
               ttf-hack adobe-source-code-pro-fonts \
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
               libxcb

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

sudo fc-cache -fv

yay -S --noconfirm \
  mangowc-git \
  handy-bin

