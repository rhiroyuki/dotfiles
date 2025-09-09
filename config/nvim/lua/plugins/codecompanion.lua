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
      local constants = {
        LLM_ROLE = "llm",
        USER_ROLE = "user",
        SYSTEM_ROLE = "system",
      }

      require('codecompanion').setup({
        prompt_library = {
          ["Feature-to-Code Workflow"] = {
            strategy = "workflow",
            description = "Read feature spec, generate tests & code, ensure tests pass",
            opts = {
              index = 1,     -- defines its position in palette
              is_default = false,
              short_name = "ftc",
              is_slash_command = true,
            },
            prompts = {
              -- Step 1: Read spec & generate tests
              {
                {
                  name = "Generate Tests",
                  role = constants.USER_ROLE,
                  opts = { auto_submit = false },
                  content = [[
                  You will receive a feature story describing desired functionality.
                  Step 1: analyze the story and write comprehensive tests in the target language or framework.
                  Output only the tests initially.
                  ]]
                },
              },
              -- Step 2: Generate implementation & run tests
              {
                {
                  name = "Implement & Test",
                  role = constants.USER_ROLE,
                  opts = { auto_submit = false },
                  content = [[
                  Now implement the code to satisfy the tests.
                  Use the @{insert_edit_into_file} tool to write the code, and then run the tests using @{cmd_runner}.
                  Include both tool calls in your response.
                  ]]
                },
              },
              -- Step 3: Iterate on failures until tests pass
              {
                {
                  name = "Fix Failures",
                  role = constants.USER_ROLE,
                  opts = { auto_submit = true },
                  condition = function()
                    return _G.codecompanion_current_tool == "cmd_runner"
                  end,
                  repeat_until = function(chat)
                    return chat.tools.flags.testing == true
                  end,
                  content = "The tests failed. Please update the implementation to fix the failures and re-run the tests."
                },
              },
            },
          },
        },
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
            tools = {
              -- Enable editor tool for inline editing
              ["editor"] = {
                enabled = true,
                opts = {
                  diff = true, -- Show diffs like Cursor
                  close_chat_at = 240, -- Close chat after edit
                }
              },
            }
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
