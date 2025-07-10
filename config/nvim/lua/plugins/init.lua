return {
  { "andymass/vim-matchup",                      event = "VeryLazy" },
  { "christoomey/vim-tmux-runner",               event = "VeryLazy" },
  { "godlygeek/tabular",                         lazy = true, cmd = "Tabularize" },
  { "haya14busa/is.vim",                         event = "VeryLazy" },
  { "mattn/emmet-vim",                           event = "VeryLazy" },
  { "pbrisbin/vim-mkdir",                        event = "VeryLazy" },
  { "psliwka/vim-smoothie",                      event = "VeryLazy" },
  { "stefandtw/quickfix-reflector.vim",          event = "VeryLazy" },
  { "tpope/vim-fugitive",                        lazy = true, cmd = "Git" },
  { "tpope/vim-repeat" },
  { "tpope/vim-surround",                        event = "VeryLazy" },
  { "windwp/nvim-autopairs",                     event = "InsertEnter", opts = {} },
  { "MeanderingProgrammer/render-markdown.nvim", lazy = true, ft = { "markdown", "codecompanion" }, opts = {} }
}
