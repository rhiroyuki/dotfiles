if packer_plugins["nvim-tree.lua"] and packer_plugins["nvim-tree.lua"].loaded then
  require("nvim-tree").setup({
    sort_by = "case_sensitive",
    view = {
      adaptive_size = true,
      mappings = {
        list = {
          { key = "u", action = "dir_up" },
        },
      },
    },
    actions = {
      open_file = {
        quit_on_open = true,
      },
    },
    renderer = {
      group_empty = true,
      icons = {
        show = {
          file = false,
          folder = false,
          folder_arrow = false,
          git = false,
          }
        }
    },
    filters = {
      dotfiles = true,
    },
  })

  vim.api.nvim_create_autocmd("BufEnter", {
    nested = true,
    callback = function()
      if #vim.api.nvim_list_wins() == 1 and require("nvim-tree.utils").is_nvim_tree_buf() then
        vim.cmd "quit"
      end
    end
  })

  vim.keymap.set('n', '<C-\\>', ':NvimTreeFindFileToggle<cr>')
end
