return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "RRethy/nvim-treesitter-endwise",
      "nvim-treesitter/nvim-treesitter-textobjects"
    },
    build = ":TSUpdate",
    event = "VeryLazy",
    config = function()
      require("nvim-treesitter.configs").setup({
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = { query = "@function.outer", desc = "Around Function" },
              ["if"] = { query = "@function.inner", desc = "Inside Function" },
              ["ac"] = { query = "@class.outer", desc = "Around class" },
              ["ic"] = { query = "@class.inner", desc = "Inner class" },
              ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
              ["ib"] = { query = "@block.inner", desc = "Inside block" },
              ["ab"] = { query = "@block.outer", desc = "Around block" }
            },
            selection_modes = {
              ["@parameter.outer"] = "v",
              ["@function.outer"] = "V",
              ["@class.outer"] = "<c-v>",
            },
            include_surrounding_whitespace = false,
          },
          -- swap = {
          --   enable = true,
          --   swap_next = {
          --     ["<leader>a"] = "@parameter.inner",
          --   },
          --   swap_previous = {
          --     ["<leader>A"] = "@parameter.inner",
          --   },
          -- },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = { query = "@class.outer", desc = "Next class start" },
              ["]b"] = { query = "@block.outer", desc = "Next block" },
              -- ["]o"] = "@loop.*",
              ["]o"] = { query = { "@loop.inner", "@loop.outer" } },
              ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
              ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
              ["]B"] = "@block.outer"
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
              ["[b"] = "@block.outer"
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
              ["[B"] = "@block.outer"
            },
            goto_next = {
              ["]d"] = "@conditional.outer",
            },
            goto_previous = {
              ["[d"] = "@conditional.outer",
            }
          },
        },
        ensure_installed = {
          "ruby",
        },
        auto_install = true,
        endwise = {
          enable = true,
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false
        }
      })
    end
  }
}
