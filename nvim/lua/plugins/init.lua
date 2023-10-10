-- This file can be loaded by calling `lua require('plugins')` from your init.vim

return {
  -- vim qol plugins
  'haya14busa/is.vim',
  'andymass/vim-matchup',
  'luochen1990/rainbow',
  { 'windwp/nvim-autopairs', event = "InsertEnter", opts = {} },
  'AndrewRadev/splitjoin.vim',
  'chrisbra/Colorizer',
  'nvim-lua/plenary.nvim',
  'editorconfig/editorconfig-vim',
  'jremmen/vim-ripgrep',
  'pbrisbin/vim-mkdir',
  'tpope/vim-commentary',
  'tpope/vim-fugitive',
  'tpope/vim-repeat',
  'tpope/vim-surround',
  'stefandtw/quickfix-reflector.vim',
  'godlygeek/tabular',
  { 'junegunn/fzf',          build = ":call fzf#install()" },
  { 'junegunn/fzf.vim',      dependencies = { 'junegunn/fzf' } },
  'psliwka/vim-smoothie',

  -- tmux ressurect requirement
  'tpope/vim-obsession',

  -- ruby plugins
  'tpope/vim-endwise',
  { 'tpope/vim-rails',           ft = { 'ruby', 'eruby' } },
  { 'tpope/vim-bundler',         ft = { 'ruby', 'eruby' } },
  { 'vim-ruby/vim-ruby',         ft = { 'ruby', 'eruby' } },

  -- elixir plugins
  { 'mhinz/vim-mix-format',      ft = { 'elixir', 'eelixir' } },
  { 'elixir-editors/vim-elixir', ft = { 'elixir', 'eelixir' } },

  'mattn/emmet-vim',
  'christoomey/vim-tmux-runner'
}
