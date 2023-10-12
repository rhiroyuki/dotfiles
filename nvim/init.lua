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
set.expandtab = true
set.shiftwidth = 2

vim.cmd('filetype plugin indent on')

-- Speed up loading ruby files
-- /usr/share/nvim/runtime/ftplugin/runtime/ftplugin/ruby.vim and runtime/autoload/provider/ruby.vim
vim.g.ruby_host_prog = os.getenv("HOME") .. "/.asdf/shims/neovim-ruby-host"
-- vim.g.ruby_path = {}

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

vim.g.mapleader = ' '

-- =============== Diagnostics =======================

-- vim.diagnostic.config({
--   virtual_text = false,
-- })

-- =============== Plugins ===========================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup('plugins', {
  change_detection = {
    notify = false
  }
})
require('remap')
