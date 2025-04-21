local M = {}

--- Maps a keybinding in Neovim.
--- 
--- This function simplifies the process of setting key mappings by merging
--- default options with user-provided options and calling `vim.api.nvim_set_keymap`.
---
--- @param mode string: The mode in which the keybinding is active (e.g., "n", "i", "v").
--- @param key string: The key or key combination to map.
--- @param command string|function: The command or Lua function to execute when the key is pressed.
--- @param opts table|nil: A table of options for the keymap (optional).
M.map = function(mode, key, command, opts)
  local merged_opts = vim.tbl_deep_extend("force", { noremap = true, silent = true }, opts or {})
  vim.keymap.set(mode, key, command, merged_opts)
end

return M
