return {
  {
    'saghen/blink.compat',
    version = '2.*',
    lazy = true,
    opts = {},
  },
  {
    'giuxtaposition/blink-cmp-copilot',
  },
  {
    'saghen/blink.cmp',
    dependencies = {
      'rafamadriz/friendly-snippets',
      'giuxtaposition/blink-cmp-copilot',
    },
    version = '1.*',
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = 'super-tab',
        ['<C-n>'] = {
          function(cmp)
            if cmp.is_visible() then
              return cmp.select_next()
            end
            return cmp.show()
          end,
          'show'
        },
      },
      appearance = {
        nerd_font_variant = 'mono'
      },
      completion = {
        menu = {
          draw = {
            treesitter = { 'lsp' },
            columns = {
              {
                'label',
                'label_description',
                gap = 1,
              },
              {
                -- "kind_icon",
                'kind',
              },
            }
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        ghost_text = {
          enabled = true,
        },
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', 'copilot' },
        providers = {
          copilot = {
            name = 'copilot',
            module = 'blink-cmp-copilot',
            score_offset = 100,
            async = true,
          },
        },
      },
      fuzzy = { implementation = 'prefer_rust_with_warning' }
    },
    opts_extend = { 'sources.default' }
  }
}
