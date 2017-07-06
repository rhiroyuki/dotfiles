set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'mattn/emmet-vim'

" Theme plugins
Plugin 'itchyny/lightline.vim' " pretty status bar
Plugin 'skwp/vim-colors-solarized'

" Navigation plugins
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'christoomey/vim-tmux-runner'
Plugin 'ctrlpvim/ctrlp.vim' " fuzzy finder
Plugin 'jby/tmux.vim' " tmux syntax
Plugin 'pbrisbin/vim-mkdir' " create folder if it doesn't exist
Plugin 'rking/ag.vim'
Plugin 'scrooloose/nerdtree' " file explorer

" All languages
Plugin 'scrooloose/syntastic' " syntax checking
Plugin 'chrisbra/color_highlight'

" Text plugins
Plugin 'godlygeek/tabular' " Align texts
Plugin 'jiangmiao/auto-pairs' " Insert or delete brackets, parens, quotes in pair
Plugin 'shime/vim-livedown'
Plugin 'tpope/vim-repeat' " Add support to repeat non-native commands
Plugin 'tpope/vim-surround' " Add tags/surrounds
Plugin 'vim-scripts/tComment' " add or remove comments

" Git plugins
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-git'

" Ruby/Rails plugins
Plugin 'keith/rspec.vim'
Plugin 'thoughtbot/vim-rspec'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-rails'
Plugin 'vim-ruby/vim-ruby'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

