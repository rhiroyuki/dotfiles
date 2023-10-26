local M = {}

M.map = function(mode, key, command, opts)
  local merged_opts = vim.tbl_deep_extend("force", { noremap = true, silent = true }, opts or {})
  vim.api.nvim_set_keymap(mode, key, command, merged_opts)
end

return M
