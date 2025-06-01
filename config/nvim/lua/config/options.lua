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

-- Keep it off, let treesitter handle it
vim.cmd("syntax off")

set.swapfile = false
set.backup = false
set.writebackup = false

set.undodir = vim.fn.expand('~/.config/nvim/backups')
set.undofile = true

set.autoindent = true
set.smarttab = true
set.expandtab = true
set.shiftwidth = 2

vim.cmd('filetype plugin indent on')

-- Speed up loading ruby files
-- /usr/share/nvim/runtime/ftplugin/ruby.vim and runtime/autoload/provider/ruby.vim
vim.g.ruby_host_prog = os.getenv("HOME") .. "/.asdf/shims/neovim-ruby-host"
vim.g.ruby_path = {}

local group = vim.api.nvim_create_augroup("DisableRubyFiletypePlugin", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = "ruby",
  group = group,
  callback = function()
    vim.cmd('filetype plugin off')
  end
})

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
set.foldnestmax = 2
set.foldcolumn = '0'
set.foldlevel = 99
set.foldlevelstart = 99
set.foldenable = true

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

set.scrolloff = 999
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

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.mapleader = ' '
