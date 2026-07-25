return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    dependencies = {
      "RRethy/nvim-treesitter-endwise",
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
      },
    },
    build = ":TSUpdate",
    lazy = false,
    config = function()
      require("nvim-treesitter").install({ "ruby" })

      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })

      require("nvim-treesitter-textobjects").setup({
        select = {
          lookahead = true,
          selection_modes = {
            ["@parameter.outer"] = "v",
            ["@function.outer"] = "V",
            ["@class.outer"] = "<c-v>",
          },
          include_surrounding_whitespace = false,
        },
        move = {
          set_jumps = true,
        },
      })

      local select = require("nvim-treesitter-textobjects.select")
      local move = require("nvim-treesitter-textobjects.move")
      local map = require("utils").map

      -- Select
      map({ "x", "o" }, "af", function() select.select_textobject("@function.outer", "textobjects") end, { desc = "Around Function" })
      map({ "x", "o" }, "if", function() select.select_textobject("@function.inner", "textobjects") end, { desc = "Inside Function" })
      map({ "x", "o" }, "ac", function() select.select_textobject("@class.outer", "textobjects") end, { desc = "Around class" })
      map({ "x", "o" }, "ic", function() select.select_textobject("@class.inner", "textobjects") end, { desc = "Inner class" })
      map({ "x", "o" }, "as", function() select.select_textobject("@local.scope", "locals") end, { desc = "Select language scope" })
      map({ "x", "o" }, "ib", function() select.select_textobject("@block.inner", "textobjects") end, { desc = "Inside block" })
      map({ "x", "o" }, "ab", function() select.select_textobject("@block.outer", "textobjects") end, { desc = "Around block" })

      -- Move: next start
      map({ "n", "x", "o" }, "]m", function() move.goto_next_start("@function.outer", "textobjects") end, { desc = "Next function start" })
      map({ "n", "x", "o" }, "]]", function() move.goto_next_start("@class.outer", "textobjects") end, { desc = "Next class start" })
      map({ "n", "x", "o" }, "]b", function() move.goto_next_start("@block.outer", "textobjects") end, { desc = "Next block" })
      map({ "n", "x", "o" }, "]o", function() move.goto_next_start({ "@loop.inner", "@loop.outer" }, "textobjects") end, { desc = "Next loop" })
      map({ "n", "x", "o" }, "]s", function() move.goto_next_start("@local.scope", "locals") end, { desc = "Next scope" })
      map({ "n", "x", "o" }, "]z", function() move.goto_next_start("@fold", "folds") end, { desc = "Next fold" })

      -- Move: next end
      map({ "n", "x", "o" }, "]M", function() move.goto_next_end("@function.outer", "textobjects") end, { desc = "Next function end" })
      map({ "n", "x", "o" }, "][", function() move.goto_next_end("@class.outer", "textobjects") end, { desc = "Next class end" })
      map({ "n", "x", "o" }, "]B", function() move.goto_next_end("@block.outer", "textobjects") end, { desc = "Next block end" })

      -- Move: previous start
      map({ "n", "x", "o" }, "[m", function() move.goto_previous_start("@function.outer", "textobjects") end, { desc = "Previous function start" })
      map({ "n", "x", "o" }, "[[", function() move.goto_previous_start("@class.outer", "textobjects") end, { desc = "Previous class start" })
      map({ "n", "x", "o" }, "[b", function() move.goto_previous_start("@block.outer", "textobjects") end, { desc = "Previous block" })

      -- Move: previous end
      map({ "n", "x", "o" }, "[M", function() move.goto_previous_end("@function.outer", "textobjects") end, { desc = "Previous function end" })
      map({ "n", "x", "o" }, "[]", function() move.goto_previous_end("@class.outer", "textobjects") end, { desc = "Previous class end" })

      -- Move: directional (goto closest)
      map({ "n", "x", "o" }, "]d", function() move.goto_next("@conditional.outer", "textobjects") end, { desc = "Next conditional" })
      map({ "n", "x", "o" }, "[d", function() move.goto_previous("@conditional.outer", "textobjects") end, { desc = "Previous conditional" })
    end,
  },
}
