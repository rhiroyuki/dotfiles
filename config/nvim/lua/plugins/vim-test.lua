return {
  "janko-m/vim-test",
  config = function()
    vim.keymap.set("n", "<leader>rs", ":TestFile<cr>")
    vim.keymap.set("n", "<leader>rn", ":TestNearest<cr>")
    vim.keymap.set("n", "<leader>rl", ":TestLast<cr>")
    vim.keymap.set("n", "<leader>ra", ":TestSuite<cr>")
    vim.keymap.set("n", "<leader>rj", ":TestVisit<cr>")
    vim.keymap.set("n", "<leader>rof", ":TestSuite --only-failures<cr>")

    vim.g["test#strategy"] = "vtr"
    vim.g["test#preserve_screen"] = 1
  end,
  event = "VeryLazy"
}
