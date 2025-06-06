return {
  { "saadparwaiz1/cmp_luasnip", lazy = true, event = "InsertEnter" },
  { "hrsh7th/cmp-nvim-lsp-signature-help", lazy = true, event = "InsertEnter" },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    lazy = true,
    dependencies = {
      { "L3MON4D3/LuaSnip" },
      { "saadparwaiz1/cmp_luasnip" },
      { "hrsh7th/cmp-nvim-lsp-signature-help" },
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local cmp_config = {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = {
          ["<C-b>"] = cmp.mapping.scroll_docs(-3),
          ["<C-f>"] = cmp.mapping.scroll_docs(3),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<CR>"] = function(fallback)
            if cmp.visible() and cmp.get_selected_entry() then
              cmp.confirm({ select = false })
            else
              fallback()
            end
          end,
          ["<C-p>"] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_prev_item()
            else
              cmp.complete()
            end
          end),
          ["<C-n>"] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_next_item()
            else
              cmp.complete()
            end
          end),
          ["<Esc>"] = function(fallback)
            if cmp.get_selected_entry() then
              cmp.abort()
            else
              fallback()
            end
          end
        },
        formatting = {
          fields = { "abbr", "menu", "kind" },
          format = function(entry, item)
            local short_name = {
              nvim_lsp = "LSP",
              nvim_lua = "nvim"
            }

            local menu_name = short_name[entry.source.name] or entry.source.name

            item.menu = string.format('[%s]', menu_name)
            return item
          end,
        },
        window = {
          documentation = {
            max_height = 15,
            max_width = 60,
          }
        },
        sources = {
          { name = "copilot",                keyword_length = 0 },
          { name = "nvim_lsp_signature_help" },
          { name = "nvim_lsp" },
          { name = "codecompanion" },
          { name = "luasnip" },
        },
        experimental = {
          ghost_text = true
        }
      }

      cmp.event:on(
        "confirm_done",
        cmp_autopairs.on_confirm_done()
      )

      cmp.setup(cmp_config)
    end
  },
  {
    "hrsh7th/cmp-nvim-lsp",
    lazy = true,
    event = "InsertEnter",
  },
}
