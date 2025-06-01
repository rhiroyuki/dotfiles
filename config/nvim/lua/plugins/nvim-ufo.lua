return {
  {
    'kevinhwang91/nvim-ufo',
    dependencies = {
      { 'kevinhwang91/promise-async' }
    },
    event = "VeryLazy",
    config = function()
      require('ufo').setup()

      vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
    end
  }
}
