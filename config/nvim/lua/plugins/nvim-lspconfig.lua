return {
  {
    "neovim/nvim-lspconfig",
    cmd = "LspInfo",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      -- Enabling folding for nvim-ufo
      capabilities.textDocument.foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true
      }
      local group = vim.api.nvim_create_augroup("DetectWhichLspRubyToStart", { clear = true })

      local default_opt = { autostart = true, capabilities = capabilities }

      local lsp_server_setup = function(server, opt)
        lspconfig[server].setup(vim.tbl_deep_extend("force", default_opt, opt or {}))
      end

      local util = require 'lspconfig.util'
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "ruby",
        once = true,
        group = group,
        callback = function()
          vim.schedule(function()
            -- @param gem_name string
            -- @return boolean
            local is_gem_in_gemfile = function(gem_name)
              local grep_command = "grep -E -i \"gem.*" .. gem_name .. "[\\\"'].*\""
              local root_path = vim.fs.dirname(vim.fs.find({ 'Gemfile' }, { upward = true })[1])
              local grep_result = vim.fn.system(table.concat({ grep_command, " ", root_path or "", "/Gemfile" }))
              return grep_result ~= nil and grep_result ~= ''
            end

            -- Reads the .tool-versions file and returns a table of tool versions
            -- @return table
            local function read_tool_versions()
              local tool_versions = {}
              local file_path = ".tool-versions"

              local file = io.open(file_path, "r")
              if not file then
                print("Could not open file: " .. file_path)
                return tool_versions
              end

              for line in file:lines() do
                local language, version = line:match("(%S+)%s+(%S+)")
                if language and version then
                  tool_versions[language] = version
                end
              end

              file:close()

              return tool_versions
            end

            local tool_versions = read_tool_versions()
            local language = 'ruby'

            -- Handles which LSP to start
            -- builds a table of all the LSPs that are installed and its required conditions
            -- creates a new table
            local ruby_lsps = {
              solargraph = {
                gem_name = "solargraph",
                prerequisites = function()
                  return is_gem_in_gemfile("solargraph")
                end,
                cmd_args = {"solargraph", "stdio"}
              },
              rubocop = {
                gem_name = "rubocop",
                prerequisites = function()
                  return is_gem_in_gemfile("rubocop")
                end,
                cmd_args = {"rubocop", "--lsp"}
              },
              standardrb = {
                gem_name = "standard",
                prerequisites = function()
                  return is_gem_in_gemfile("standard")
                end,
                cmd_args = {"standardrb", "--lsp"}
              },
              ruby_lsp = {
                gem_name = "ruby-lsp",
                prerequisites = function()
                  return is_gem_in_gemfile("ruby-lsp")
                end,
                cmd_args = {"ruby-lsp", "--stdio"}
              }
            }

            local language_version = tool_versions[language]
            local current_directory = string.match(vim.fn.getcwd(), ".*/([%l%u]*)$")
            local timestamp = os.time(os.date("!*t"))

            for lsp_name, lsp in pairs(ruby_lsps) do
              if language_version and lsp.prerequisites() then
                ruby_lsps[lsp_name].installed = true

                local command = {
                  'docker',
                  'run',
                  '-i',
                  '--rm',
                  '--name',
                  string.format('lsp_%s_%s_%s_%s', current_directory, language, language_version, timestamp),
                  '-v',
                  string.format('%s:/app/', vim.fn.getcwd()),
                  string.format('lsp_%s_%s', language, language_version),
                }

                -- Add the command to the command table
                for _, v in ipairs(lsp.cmd_args) do
                  table.insert(command, v)
                end

                lsp_server_setup(lsp_name, {
                  before_init = function(params)
                    params.processId = vim.NIL
                  end,
                  settings = {
                    rubocop = {
                      diagnostics = true,
                    },
                  },
                  init_options = { formatting = true },
                  filetypes = { 'ruby' },
                  root_dir = util.root_pattern('Gemfile', '.git'),
                  cmd = command
                })

                vim.cmd("LspStart " .. lsp_name)
              else
                ruby_lsps[lsp_name].installed = false
              end
            end
          end)
        end
      })

      require("mason").setup({ autostart = false })
      require("mason-lspconfig").setup({
        ensure_installed = {},
        handlers = {
          lsp_server_setup,
          standardrb = function() end,
          lua_ls = function()
            lspconfig.lua_ls.setup({
              settings = {
                Lua = {
                  runtime = {
                    version = "LuaJIT"
                  },
                  diagnostics = {
                    globals = { "vim" },
                  },
                  workspace = {
                    library = {
                      vim.env.VIMRUNTIME,
                    }
                  }
                }
              }
            })
          end,
        },
      })
    end
  },
}
