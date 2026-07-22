return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        transparent_background = true,
        integrations = {
          cmp = true,
          nvimtree = true,
          treesitter = true,
          telescope = {
            enabled = true
          },
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { "italic" },
              hints = { "italic" },
              warnings = { "italic" },
              information = { "italic" },
            },
            underlines = {
              errors = { "underline" },
              hints = { "underline" },
              warnings = { "underline" },
              information = { "underline" },
            },
            inlay_hints = {
              background = true,
            },
          },
          indent_blankline = {
            enabled = true,
            scope_color = "", -- catppuccin color (eg. `lavender`) Default: text
            colored_indent_levels = false,
          },
        }
      })

      vim.cmd.colorscheme("catppuccin-macchiato")
    end
  }
  -- {
  --   'ajmwagar/vim-deus',
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     vim.opt.background = 'dark'
  --     vim.cmd.colorscheme('deus')
  --   end
  -- },
  -- 'ajmwagar/lightline-deus',
  -- 'itchyny/lightline.vim'
}
