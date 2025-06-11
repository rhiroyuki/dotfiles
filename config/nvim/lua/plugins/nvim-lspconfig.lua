return {
  {
    "williamboman/mason.nvim",
    lazy = true,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = true,
  },
  {
    "neovim/nvim-lspconfig",
    lazy = true,
    cmd = "LspInfo",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    config = function()
      local lspconfig = require("lspconfig")
      local utils = require("utils")
      local capabilities = utils.setup_capabilities({})
      -- Enabling folding for nvim-ufo
      capabilities.textDocument.foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true
      }

      local default_opt = { autostart = true, capabilities = capabilities }

      local lsp_server_setup = function(server, opt)
        local built_capabilities = opt and opt.capabilities or {}

        local merge_capabilities = vim.tbl_deep_extend("force", built_capabilities, opt or {})

        if utils.module_exists("lsp" .. server) then
          local lsp_capabilities = require("lsp." .. server)

          merge_capabilities = vim.tbl_deep_extend("force", merge_capabilities, lsp_capabilities)
        end

        lspconfig[server].setup(
          vim.tbl_deep_extend("force", default_opt, {
            capabilities = merge_capabilities,
          })
        )
      end

      require("mason").setup({ autostart = false })
      require("mason-lspconfig").setup({
        ensure_installed = {},
        handlers = {
          lsp_server_setup,
          standardrb = function() end,
          rubocop = function() end,
          ruby_lsp = function() end
        },
      })
    end
  },
}
