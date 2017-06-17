#! /bin/sh

set -euo pipefail

exists() {
  command -v "$1" >/dev/null 2>&1
}

is_distro_manjaro() {
  [ $(lsb_release -is) = "ManjaroLinux" ]
}

zsh_setup() {
  echo "Setting up ZSH"
  if exists zsh; then
    chsh -s $(grep /zsh$ /etc/shells | tail -1)
  else
    echo 'Something went wrong, reinstall ZSH or manually set zsh as your default shell'
    exit 1
  fi
  echo "ZSH done"
}

install_programs() {
  if is_distro_manjaro; then
    echo 'Manjaro detected!'
    echo 'Installing all the needed programs'

    # Asking for permission
    sudo -v

    apps=("zsh" "redshift" "vim" "tmux" "git" "wget" "curl" "yaourt" "ttf-hack" "ttf-inconsolata")
    for app in "${apps[@]}"
    do
      echo "Installing $app"
      if ! exists "$app"; then
      sudo pacman -Syq "$app" --noconfirm
      fi
    done
  else
    echo "Script only for ManjaroLinux, to be implemented for others OS"
    exit 1
  fi
}

dotfiles_setup() {
  echo "Setting up dotfiles"
  # backup files

  # create directory to backup files
  mkdir -p "$(pwd)/backup"

  files=("zshrc" "vimrc" "tmux.conf" "vim")

  for file in "${files[@]}"
  do
    file_origin_path="$(pwd)/${file}"
    file_dest_path="$HOME/.${file}"
    if [ -f $file_dest_path ] || [ -d $file_dest_path ]; then
      mv $file_dest_path "${file_dest_path}.backup"
    fi
    ln -s $file_origin_path $file_dest_path
  done
  mkdir -p ~/.config && [ -d ~/.config ] && [ -f ~/.config/redshift.conf ] && ln -s redshift.conf ~/.config/redshift.conf

  echo "Dotfiles done"
}

vim_plugin_install() {
  echo "Setting up vim plugin"
  mkdir -p ~/.vim/bundle
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  echo "Vim plugin done"
}
tmux_plugin_install() {
  echo "Setting up tmux plugin manager"
  mkdir -p ~/.tmux/plugins
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  ~/.tmux/plugins/tpm/scripts/install_plugins.sh
  echo "Tmux done"
}

install() {
  install_programs
  zsh_setup
  dotfiles_setup
  vim_plugin_install
  tmux_plugin_install
  vim +PluginInstall +qall
  echo "Setup complete. Don't forget to re-log to get ZSH as your default shell"
}

install
