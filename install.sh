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
    sudo chsh -s $(grep /zsh$ /etc/shells | tail -1)
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

    apps=("zsh" "redshift" "vim" "tmux" "git" "wget" "curl" "yaourt" "termite"
    "nodejs" "npm" "ttf-hack" "ttf-inconsolata")
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
    ([ -f ~/."$file" ] ||
     [ -d ~/."$file" ]) &&
     mv ~/."$file" $(pwd)/backup/."$file".old &&
     ln -s "$file" ~/."$file"
  done
  [ -d ~/.config ] && [ -f ~/.config/redshift.conf ] && mv ~/.config/redshift.conf ~/.config/redshift.conf.old
  [ -d ~/.config/termite ] && [ -f ~/.config/termite/config ] && mv ~/.config/termite/config ~/.config/temite/config.old

  mkdir -p ~/.config/termite
  ln -s termite_config ~/.config/termite/config
  ln -s redshift.conf ~/.config/redshift.conf

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
