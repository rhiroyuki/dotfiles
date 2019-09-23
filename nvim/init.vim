" Load matchit.vim, but only if the user hasn't installed a newer version.
runtime plugin/matchit.vim

"Set neovim to use truecolors
set termguicolors

" ================ General Config ====================

set number                      "Line numbers are good
set numberwidth=4
set relativenumber              "Make line number relative to the current row
set backspace=indent,eol,start  "Allow backspace in insert mode
set history=1000                "Store lots of :cmdline history
set showcmd                     "Show incomplete cmds down the bottom
set showmode                    "Show current mode down the bottom
set gcr=a:blinkon0              "Disable cursor blink
set visualbell                  "No sounds
set autoread                    "Reload files changed outside vim
set mouse=a                     "Enable mouse interaction with vim
set colorcolumn=81		"Enable colored column
set hidden                      "Required for operations modifying multiple buffers like rename.

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

source ~/.config/nvim/plugins.vim

source ~/.config/nvim/settings.vim

augroup git_commit
  autocmd!

  autocmd BufReadPost *
        \  if &filetype == 'gitcommit'
        \|     execute 'normal $'
        \| endif
augroup end

augroup FiletypeGroup
  autocmd!
  au BufNewFile,BufRead *.jsx set filetype=javascript.jsx
augroup END

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

" Setting up Vim Hyperbolic Time Chamber 💪

" function! DelayKeyPressRepetition(key)
"   execute "nnoremap <silent> " . a:key . " :silent! call redraw<cr>"
"   call jobstart(['bash', '-c', 'sleep 0.5'], extend({'key': a:key}, s:keypress_callbacks))
" endfunction

" function! s:RemapKey(job_id, data, event) dict
"   execute "nnoremap <silent> " . self.key . " " . self.key . ":call DelayKeyPressRepetition(\"" . self.key . "\")<cr>"
" endfunction

" let s:keypress_callbacks = {
"       \ 'on_exit': function('s:RemapKey')
"       \ }

" nnoremap <silent> j j:call DelayKeyPressRepetition("j")<cr>
" nnoremap <silent> k k:call DelayKeyPressRepetition("k")<cr>
" nnoremap <silent> l l:call DelayKeyPressRepetition("l")<cr>
" nnoremap <silent> h h:call DelayKeyPressRepetition("h")<cr>

com! FormatJSON :%!jq '.'
com! MinifyJSON :%!jq -c '.'

" command! -bang -nargs=* Rg
"       \ call fzf#vim#grep(
"       \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
"       \   <bang>0 ? fzf#vim#with_preview('up:60%')
"       \           : fzf#vim#with_preview('right:50%:hidden', '?'),
"       \   <bang>0)

command! -bang -nargs=* Rg
      \ call fzf#vim#grep(
      \   'rg --column --line-number --hidden --ignore-case --no-heading --color=always '.shellescape(<q-args>), 1,
      \   <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%')
      \           : fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%:hidden', '?'),
      \   <bang>0)

nnoremap <C-f> :Rg!<cr>

inoremap <S-Tab> <C-d>
