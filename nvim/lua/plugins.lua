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


  use 'nvim-lua/plenary.nvim'
  use {
      'nvim-treesitter/nvim-treesitter',
      run = function()
          local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
          ts_update()
      end,
  }
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.1',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

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

  -- lsp
  use {
  'VonHeikemen/lsp-zero.nvim',
  branch = 'v1.x',
  requires = {
    -- LSP Support
    {'neovim/nvim-lspconfig'},             -- Required
    {'williamboman/mason.nvim'},           -- Optional
    {'williamboman/mason-lspconfig.nvim'}, -- Optional

    -- Autocompletion
    {'hrsh7th/nvim-cmp'},         -- Required
    {'hrsh7th/cmp-nvim-lsp'},     -- Required
    {'hrsh7th/cmp-buffer'},       -- Optional
    {'hrsh7th/cmp-path'},         -- Optional
    {'saadparwaiz1/cmp_luasnip'}, -- Optional
    {'hrsh7th/cmp-nvim-lua'},     -- Optional

    -- Snippets
    {'L3MON4D3/LuaSnip'},             -- Required
    {'rafamadriz/friendly-snippets'}, -- Optional
  }
}
end)
