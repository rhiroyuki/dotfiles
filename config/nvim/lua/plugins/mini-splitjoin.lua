return {
  "nvim-mini/mini.splitjoin",
  keys = { "gS", "gJ" },
  config = function()
    local splitjoin = require("mini.splitjoin")

    splitjoin.setup({
      mappings = {
        toggle = "",
        split = "",
        join = "",
      },
    })

    vim.keymap.set({ "n", "x" }, "gS", splitjoin.split, { desc = "Split arguments" })
    vim.keymap.set({ "n", "x" }, "gJ", splitjoin.join, { desc = "Join arguments" })
  end,
}
