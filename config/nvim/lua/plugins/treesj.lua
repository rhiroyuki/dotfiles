return {
  "Wansmer/treesj",
  keys = { "gS", "gJ" },
  lazy = true,
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    local treesj = require("treesj")

    treesj.setup({
      use_default_keymaps = false,
      check_syntax_error = true,
      max_join_length = 120,
      cursor_behavior = "hold",
      notify = true,
      dot_repeat = true,
      on_error = nil,
      langs = {
        ruby = {
          hash = { split = { last_separator = false } }
        }
      }
    })

    vim.keymap.set("n", "gS", treesj.split)
    vim.keymap.set("n", "gJ", treesj.join)
  end
}
