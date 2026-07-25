return {
  "janko-m/vim-test",
  config = function()
    local map = require("utils").map

    map("n", "<leader>rs", ":TestFile<cr>", { desc = "Test file" })
    map("n", "<leader>rn", ":TestNearest<cr>", { desc = "Test nearest" })
    map("n", "<leader>rl", ":TestLast<cr>", { desc = "Test last" })
    map("n", "<leader>ra", ":TestSuite<cr>", { desc = "Test suite" })
    map("n", "<leader>rj", ":TestVisit<cr>", { desc = "Test visit" })
    map("n", "<leader>rof", ":TestSuite --only-failures<cr>", { desc = "Test suite (only failures)" })

    vim.g["test#strategy"] = "vtr"
    vim.g["test#preserve_screen"] = 1

    vim.g["test#elixir#exunit#options"] = "--trace"
  end,
  event = "VeryLazy"
}
