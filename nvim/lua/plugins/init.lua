-- This file can be loaded by calling `lua require('plugins')` from your init.vim

return {
  -- vim qol plugins
  'andymass/vim-matchup',
  'luochen1990/rainbow',
  'jiangmiao/auto-pairs',
  'AndrewRadev/splitjoin.vim',
  'chrisbra/Colorizer',
  'nvim-lua/plenary.nvim',
  'editorconfig/editorconfig-vim',
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
  -- 'sheerun/vim-polyglot',

  -- tmux ressurect requirement
  'tpope/vim-obsession',

  -- ruby plugins
  'tpope/vim-endwise',
  { 'tpope/vim-rails', ft = { 'ruby', 'eruby' } },
  { 'tpope/vim-bundler', ft = { 'ruby', 'eruby' } },
  { 'vim-ruby/vim-ruby', ft = { 'ruby', 'eruby' } },
  -- 'kana/vim-textobj-user',
  -- { 'nelstrom/vim-textobj-rubyblock', dependencies = { 'kana/vim-textobj-user' }, ft = { 'ruby', 'eruby' } },

  -- elixir plugins
  { 'mhinz/vim-mix-format', ft = { 'elixir', 'eelixir' } },
  { 'elixir-editors/vim-elixir', ft = { 'elixir', 'eelixir' } },

  'mattn/emmet-vim',
  'christoomey/vim-tmux-runner'
}

