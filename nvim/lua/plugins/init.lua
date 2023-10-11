-- This file can be loaded by calling `lua require('plugins')` from your init.vim

return {
  { 'haya14busa/is.vim' },
  { 'andymass/vim-matchup', event = "VeryLazy" },
  'luochen1990/rainbow',
  { 'windwp/nvim-autopairs',       opts = {} },
  'AndrewRadev/splitjoin.vim',
  { 'norcalli/nvim-colorizer.lua', event = "VeryLazy" },
  'nvim-lua/plenary.nvim',
  'editorconfig/editorconfig-vim',
  'jremmen/vim-ripgrep',
  { 'pbrisbin/vim-mkdir' },
  { 'tpope/vim-commentary' },
  { 'tpope/vim-fugitive',  event = "VeryLazy" },
  { 'tpope/vim-repeat' },
  { 'tpope/vim-surround' },
  { 'tpope/vim-endwise' },
  'stefandtw/quickfix-reflector.vim',
  { 'godlygeek/tabular',          event = "VeryLazy" },
  { 'junegunn/fzf',               build = ":call fzf#install()" },
  { 'junegunn/fzf.vim',           dependencies = { 'junegunn/fzf' } },
  { 'psliwka/vim-smoothie' },
  { 'mattn/emmet-vim',            event = "VeryLazy" },
  { 'christoomey/vim-tmux-runner' }
}
