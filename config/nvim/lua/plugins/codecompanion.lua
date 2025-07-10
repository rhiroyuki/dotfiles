return {
  {
    'olimorris/codecompanion.nvim',
    opts = {},
    cmd = {
      'CodeCompanion',
      'CodeCompanionActions',
      'CodeCompanionChat',
      'CodeCompanionCmd'
    },
    lazy = true,
    config = function()
      require('codecompanion').setup({
        extensions = {
          mcphub = {
            callback = 'mcphub.extensions.codecompanion',
            opts = {
              show_result_in_chat = true, -- Show mcp tool results in chat
              make_vars = true,           -- Convert resources to #variables
              make_slash_commands = true, -- Add prompts as /slash commands
            }
          }
        },
        strategies = {
          chat = {
            adapter = 'copilot',
          },
          inline = {
            adapter = 'copilot',
          },
          cmd = {
            adapter = 'copilot',
          }
        },
      })
    end,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'ravitemer/mcphub.nvim',
    }
  },
  {
    'echasnovski/mini.diff',
    config = function()
      local diff = require('mini.diff')
      diff.setup({
        -- Disabled by default
        source = diff.gen_source.none(),
      })
    end,
  },
}
