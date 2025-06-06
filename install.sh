#! /usr/bin/env bash

set -eu pipefail

install_dotfiles () {
  dotfiles=( asdfrc default-gems gemrc tmux.conf aliases gitignore solargraph.yml reek.yml gitattributes wezterm.lua XCompose )

  for dotfile in "${dotfiles[@]}";
  do
    ln_file_to_home_directory "$dotfile"
  done
}

install_config () {
  local source_full_path="$HOME/dotfiles/config/$1"
  local target_full_path="$HOME/.config/$1"

  if [ -e "$target_full_path/.dotfile" ]; then
    echo "Removing existing $target_full_path folder"
    rm -rf "$target_full_path"
  elif [ -d "$target_full_path" ]; then
    echo "Backing up existing $target_full_path folder"
    mv "$target_full_path" "$target_full_path"_backup_"$(date +%s%3N)"
  fi

  mkdir -p "$target_full_path"
  touch "$target_full_path"/.dotfile

  ln -s "${source_full_path}"/* "${target_full_path}/"
}

ln_file_to_home_directory () {
  source_full_path="$HOME/dotfiles/$1"
  target_full_path=${2:-"$HOME/.$1"}

  if [ -L "$target_full_path" ]; then
    echo "Removing existing symlink $target_full_path"
    rm "$target_full_path"
  fi

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

add_source_to_zshrc() {
  local zshrc_file="$HOME/.zshrc"
  local source_line="source ~/dotfiles/zshrc_dotfile"

  if ! grep -Fxq "$source_line" "$zshrc_file"; then
    echo "Adding source line to .zshrc"
    echo "$source_line" >> "$zshrc_file"
  else
    echo "Source line already present in .zshrc"
  fi
}

main () {
  if [ ! -d "$HOME/dotfiles" ]; then
    git clone https://github.com/rhiroyuki/dotfiles.git "$HOME/dotfiles"
  fi

  install_dotfiles

  for dir in "$HOME/dotfiles/config"/*; do
    echo "Installing $(basename "$dir")"
    install_config "$(basename "$dir")"
  done
  install_dunst_conf

  add_source_to_zshrc

  echo "Finished installation"
}

main
