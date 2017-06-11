#! /bin/sh

set -euo pipefail

exists()
{
  command -v "$1" >/dev/null 2>&1
}

redshift_install() {
  if ! exists redshift; then
    yes | sudo pacman -Syq redshift
  fi
}

zsh_install() {
  echo "Installing and setting up ZSH shell"
  if ! exists zsh; then
    sudo pacman -Syq zsh --noconfirm
  fi
  sudo chsh -s $(grep /zsh$ /etc/shells | tail -1)
  echo "ZSH done"
}

dev_env_install() {
  echo "Installing gvim, tmux, git, wget, curl and yaourt"
  apps=("vim" "tmux" "git" "wget" "curl" "yaourt")
  for app in "${apps[@]}"
  do
    echo "Installing $app"
    if ! exists "$app"; then
     sudo pacman -Syq "$app" --noconfirm
    fi
  done
  echo "Dev env install done"
}

fonts() {
  echo "Installing fonts"
  sudo pacman -Syq ttf-hack ttf-inconsolata --noconfirm
  echo "Fonts done"
}

termite_install() {
  echo "Installing termite terminal"
  if ! exists "termite"; then
    sudo pacman -Syq termite --noconfirm
  fi
  echo "Termite done"
}

setup_dotfiles() {
  echo "Setting up dotfiles"
  # backup files
  files=("zshrc" "vimrc" "tmux" "vim")
  for file in "${files[@]}"
  do
    [ -f ~/."$file" ] && mv ~/."$file" ~/."$file".old
  done
  [ -f ~/.config/redshift.conf ] && mv ~/.config/redshift.conf ~/.config/redshift.conf.old
  [ -f ~/.config/termite/config ] && mv ~/.config/termite/config ~/.config/temite/config.old

  cp zshrc ~/.zshrc
  cp vimrc ~/.vimrc
  cp -r vim ~/.vim
  cp tmux.conf ~/.tmux.conf
  mkdir -p ~/.config/termite
  cp termite_config ~/.config/termite/config
  cp redshift.conf ~/.config/redshift.conf
  # create symlink
  #ln -s zshrc ~/.zshrc
  #ln -s vimrc ~/.vimrc
  #ln -sT vim ~/.vim
  #ln -s tmux.conf ~/.tmux.conf
  #mkdir -p ~/.config/termite
  #ln -s termite_config ~/.config/termite/config
  #ln -s redshift.conf ~/.config/redshift.conf

  echo "Dotfiles done"
}

vim_plugin_install() {
  echo "Setting up vim plugin"
  if ! exists git; then
    echo "Git not installed, installing git..."
    sudo pacman -Syq git --noconfirm
  fi
  mkdir -p ~/.vim/bundle
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  echo "Vim plugin done"
}
tmux_plugin_install() {
  echo "Setting up tmux plugin manager"
  mkdir -p ~/.tmux/plugins
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  echo "Tmux done"
}

install() {
  # Ask for permission (pretty pls?)
  sudo -v

  zsh_install
  fonts
  termite_install
  redshift_install
  dev_env_install
  setup_dotfiles
  vim_plugin_install
  tmux_plugin_install
  vim +PluginInstall +qall
}

install
source ~/.zshrc
