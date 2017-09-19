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

# 'ls' pretty colors
alias ls='ls --color=auto'
eval `dircolors ~/dotfiles/dircolors.256dark`
autoload colors && colors
setopt prompt_subst

source ~/dotfiles/antigen.zsh
antigen use oh-my-zsh
antigen theme https://gist.github.com/400461ea289d9c8bdf5f81e4fa1157e5.git peepcode-bright
antigen bundle git
antigen bundle command-not-found
antigen bundle zsh-users/zsh-syntax-highlighting
antigen apply

# Tmux start every shell
# If not running interactively, do not do anything
[[ $- != *i* ]] && return
[[ -z "$TMUX" ]] && exec tmux

xset b off

# Change all files/folders to current user
alias bemine='sudo chown -R $USER:$USER . -R'

# Show dotfiles and dotfolders
alias lh='ls -Ad .*'

source ~/.zsh_env

if type xcape &> /dev/null; then
  # Remap CapsLock to Left-Control
  setxkbmap -option ctrl:nocaps

  # make short-pressed Ctrl behave like Escape:
  xcape -e 'Control_L=Escape'
fi

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export -U PATH="$PATH:$HOME/.rvm/bin"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
