#! /usr/bin/env bash

set -eu pipefail

install_nvim () {
  source_full_path="$HOME/dotfiles/nvim/*"
  target_full_path="$HOME/.config/nvim/"

  # checking if folder already exists
  if [ -e "$HOME/.config/nvim" ]; then
    mv "$HOME/.config/nvim" "$HOME/.config/nvim_backup_$(date +%s%3N)"
  fi

  mkdir -p "$HOME/.config/nvim"

  # symbolic linking all files
  ln -s "$HOME/dotfiles/nvim/"* "$HOME/.config/nvim/"
}

install_dotfiles () {
  dotfiles=( asdfrc default-gems gemrc tmux.conf zshrc aliases gitignore solargraph.yml reek.yml )

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
  git clone https://github.com/rhiroyuki/dotfiles.git "$HOME/dotfiles"
  install_dotfiles
  install_nvim

  echo "Finished installation"
}

main
