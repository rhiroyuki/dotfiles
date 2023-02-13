if packer_plugins["vim-tmux-navigator"] and packer_plugins["vim-tmux-navigator"].loaded then
  vim.keymap.set('n', '<C-h>', ':TmuxNavigateLeft<cr>', { noremap = true, silent = true })
  vim.keymap.set('n', '<C-j>', ':TmuxNavigateDown<cr>', { noremap = true, silent = true })
  vim.keymap.set('n', '<C-k>', ':TmuxNavigateUp<cr>', { noremap = true, silent = true })
  vim.keymap.set('n', '<C-l>', ':TmuxNavigateRight<cr>', { noremap = true, silent = true })

  -- don't let tmux zoom out if you try to go out of bounds
  vim.g.tmux_navigator_disable_when_zoomed = 1
 vim.g.tmux_navigator_no_mappings = 1
end
