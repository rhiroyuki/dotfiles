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
    keys = {
      { "<leader>la", "<cmd>LspStart<cr>", desc = "Activate LSP" },
    },
    init = function()
      vim.api.nvim_create_user_command("LspStart", function()
        require("lazy").load({ plugins = { "nvim-lspconfig" } })
      end, { desc = "Activate LSP for this Neovim instance" })
    end,
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
      local utils = require("utils")
      local capabilities = utils.setup_capabilities({})
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      vim.lsp.config("*", { capabilities = capabilities })
      vim.lsp.config("gopls", {
        settings = {
          gopls = {
            completeUnimported = true,
            usePlaceholders = true,
          },
        },
      })

      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "gopls" },
        automatic_enable = true,
      })
    end,
  },
}
