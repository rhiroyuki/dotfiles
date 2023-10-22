return {
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'RRethy/nvim-treesitter-endwise'
    },
    build = ":TSUpdate",
    event = 'VeryLazy',
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "ruby",
        },
        auto_install = true,
        endwise = {
          enable = true,
        },
        highlight = {
          enable = true
        }
      })
    end
  }
}
