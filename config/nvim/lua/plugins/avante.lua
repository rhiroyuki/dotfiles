return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  version = false, -- set this if you want to always pull the latest change
  opts = {
    provider = "copilot",
    -- provider = "ollama",
    -- vendors = {
    -- -- ---@type AvanteProvider
    --   ollama = {
    --     __inherited_from = "openai",
    --     api_key_name = "",
    --     endpoint = "http://127.0.0.1:11434/v1",
    --     model = "qwen2.5-coder:14b",
    --     -- model = "qwen2.5-coder:32b",
    --     disable_tools = true, -- Open-source models often do not support tools.
    --   },
    --   -- ollama = {
    --   --   endpoint = "http://0.0.0.0:11434/api",
    --   --   -- model = "deepseek-r1:14b",
    --   --   -- model = 'deepseek-r1:8b',
    --   --   -- model = "phi4",
    --   --   -- model = "llama3.1:latest",
    --   -- },
    -- },
  },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = "make",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    -- "zbirenbaum/copilot.lua", -- for providers='copilot'
    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
