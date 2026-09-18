: "${DOTFILES_DIR:="$HOME/dotfiles"}"

# Canonical zshrc source line, used identically by every installer.
ZSHRC_SOURCE_LINE="source ~/dotfiles/zshrc_dotfile"

ln_file_to_home_directory () {
  local source_full_path="$DOTFILES_DIR/$1"
  local target_full_path=${2:-"$HOME/.$1"}

  # -e does not match dangling symlinks, so test -L separately.  Backups are
  # always recoverable and avoid silently destroying user configuration.
  if [ -L "$target_full_path" ] || [ -e "$target_full_path" ]; then
    if [ -L "$target_full_path" ] && [ "$(readlink "$target_full_path")" = "$source_full_path" ]; then
      rm "$target_full_path"
    else
      echo "backing up $target_full_path"
      mv "$target_full_path" "${target_full_path}_backup_$(date +%s)"
    fi
  fi

  ln -s "$source_full_path" "$target_full_path"
}

install_config() {
  local source_full_path="$DOTFILES_DIR/config/$1"
  local target_full_path="$HOME/.config/$1"
  local entry target_entry

  if [ -d "$source_full_path" ]; then
    # Source is a directory
    # A file, symlink (including dangling), or non-repo directory must not be
    # replaced in place.  Managed directories are kept so runtime-created
    # files survive reinstalls; only links owned by this source are replaced.
    if [ -L "$target_full_path" ] || { [ -e "$target_full_path" ] && [ ! -d "$target_full_path" ]; }; then
      echo "Backing up existing $target_full_path"
      mv "$target_full_path" "${target_full_path}_backup_$(date +%s)"
    elif [ -e "$target_full_path" ] && [ ! -f "$target_full_path/.dotfile" ]; then
      echo "Backing up existing $target_full_path folder"
      mv "$target_full_path" "${target_full_path}_backup_$(date +%s)"
    fi

    mkdir -p "$target_full_path"
    touch "$target_full_path"/.dotfile

    # dotglob includes hidden config files; nullglob makes an empty source a
    # harmless no-op instead of creating a literal '*' symlink.
    shopt -s nullglob dotglob

    # Remove links previously installed from this app whose source entry was
    # removed. Keep all other entries (including runtime files and unrelated
    # user symlinks) intact. `-L` also catches a source that became dangling.
    for target_entry in "$target_full_path"/*; do
      if [ -L "$target_entry" ]; then
        entry="$(readlink "$target_entry")"
        case "$entry" in
          "$source_full_path"/*)
            source_entry="${entry#"$source_full_path/"}"
            if [ ! -e "$source_full_path/$source_entry" ] && [ ! -L "$source_full_path/$source_entry" ]; then
              echo "Removing stale repo link $target_entry"
              rm "$target_entry"
            fi
            ;;
        esac
      fi
    done

    for entry in "$source_full_path"/*; do
      [[ "$(basename "$entry")" == .dotfile ]] && continue
      target_entry="$target_full_path/$(basename "$entry")"
      if [ -L "$target_entry" ] && [ "$(readlink "$target_entry")" = "$entry" ]; then
        rm "$target_entry"
      elif [ -e "$target_entry" ] || [ -L "$target_entry" ]; then
        echo "Backing up existing $target_entry"
        mv "$target_entry" "${target_entry}_backup_$(date +%s)"
      fi
      ln -s "$entry" "$target_entry"
    done
    shopt -u nullglob dotglob
  elif [ -f "$source_full_path" ]; then
    # Source is a file
    if [ -L "$target_full_path" ]; then
      echo "Removing existing symlink $target_full_path"
      rm "$target_full_path"
    elif [ -e "$target_full_path" ]; then
      echo "Backing up $target_full_path"
      mv "$target_full_path" "${target_full_path}_backup_$(date +%s)"
    fi

    ln -s "$source_full_path" "$target_full_path"
  else
    echo "Source $source_full_path does not exist."
    return 1
  fi
}

append_command_to_file() {
  local input=$2
  local destiny=$1

  [ -e "$destiny" ] || touch "$destiny"

  if ! grep -Fxq "$input" "$destiny"; then
    echo "Adding to ${destiny}"
    echo "$input" >> "$destiny"
  else
    echo "Source line already present in destiny: ${destiny}"
  fi
}
