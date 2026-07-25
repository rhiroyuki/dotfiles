return {
  {
    'kevinhwang91/nvim-ufo',
    dependencies = {
      { 'kevinhwang91/promise-async' }
    },
    event = "VeryLazy",
    config = function()
      require('ufo').setup()

      local map = require("utils").map

      map('n', 'zR', require('ufo').openAllFolds, { desc = "Open all folds" })
      map('n', 'zM', require('ufo').closeAllFolds, { desc = "Close all folds" })
    end
  }
}
