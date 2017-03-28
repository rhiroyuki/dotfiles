sudo pacman -S zsh gvim ttf-inconsolata yaourt tmux
yaourt -S ttf-ancient-fonts --noconfirm
chsh -s $(grep /zsh$ /etc/shells | tail -1)

# backup files
mv .zshrc .zshrc.old
mv .vimrc .vimrc.old
mv .vim .vim.old
mv .tmux.conf .tmux.conf.old

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# create symlink
ln -s zshrc ~/.zshrc
ln -s vimrc ~/.vimrc
ln -s vim ~/.vim
ln -s tmux.conf ~/.tmux.conf
ln -s redshift.conf ~/.config/redshift.conf

# install vim plugins
vim +PluginInstall

source ~/.zshrc
