local set = vim.opt

set.termguicolors = true
set.number = true
set.numberwidth = 4
set.relativenumber = false
set.backspace = 'indent,eol,start'
set.history = 1000
set.showcmd = true
set.showmode = true
set.gcr = 'a:blinkon0'
set.visualbell = true
set.autoread = true
set.mouse:append('a')
set.colorcolumn = '81'
set.hidden = true
set.lazyredraw = true
set.splitbelow = true
set.splitright = true
set.diffopt:append('vertical')
set.hidden = true

if vim.g.syntax_on then
  vim.cmd("syntax enable")
end

set.swapfile = false
set.backup = false
set.writebackup = false

set.undodir = vim.fn.expand('~/.config/nvim/backups')
set.undofile = true

set.autoindent = true
set.smarttab = true
set.shiftwidth = 2

vim.cmd('filetype plugin indent on')

-- Display tabs and trailing spaces visually
set.list = true
set.listchars:append({
  tab = '>~',
  trail = '.'
})

set.wrap = false
set.linebreak = true
--- " ================ Folds ============================

set.foldmethod = 'indent'
set.foldnestmax = 3
set.foldenable = false

--- " ================ Completion =======================

set.wildmode = 'list:longest'
set.wildmenu = true
set.wildignore = {
  '*.o',
  '*.obj',
  '*~',
  '*.config/nvim/backups*',
  '*sass-cache*',
  '*DS_Store*',
  'node_modules/**',
  'vendor/rails/**',
  'vendor/cache/**',
  '*.gem',
  'log/**',
  'tmp/**',
  '*.png',
  '*.jpg',
  '*.gif'
}

-- ================ Scrolling ========================

set.scrolloff = 10
set.sidescrolloff = 15
set.sidescroll = 1

-- ================ Cursor Position ==================

set.cursorline = true
set.cursorcolumn = false

-- ================ Search ===========================

set.incsearch = true
set.hlsearch = true
set.ignorecase = true
set.smartcase = true
set.inccommand = 'split'

-- Disables netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require('remap')
require('plugins')