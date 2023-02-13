-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd([[packadd packer.nvim]])

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- colorscheme, lightline
  use 'ajmwagar/vim-deus'
  use 'ajmwagar/lightline-deus'
  use 'itchyny/lightline.vim'

  -- vim qol plugins
  use 'nathanaelkane/vim-indent-guides'
  use 'luochen1990/rainbow'
  use 'jiangmiao/auto-pairs'
  use 'AndrewRadev/splitjoin.vim'
  use 'chrisbra/Colorizer'
  use 'ctrlpvim/ctrlp.vim'
  use 'editorconfig/editorconfig-vim'
  use 'gcmt/wildfire.vim'
  use 'janko-m/vim-test'
  use 'jremmen/vim-ripgrep'
  use 'pbrisbin/vim-mkdir'

  use 'nvim-tree/nvim-tree.lua'

  use 'tpope/vim-vinegar'
  use 'tpope/vim-commentary'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-repeat'
  use 'tpope/vim-surround'
  use 'stefandtw/quickfix-reflector.vim'
  use 'godlygeek/tabular'
  use { 'junegunn/fzf', run = ":call fzf#install()" }
  use { 'junegunn/fzf.vim' }
  use 'psliwka/vim-smoothie'

  -- tmux ressurect requirement
  use 'tpope/vim-obsession'

  -- ruby plugins
  use 'tpope/vim-endwise'
  use 'tpope/vim-rails'
  use 'tpope/vim-bundler'
  use 'vim-ruby/vim-ruby'
  use 'nelstrom/vim-textobj-rubyblock'
  use 'kana/vim-textobj-user'

  -- elixir plugins
  use 'mhinz/vim-mix-format'
  use 'elixir-editors/vim-elixir'

  -- emmet plugin
  use 'mattn/emmet-vim'

  -- tmux plugins
  use 'christoomey/vim-tmux-navigator'
  use 'christoomey/vim-tmux-runner'
  use 'sheerun/vim-polyglot'
end)
