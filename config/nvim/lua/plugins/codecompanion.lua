return {
  "olimorris/codecompanion.nvim",
  opts = {},
  cmd = { "CodeCompanion", "CodeCompanionActions", "CodeCompanionChat", "CodeCompanionCmd" },
  lazy = true,
  config = function ()
    require("codecompanion").setup({
      strategies = {
        chat = {
          adapter = "copilot",
        },
        inline = {
          adapter = "copilot",
        },
        cmd = {
          adapter = "copilot",
        }
      },
    })

    local map = require("utils").map

    map("n", "<leader>aa", ":CodeCompanionActions<CR>")
    map("n", "<leader>at", ":CodeCompanion<CR>")
    map("n", "<leader>act", ":CodeCompanionChat Toggle<CR>")
    -- 
    map("n", "<leader>acc", ":CodeCompanionCmd")
  end,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
}
