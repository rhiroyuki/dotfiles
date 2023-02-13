if packer_plugins["telescope.nvim"] and packer_plugins["telescope.nvim"].loaded then
  local actions = require('telescope.actions')

  require('telescope').setup({
      defaults = {
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
          }
        }
      }
    })

  local builtin = require('telescope.builtin')

  vim.keymap.set('n', '<C-p>', builtin.find_files, { noremap = true })
  vim.keymap.set('n', '<leader>h', builtin.oldfiles, { noremap = true })
end
