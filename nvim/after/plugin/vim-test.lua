if packer_plugins["vim-test"] and packer_plugins["vim-test"].loaded then
  vim.keymap.set('n', '<leader>rs', ':TestFile<cr>')
  vim.keymap.set('n', '<leader>rn', ':TestNearest<cr>')
  vim.keymap.set('n', '<leader>rl', ':TestLast<cr>')
  vim.keymap.set('n', '<leader>ra', ':TestSuite<cr>')
  vim.keymap.set('n', '<leader>rj', ':TestVisit<cr>')

  vim.g['test#strategy'] = 'vtr'
end
