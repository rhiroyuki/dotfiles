return {
  {
    'neovim/nvim-lspconfig',
    cmd = 'LspInfo',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },
    },
    config = function()
      local lspconfig = require('lspconfig')
      local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
      local group = vim.api.nvim_create_augroup("DetectWhichLspRubyToStart", { clear = true })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "ruby",
        once = true,
        group = group,
        callback = function()
          vim.schedule(function()
            local root_path = vim.fs.dirname(vim.fs.find({ 'Gemfile' }, { upward = true })[1])
            local grep_command = "grep -E -i \"gem.*standard[\\\"'].*\""
            local grep_result = vim.fn.system(table.concat({ grep_command, " ", root_path, "/Gemfile" }))
            if grep_result == nil or grep_result == '' then
              vim.cmd("LspStart solargraph")
            else
              vim.cmd("LspStart standardrb")
            end
          end)
        end
      })

      local default_setup = function(server)
        lspconfig[server].setup({
          autostart = true,
          capabilities = lsp_capabilities
        })
      end

      local stopped_setup = function(server)
        lspconfig[server].setup({
          autostart = false,
          capabilities = lsp_capabilities
        })
      end

      require('mason').setup({ autostart = false })
      require('mason-lspconfig').setup({
        ensure_installed = {},
        handlers = {
          default_setup,
          standardrb = function()
            stopped_setup("standardrb")
          end,
          solargraph = function()
            stopped_setup("solargraph")
          end,
          lua_ls = function()
            lspconfig.lua_ls.setup({
              settings = {
                Lua = {
                  runtime = {
                    version = 'LuaJIT'
                  },
                  diagnostics = {
                    globals = { 'vim' },
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
