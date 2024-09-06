return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "VeryLazy",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false, auto_trigger = false },
        panel = { enabled = false },
        copilot_node_command = '/bin/node' -- Avoid having to install nodejs in every project
      })
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "zbirenbaum/copilot.lua" },
    event = "VeryLazy",
    config = function()
      require("copilot_cmp").setup()
    end
  },
}
