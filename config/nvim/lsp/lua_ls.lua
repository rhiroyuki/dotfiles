return require("utils").setup_capabilities(
  {
    cmd = {
      "lua-language-server",
    },
    filetypes = {
      "lua",
    },
    root_markers = {
      '.luarc.json',
      '.luarc.jsonc',
      '.luacheckrc',
      '.stylua.toml',
      'stylua.toml',
      'selene.toml',
      'selene.yml',
      '.git',
    },
    single_file_support = true,
    log_level = vim.lsp.protocol.MessageType.Warning,
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
  }
)
