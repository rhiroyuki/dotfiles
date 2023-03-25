return {
  'lukas-reineke/indent-blankline.nvim',
  config = function()
    vim.g.indent_guides_auto_colors = 0

    require('indent_blankline').setup {
      char = "",
      char_highlight_list = {
        'IndentGuidesOdd',
        'IndentGuidesEven',
      },
      space_char_highlight_list = {
        'IndentGuidesOdd',
        'IndentGuidesEvent',
      },
      show_trailing_blankline_indent = false,
    }
  end
}
