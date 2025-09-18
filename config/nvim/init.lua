require("config.options")

require("core.lazy")

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    require("config.keymaps")
  end,
})

require("config.autocmds")
