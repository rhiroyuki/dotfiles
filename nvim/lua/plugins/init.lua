-- This file can be loaded by calling `lua require('plugins')` from your init.vim

return {
  -- vim qol plugins
  'nathanaelkane/vim-indent-guides',
  'luochen1990/rainbow',
  'jiangmiao/auto-pairs',
  'AndrewRadev/splitjoin.vim',
  'chrisbra/Colorizer',
  'nvim-lua/plenary.nvim',
  'editorconfig/editorconfig-vim',
  'gcmt/wildfire.vim',
  'jremmen/vim-ripgrep',
  'pbrisbin/vim-mkdir',
  'tpope/vim-vinegar',
  'tpope/vim-commentary',
  'tpope/vim-fugitive',
  'tpope/vim-repeat',
  'tpope/vim-surround',
  'stefandtw/quickfix-reflector.vim',
  'godlygeek/tabular',
  { 'junegunn/fzf', build = ":call fzf#install()" },
  { 'junegunn/fzf.vim', dependencies = { 'junegunn/fzf' }},
  'psliwka/vim-smoothie',
  'sheerun/vim-polyglot',

  -- tmux ressurect requirement
  'tpope/vim-obsession',

  -- ruby plugins
  'tpope/vim-endwise',
  'tpope/vim-rails',
  'tpope/vim-bundler',
  'vim-ruby/vim-ruby',
  { 'nelstrom/vim-textobj-rubyblock', dependencies = { 'kana/vim-textobj-user' } },
  'kana/vim-textobj-user',

  -- elixir plugins
  'mhinz/vim-mix-format',
  'elixir-editors/vim-elixir',

  'mattn/emmet-vim',
  'christoomey/vim-tmux-runner'
}

