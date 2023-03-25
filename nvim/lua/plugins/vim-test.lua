return {
  'janko-m/vim-test',
  config = function()
    vim.keymap.set('n', '<leader>rs', ':TestFile<cr>', { noremap = true })
    vim.keymap.set('n', '<leader>rn', ':TestNearest<cr>', { noremap = true })
    vim.keymap.set('n', '<leader>rl', ':TestLast<cr>', { noremap = true })
    vim.keymap.set('n', '<leader>ra', ':TestSuite<cr>', { noremap = true })
    vim.keymap.set('n', '<leader>rj', ':TestVisit<cr>', { noremap = true })

    vim.g['test#strategy'] = 'vtr'
  end
}
