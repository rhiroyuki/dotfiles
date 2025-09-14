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

install_config() {
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

append_command_to_file() {
  local input=$2
  local destiny=$1

  if ! grep -Fxq "$input" "$destiny"; then
    echo "Adding to ${destiny}"
    echo "$input" >> "$destiny"
  else
    echo "Source line already present in destiny: ${destiny}"
  fi
}
