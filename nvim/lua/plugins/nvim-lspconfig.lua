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

      local default_setup = function(server)
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
