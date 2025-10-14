return {
  {
    "NickvanDyke/opencode.nvim",
    dependencies = {
      -- Recommended for `ask()`, required for `toggle()` — otherwise optional
      { "folke/snacks.nvim", opts = { input = { enabled = true } } },
    },
    event = "VeryLazy",
    config = function()
      vim.g.opencode_opts = {
        -- Your configuration, if any — see `lua/opencode/config.lua`
      }

      -- Required for `vim.g.opencode_opts.auto_reload`
      vim.opt.autoread = true

      -- Recommended/example keymaps
      vim.keymap.set({ "n", "x" }, "<leader>oa", function() require("opencode").ask("@this: ") end, { desc = "Ask about this" })
      vim.keymap.set({ "n", "x" }, "<leader>o+", function() require("opencode").prompt("@this", { append = true }) end, { desc = "Add this to prompt" })
      vim.keymap.set({ "n", "x" }, "<leader>oe", function() require("opencode").prompt("Explain @this and its context") end, { desc = "Explain this" })
      vim.keymap.set({ "n", "x" }, "<leader>os", function() require("opencode").select() end, { desc = "Select prompt" })
      vim.keymap.set("n", "<leader>ot", function() require("opencode").toggle() end, { desc = "Toggle embedded" })
      vim.keymap.set("n", "<leader>on", function() require("opencode").command("session_new") end, { desc = "New session" })
      vim.keymap.set("n", "<S-C-u>",    function() require("opencode").command("messages_half_page_up") end, { desc = "Messages half page up" })
      vim.keymap.set("n", "<S-C-d>",    function() require("opencode").command("messages_half_page_down") end, { desc = "Messages half page down" })
    end,
  }
}
