" Load matchit.vim, but only if the user hasn't installed a newer version.
runtime plugin/matchit.vim

" Set neovim to use truecolors
set termguicolors

" ================ General Config ====================

set number                      "Line numbers are good
set backspace=indent,eol,start  "Allow backspace in insert mode
set history=1000                "Store lots of :cmdline history
set showcmd                     "Show incomplete cmds down the bottom
set showmode                    "Show current mode down the bottom
set gcr=a:blinkon0              "Disable cursor blink
set visualbell                  "No sounds
set autoread                    "Reload files changed outside vim
set mouse=a                     "Enable mouse interaction with vim

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" This makes vim act like all other editors, buffers can
" exist in the background without being in a window.
" http://items.sjbach.com/319/configuring-vim-right
set hidden

"turn on syntax highlighting
if !exists("g:syntax_on")
  syntax enable
endif

let mapleader=" "

" ================ Turn Off Swap Files ==============

set noswapfile
set nobackup
set nowb

" ================ Persistent Undo ==================
" Keep undo history across sessions, by storing in file.
" Only works all the time.
if has('persistent_undo') && isdirectory(expand('~').'/.config/nvim/')
  silent !mkdir -p ~/.config/nvim/backups > /dev/null 2>&1
  set undodir=~/.config/nvim/backups
  set undofile
endif

" ================ Indentation ======================

set autoindent
set smarttab
set shiftwidth=2
set softtabstop=2
set expandtab

" Auto indent pasted text
nnoremap p p=`]<C-o>
nnoremap P P=`]<C-o>

filetype plugin indent on

" Display tabs and trailing spaces visually
set list listchars=tab:\ \ ,trail:·

set nowrap       "Don't wrap lines
set linebreak    "Wrap lines at convenient points

" ================ Folds ============================

set foldmethod=indent   "fold based on indent
set foldnestmax=3       "deepest fold is 3 levels
set nofoldenable        "dont fold by default

" ================ Completion =======================

