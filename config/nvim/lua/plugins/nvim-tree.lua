return {
  "nvim-tree/nvim-tree.lua",
  event = "VeryLazy",
  cmd = { "NvimTreeToggle" },
  config = function()
    local function on_attach(bufnr)
      local api = require("nvim-tree.api")
      local map = require("utils").map

      local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      api.config.mappings.default_on_attach(bufnr)

      map("n", "u", api.tree.change_root_to_parent, opts("Up"))
    end

    require("nvim-tree").setup({
      on_attach = on_attach,
      sort_by = "case_sensitive",
      view = {
        adaptive_size = true,
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

    vim.cmd("doautocmd User NvimTreeLoaded")
  end
}
