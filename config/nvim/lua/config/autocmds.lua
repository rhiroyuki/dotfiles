local function open_nvim_tree()
  local directory = vim.fn.isdirectory(vim.api.nvim_buf_get_name(0)) == 1

  if not directory then
    return
  end

  vim.schedule(function()
    vim.cmd("NvimTreeFindFileToggle")
  end)
end

vim.api.nvim_create_autocmd("User", { pattern = "NvimTreeLoaded", callback = open_nvim_tree })

vim.api.nvim_create_autocmd("User", {
  pattern = "BlinkCmpMenuOpen",
  callback = function()
    vim.b.copilot_suggestion_hidden = true
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "BlinkCmpMenuClose",
  callback = function()
    vim.b.copilot_suggestion_hidden = false
  end,
})