set wildmode=list:longest
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing
set wildignore+=*.config/nvim/backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=node_modules/**
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif

" ================ Scrolling ========================

set scrolloff=10
set sidescrolloff=15
set sidescroll=1

" ================ Cursor Position ==================

set cursorline
set cursorcolumn

" ================ Search ===========================

set incsearch       " Find the next match as we type the search
set hlsearch        " Highlight searches by default
set ignorecase      " Ignore case when searching...
set smartcase       " ...unless we type a capital

if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
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
Plug 'jiangmiao/auto-pairs'
Plug 'jremmen/vim-ripgrep'
Plug 'luochen1990/rainbow'
Plug 'pbrisbin/vim-mkdir'
Plug 'scrooloose/nerdtree'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'yegappan/greplace'

" tmux ressurect requirement
Plug 'tpope/vim-obsession'

" autocomplete suggestions plugin
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" LanguageClient
Plug 'autozimu/LanguageClient-neovim', {
      \ 'branch': 'next',
      \ 'do': 'bash install.sh',
      \ }

" linter
Plug 'w0rp/ale'

Plug 'janko-m/vim-test'

" ruby plugins
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-bundler'
Plug 'vim-ruby/vim-ruby' 
Plug 'nelstrom/vim-textobj-rubyblock'

" 
Plug 'kana/vim-textobj-user'

" emmet plugin
Plug 'mattn/emmet-vim', { 'for': ['javascript.jsx', 'html', 'css', 'javascript', 'eruby'] }

" tmux plugins
Plug 'christoomey/vim-tmux-navigator'
Plug 'christoomey/vim-tmux-runner'
Plug 'tmux-plugins/vim-tmux-focus-events'

call plug#end()

set background=dark
let g:gruvbox_italic=1
colorscheme gruvbox
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'readonly', 'relativepath', 'modified' ] ]
      \ },
      \ 'colorscheme': 'gruvbox'
      \ }
set noshowmode

" Compatibility editorconfig and timpope fugitive
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" Required for operations modifying multiple buffers like rename.
set hidden

let g:LanguageClient_serverCommands = {
      \ 'javascript': ['javascript-typescript-stdio'],
      \ 'javascript.jsx': ['javascript-typescript-stdio'],
      \ 'ruby': ['tcp://localhost:7658']
      \ }

nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>

" vim-test mappings
nnoremap <Leader>rs :TestFile<CR>
nnoremap <Leader>rn :TestNearest<CR>
nnoremap <Leader>rl :TestLast<CR>
nnoremap <Leader>ra :TestSuite<CR>
nnoremap <Leader>rj :TestVisit<CR>

" vim-test send tests to vim tmux runner
let test#strategy = 'vtr'

nnoremap <Leader>h :CtrlPMRU<CR>

let g:rainbow_active = 1

" haya14busa/incsearch.vim
" keep it as map
let g:incsearch#auto_nohlsearch = 1
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)


let is_tmux = $TMUX
if is_tmux != ""
  autocmd VimEnter * VtrAttachToPane
endif

" Emmet configurations
" extends jsx and let it create jsx tags
" example: <div className="popup"></div>
let g:user_emmet_settings = {
      \  'javascript.jsx' : {
      \      'extends' : 'jsx',
      \  },
      \}

autocmd FileType html,css,javascript.jsx,javascript EmmetInstall
autocmd FileType ruby setlocal omnifunc=LanguageClient#complete

" Make nerdtree look nice
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let g:NERDTreeWinSize = 30
let NERDTreeQuitOnOpen=1

" Disable netrw since we are using nerdtree
let g:loaded_netrwPlugin = 1

function! NERDTreeFindToggle()
  if g:NERDTree.IsOpen()
    NERDTreeFind
    q
  else
    NERDTreeFind
  endif
endfunction

" Open the project tree and expose current file in the nerdtree with Ctrl-\
command! LocalNERDTreeToggle call NERDTreeFindToggle()
nnoremap <silent> <C-\> :LocalNERDTreeToggle<cr>

augroup FiletypeGroup
  autocmd!
  au BufNewFile,BufRead *.jsx set filetype=javascript.jsx
augroup END

let g:ale_linters = {'jsx': ['stylelint', 'eslint']}
let g:ale_linter_aliases = {'jsx': 'css'}
let g:ale_fixers = { 'javascript': ['eslint'] }
let g:ale_completion_enabled = 0

" Use deoplete.
let g:deoplete#enable_at_startup = 1

if executable('rg')
  " https://elliotekj.com/2016/11/22/setup-ctrlp-to-use-ripgrep-in-vim/
  set grepprg=rg\ --color=never
  let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
  let g:ctrlp_use_caching = 0
endif

let g:ctrlp_match_current_file = 1

let g:rg_window_location = 'bot'

" Navigating between VIM panes
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <C-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <C-j> :TmuxNavigateDown<cr>
nnoremap <silent> <C-k> :TmuxNavigateUp<cr>
nnoremap <silent> <C-l> :TmuxNavigateRight<cr>

" don't let tmux zoom out if you try to go out of bounds
let g:tmux_navigator_disable_when_zoomed = 1

" Tab Shortcuts
nnoremap tf :tabfirst<CR>
nnoremap tn :tabnext<CR>
nnoremap tp :tabprev<CR>
nnoremap tl :tablast<CR>
nnoremap tt :tabnew<CR>
nnoremap tx :tabclose<CR>

" Manage Vim config more easily
nnoremap <leader>ve :vsplit $MYVIMRC<cr>
nnoremap <leader>vr :source $MYVIMRC<cr>

" Easy splits
nnoremap vv <C-w>v
nnoremap ss <C-w>s

nnoremap <Leader>- :wincmd _<cr>:wincmd \|<cr>
nnoremap <Leader>= :wincmd =<cr>
nnoremap <leader><leader> <C-^>
nnoremap 0 ^

inoremap <silent> <C-K> <%=  %><Esc>2hi
inoremap <silent> <C-J> <%  %><Esc>2hi
