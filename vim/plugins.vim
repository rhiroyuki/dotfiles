set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call plug#begin()
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plug 'mattn/emmet-vim'

" Theme plugins
Plug 'itchyny/lightline.vim' " pretty status bar
Plug 'skwp/vim-colors-solarized'

" Navigation plugins
Plug 'christoomey/vim-tmux-navigator'
Plug 'christoomey/vim-tmux-runner'
Plug 'ctrlpvim/ctrlp.vim' " fuzzy finder
Plug 'jby/tmux.vim' " tmux syntax
Plug 'pbrisbin/vim-mkdir' " create folder if it doesn't exist
Plug 'rking/ag.vim'
Plug 'scrooloose/nerdtree' " file explorer

" All languages
Plug 'w0rp/ale'
" Plugin 'scrooloose/syntastic' " syntax checking
Plug 'chrisbra/color_highlight'

" Text plugins
Plug 'godlygeek/tabular' " Align texts
Plug 'jiangmiao/auto-pairs' " Insert or delete brackets, parens, quotes in pair
Plug 'shime/vim-livedown'
Plug 'tpope/vim-repeat' " Add support to repeat non-native commands
Plug 'tpope/vim-surround' " Add tags/surrounds
Plug 'vim-scripts/tComment' " add or remove comments

" Git plugins
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'

" Ruby/Rails plugins
Plug 'keith/rspec.vim'
Plug 'thoughtbot/vim-rspec'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-rails'
Plug 'vim-ruby/vim-ruby'

" All of your Plugins must be added before the following line
call plug#end()            " required
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

