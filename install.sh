#! /usr/bin/env bash

set -eu pipefail

backup_existing_file () {
  source_file="$1"

  if [ -e "$source_file" ]; then
    mv "$source_file" "${source_file}_backup_$(date +%s%3N)"
  fi
}

ln_file_to_home_directory () {
  source_full_path="$HOME/dotfiles/$1"
  target_full_path=${2:-"$HOME/.$1"} # default arg

  backup_existing_file "$target_full_path"

  ln -s "$source_full_path" "$target_full_path"
}

install_nvim () {
  source_full_path="$HOME/dotfiles/nvim/*"
  target_full_path="$HOME/.config/nvim/"

  backup_existing_file "$HOME/.config/nvim"

  mkdir -p "$HOME/.config/nvim"

  ln -s "$HOME/dotfiles/nvim/"* "$HOME/.config/nvim/"
}

install_zshrc() {
  ln_file_to_home_directory 'zshrc_dotfile'

  [ ! -f "$HOME/.zshrc" ] && touch "$HOME/.zshrc"

  # shellcheck disable=SC2016
  literal_text='source $HOME/.zshrc_dotfile'

  grep -qxF "$literal_text" "$HOME/.zshrc" || echo -e "${literal_text}\n$(cat "$HOME/.zshrc")" > "$HOME/.zshrc"
}

install_dotfiles () {
  dotfiles=( asdfrc default-gems gemrc tmux.conf aliases gitignore solargraph.yml reek.yml gitattributes )

  for dotfile in "${dotfiles[@]}";
  do
    ln_file_to_home_directory "$dotfile"
  done
}

main () {
  git clone https://github.com/rhiroyuki/dotfiles.git "$HOME/dotfiles"
  install_zshrc
  install_dotfiles
  install_nvim

  echo "Finished installation"
}

main
