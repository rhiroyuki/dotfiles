#! /usr/bin/env bash

set -euo pipefail

install_nvim () {
  source_full_path="$HOME/dotfiles/nvim/init.vim"
  target_full_path="$HOME/.config/nvim/init.vim"

  # create directory if doesnt exists
  mkdir -p "$HOME/.config/nvim"

  # checking if file exists to move it if necessary
  if [ -e "$target_full_path" ]; then
    mv "$target_full_path" "${target_full_path}_backup_$(date +%s%3N)"
  fi

  # symbolic linking file
  ln -s "$source_full_path" "$target_full_path"
}

install_dotfiles () {
  dotfiles=( asdfrc default-gems gemrc tmux.conf zshrc aliases )

  for dotfile in "${dotfiles[@]}";
  do
    ln_file_to_home_directory "$dotfile"
  done
}

ln_file_to_home_directory () {
  source_full_path="$HOME/dotfiles/$1"
  target_full_path=${2:-"$HOME/.$1"}

  # checking if file exists to move it if necessary
  if [ -e "$target_full_path" ]; then
    mv "$target_full_path" "${target_full_path}_backup_$(date +%s)"
  fi

  # symbolic linking file
  ln -s "$source_full_path" "$target_full_path"
}

main () {
  original_location=$PWD

  git clone https://github.com/rhiroyuki/dotfiles.git "$HOME/dotfiles"
  install_dotfiles
  install_nvim

  cd "$original_location"
  echo "Finished installation"
}

main
