return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "VeryLazy",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false, auto_trigger = false },
        panel = { enabled = false },
        copilot_node_command = (function()
          -- Dynamically determine the path to the node executable
          -- And avoid to use node from current project directory that vim is opened
          local paths = {"/bin/node", "/usr/bin/node"}
          for _, path in ipairs(paths) do
            if os.execute("test -x " .. path) then
              return path
            end
          end
          local handle = io.popen("which node")
          local result = handle:read("*a")
          handle:close()
          return result:gsub("%s+", "") -- Remove any trailing whitespace
        end)()
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
