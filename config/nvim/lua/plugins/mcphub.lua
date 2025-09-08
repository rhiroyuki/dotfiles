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
        extensions = {
            codecompanion = {
                show_result_in_chat = true,
                make_vars = true,
                make_slash_commands = true,
            }
        }
      })
    end,
  }
}
