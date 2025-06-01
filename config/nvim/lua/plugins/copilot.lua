return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    lazy = true,
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false, auto_trigger = false },
        panel = { enabled = false },
        copilot_node_command = (function()
          local function check_node_version(node_path)
            local version_output = vim.fn.system(node_path .. " -v"):gsub("%s+", "")
            if version_output:match("^v%d+%.%d+") then
              local major_version = tonumber(version_output:match("v(%d+).*"))
              return major_version > 20
            end
            return false
          end

          -- Dynamically determine the path to the node executable
          -- And avoid using node from the current project directory that vim is opened
          local paths = { "/bin/node", "/usr/bin/node", os.getenv("HOME") .. "/.asdf/installs/nodejs/22.14.0/bin/node" }
          for _, path in ipairs(paths) do
            if vim.fn.executable(path) == 1 and check_node_version(path) then
              return path
            end
          end
          local result = vim.fn.system("which node"):gsub("%s+", "")
          if vim.fn.executable(result) == 1 and check_node_version("node") then
            return result
          else
            vim.api.nvim_err_writeln("No valid Node.js executable found for Copilot.")
            return nil
          end
        end)()
      })
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "zbirenbaum/copilot.lua" },
    lazy = true,
    event = "InsertEnter",
    config = function()
      require("copilot_cmp").setup()
    end
  },
}
