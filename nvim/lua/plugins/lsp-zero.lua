return {
  {'hrsh7th/nvim-cmp'},
  {'hrsh7th/cmp-nvim-lsp'},
  {'neovim/nvim-lspconfig'},
  {'williamboman/mason.nvim'},
  {'williamboman/mason-lspconfig.nvim'},
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v1.x',
    dependencies = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},             -- Required
      {'williamboman/mason.nvim'},           -- Optional
      {'williamboman/mason-lspconfig.nvim'}, -- Optional

      -- Autocompletion
      {'hrsh7th/nvim-cmp'},         -- Required
      {'hrsh7th/cmp-nvim-lsp'},     -- Required
      -- {'hrsh7th/cmp-buffer'},       -- Optional
      -- {'hrsh7th/cmp-path'},         -- Optional
      -- {'saadparwaiz1/cmp_luasnip'}, -- Optional
      -- {'hrsh7th/cmp-nvim-lua'},     -- Optional

      -- Snippets
      {'L3MON4D3/LuaSnip'},             -- Required
      -- {'rafamadriz/friendly-snippets'}, -- Optional
    },
    config = function()
      local lsp = require('lsp-zero').preset({
          name = 'minimal',
          set_lsp_keymaps = true,
          manage_nvim_cmp = true,
          suggest_lsp_servers = false,
        })

      -- (Optional) Configure lua language server for neovim
      lsp.nvim_workspace()

      -- Don't preselect first match
      lsp.setup_nvim_cmp({
        preselect = 'none',
        completion = {
          completeopt = 'menu,menuone,noinsert,noselect'
        },
      })

      lsp.setup()
    end
  }
}
