# Disable terminal freeze <C s>
stty -ixon

export EDITOR=vim

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000

setopt interactive_comments # Allow comments even in interactive shells (especially for Muness)

# ===== Changing Directories
setopt auto_cd # If you type foo, and it isn't a command, and it is a directory in your cdpath, go there

# ===== History
setopt append_history # Allow multiple terminal sessions to all append to one zsh command history
setopt extended_history # save timestamp of command and duration
setopt inc_append_history # Add comamnds as they are typed, don't wait until shell exit
setopt hist_expire_dups_first # when trimming history, lose oldest duplicates first
setopt hist_ignore_dups # Do not write events to history that are duplicates of previous events
setopt hist_ignore_space # remove command line from history list when first character on the line is a space
setopt hist_find_no_dups # When searching history don't display results already cycled through twice
setopt hist_reduce_blanks # Remove extra blanks from each command line being added to history
setopt hist_verify # don't execute, just expand history
setopt share_history # imports new commands and appends typed commands to history

# Enable ^, see https://github.com/robbyrussell/oh-my-zsh/issues/449#issuecomment-6973326
setopt NO_NOMATCH

bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/ricardo/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

set -k
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

bindkey -v
export KEYTIMEOUT=1

bindkey '^P' up-history
bindkey '^N' down-history

# function zle-line-init zle-keymap-select {
#     VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]%  %{$reset_color%}"
#     RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/}$(git_custom_status) $EPS1"
#     zle reset-prompt
# }
# 
# zle -N zle-line-init
# zle -N zle-keymap-select

# check for tmux plugin manager
if [[ ! -d ~/.tmux/plugins/tpm ]];
then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if [[ ! -d ~/.zplug ]];
then
    git clone https://github.com/zplug/zplug ~/.zplug
    source ~/.zplug/init.zsh && zplug update --self
else
    source ~/.zplug/init.zsh
fi

if ! zplug check; then
    zplug install
fi

zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-completions", depth:1
zplug "junegunn/fzf-bin"
zplug "plugins/fasd",   from:oh-my-zsh
zplug "plugins/gitfast",   from:oh-my-zsh
zplug "mafredri/zsh-async", from:github
zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme

# Install packages that have not been installed yet
if ! zplug check --verbose; then
    printf "Install missing plugins? [y/N]: "
    if read -q; then
        echo; zplug install
    else
        echo
    fi
fi

zplug load --verbose

autoload -U promptinit; promptinit
prompt pure

# 'ls' pretty colors
alias ls='ls --color=auto'
eval `dircolors ~/dotfiles/dircolors.gruvbox`
autoload colors && colors

[[ $- != *i* ]] && return
[[ -z "$TMUX" ]] && exec tmux

# fuzzy finder
[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh

if type xcape &> /dev/null; then
  # Remap CapsLock to Left-Control
  #setxkbmap -option ctrl:nocaps

  # make short-pressed Ctrl behave like Escape:
  xcape -e 'Control_L=Escape'
fi

# --files: List files that would be searched but do not search
# --hidden: Search hidden files and folders
# --follow: Follow symlinks
# --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
export FZF_DEFAULT_COMMAND='rg --colors line:fg:yellow      \
   --colors line:style:bold     \
   --colors path:fg:green       \
   --colors path:style:bold     \
   --colors match:fg:black      \
   --colors match:bg:yellow     \
   --colors match:style:nobold  \
   --files --no-ignore --hidden --follow \
   --glob "!{.git,node_modules,vendor}/*"'


[[ -f ~/.zsh_env ]] && source ~/.zsh_env

# Aliases
[[ -f ~/.aliases ]] && source ~/.aliases
