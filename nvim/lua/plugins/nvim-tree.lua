return {
  'nvim-tree/nvim-tree.lua',
  config = function()
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

    local function open_nvim_tree(data)

      -- buffer is a directory
      local directory = vim.fn.isdirectory(data.file) == 1

      if not directory then
        return
      end

      -- change to the directory
      vim.cmd.cd(data.file)

      -- open the tree
      require("nvim-tree.api").tree.open()
    end

    vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

    vim.keymap.set('n', '<C-\\>', ':NvimTreeFindFileToggle<cr>', { noremap = true, silent = true })
  end
}
