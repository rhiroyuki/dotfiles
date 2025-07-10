return {
  {
    'ravitemer/mcphub.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    build = 'bundled_build.lua',
    config = function()
      require('mcphub').setup({
        use_bundled_binary = true,
      })
    end,
  }
}
