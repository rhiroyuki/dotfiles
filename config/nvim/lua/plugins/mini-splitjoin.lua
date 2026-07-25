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

    local map = require("utils").map

    map({ "n", "x" }, "gS", splitjoin.split, { desc = "Split arguments" })
    map({ "n", "x" }, "gJ", splitjoin.join, { desc = "Join arguments" })
  end,
}
