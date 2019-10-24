if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

" theme/lightline plugins
Plug 'morhetz/gruvbox'
" Plug 'drewtempelmeyer/palenight.vim'
Plug 'ajmwagar/vim-deus' 
Plug 'itchyny/lightline.vim'

" vim improvements plugins
Plug 'AndrewRadev/splitjoin.vim'
Plug 'chrisbra/Colorizer'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'gcmt/wildfire.vim'
Plug 'haya14busa/incsearch.vim'
Plug 'janko-m/vim-test'
Plug 'jiangmiao/auto-pairs'
Plug 'jremmen/vim-ripgrep'
Plug 'luochen1990/rainbow'
Plug 'pbrisbin/vim-mkdir'
Plug 'scrooloose/nerdtree', { 'commit': '67fa9b3116948466234978aa6287649f98e666bd' }
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'stefandtw/quickfix-reflector.vim'
Plug 'godlygeek/tabular'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" tmux ressurect requirement
Plug 'tpope/vim-obsession'

" autocomplete suggestions plugin
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" LanguageClient
" Plug 'autozimu/LanguageClient-neovim', {
"       \ 'branch': 'next',
"       \ 'do': 'bash install.sh',
"       \ }

Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}

" linter
" Plug 'w0rp/ale'

" ruby plugins
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-rails'
Plug 'kremso/vim-spectator' " allow usage of :A to create the spec file
Plug 'tpope/vim-bundler'
Plug 'vim-ruby/vim-ruby' 
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'kana/vim-textobj-user'

" elixir plugins
Plug 'elixir-editors/vim-elixir'

" emmet plugin
Plug 'mattn/emmet-vim', { 'for': ['javascript.jsx', 'html', 'css', 'javascript', 'eruby'] }

" tmux plugins
Plug 'christoomey/vim-tmux-navigator'
Plug 'christoomey/vim-tmux-runner'
Plug 'tmux-plugins/vim-tmux-focus-events'

call plug#end()
