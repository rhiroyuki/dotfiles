# Disable terminal freeze <C s>
stty -ixon

export EDITOR=vim

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/ricardo/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Match uppercase letter and lowercase letter
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

autoload colors && colors
setopt prompt_subst

source ~/dotfiles/antigen.zsh
antigen use oh-my-zsh
antigen theme https://gist.github.com/400461ea289d9c8bdf5f81e4fa1157e5.git peepcode-bright
antigen bundle git
antigen bundle command-not-found
antigen bundle zsh-users/zsh-syntax-highlighting
antigen apply

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# Add NVM to PATH for scripting
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
