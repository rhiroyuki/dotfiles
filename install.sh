#! /usr/bin/env bash

set -eu pipefail

install_dotfiles () {
  dotfiles=( asdfrc default-gems gemrc tmux.conf zshrc aliases gitignore solargraph.yml reek.yml gitattributes wezterm.lua XCompose )

  for dotfile in "${dotfiles[@]}";
  do
    ln_file_to_home_directory "$dotfile"
  done
}

install_config () {
  local source_full_path="$HOME/dotfiles/$1"
  local target_full_path="$HOME/.config/$1"

  if [ -e "$target_full_path" ]; then
    echo "Backing up existing $target_full_path folder"
    mv "$target_full_path" "$target_full_path"_backup_"$(date +%s%3N)"
  fi

  mkdir -p "$target_full_path"

  ln -s "${source_full_path}"/* "${target_full_path}/"
}

ln_file_to_home_directory () {
  source_full_path="$HOME/dotfiles/$1"
  target_full_path=${2:-"$HOME/.$1"}

  if [ -e "$target_full_path" ]; then
    echo "backing up $target_full_path"
    mv "$target_full_path" "${target_full_path}_backup_$(date +%s)"
  fi

  ln -s "$source_full_path" "$target_full_path"
}

install_dunst_conf () {
  mkdir -p "$HOME/.config/dunst"
  wget "https://raw.githubusercontent.com/catppuccin/dunst/b0b838d38f134136322ad3df2b6dc57c4ca118cf/src/macchiato.conf" -O ~/.config/dunst/dunstrc
}

main () {
  [ ! -d "$HOME/dotfiles" ] && git clone https://github.com/rhiroyuki/dotfiles.git "$HOME/dotfiles"
  install_dotfiles
  install_config "nvim"
  install_config "i3"
  install_config "i3status"
  install_config "rofi"
  install_config "picom"
  install_dunst_conf

  echo "Finished installation"
}

main
