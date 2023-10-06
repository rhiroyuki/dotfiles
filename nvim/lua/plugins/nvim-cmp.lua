return {
  { 'hrsh7th/cmp-nvim-lsp-signature-help' },
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      { 'L3MON4D3/LuaSnip' },
    },
    config = function()
      local cmp = require('cmp')

      local select_opts = { behavior = cmp.SelectBehavior.Select }

      local cmp_config = {
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        mapping = {
          ['<CR>'] = cmp.mapping.confirm({ select = false }),
          ['<C-p>'] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_prev_item(select_opts)
            else
              cmp.complete()
            end
          end),
          ['<C-n>'] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_next_item(select_opts)
            else
              cmp.complete()
            end
          end),
        },
        formatting = {
          fields = { 'abbr', 'menu', 'kind' },
          format = function(entry, item)
            local short_name = {
              nvim_lsp = 'LSP',
              nvim_lua = 'nvim'
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
          { name = 'copilot',                keyword_length = 0 },
          { name = 'nvim_lsp_signature_help' },
          { name = 'nvim_lsp' },
        }
      }

      cmp.setup(cmp_config)
    end
  },
}
