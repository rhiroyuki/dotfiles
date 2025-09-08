vim.cmd('com! FormatJSON :%!jq \'.\'')
vim.cmd('com! MinifyJSON :%!jq -c \'.\'')

local map = require("utils").map

-- LSP
map("n", "gp", function () vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Previous diagnostic" })
map("n", "gn", function () vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next diagnostic" })
map("n", "gaf", function() vim.lsp.buf.format({ async = true }) end, { desc = "Format file" })
map("n", "K", vim.lsp.buf.hover,                         { desc = "LSP Hover" })
map("n", "<C-W>d", vim.diagnostic.open_float,            { desc = "Show diagnostic float" })
map("n", "go", vim.lsp.buf.type_definition,              { desc = "Go to type definition" })
map("n", "gD", vim.lsp.buf.declaration,                  { desc = "Go to declaration" })
map("n", "<C-]>", vim.lsp.buf.definition,                { desc = "Go to definition" })
map("n", "grn", vim.lsp.buf.rename,                      { desc = "LSP Rename" })
map("n", "gra", vim.lsp.buf.code_action,                 { desc = "LSP Code Action" })
map("n", "grr", vim.lsp.buf.references,                  { desc = "LSP References" })
map("n", "gri", vim.lsp.buf.implementation,              { desc = "Go to implementation" })
map("n", "gO", vim.lsp.buf.document_symbol,              { desc = "Document symbols" })
map("n", "<C-S>", vim.lsp.buf.signature_help,            { desc = "Signature help" })

-- Tab Shortcuts
map("n", "tf", ":tabfirst<CR>",                          { desc = "Go to first tab"    } )
map("n", "tn", ":tabnext<CR>",                           { desc = "Go to next tab"     } )
map("n", "tp", ":tabprev<CR>",                           { desc = "Go to previous tab" } )
map("n", "tl", ":tablast<CR>",                           { desc = "Go to last tab"     } )
map("n", "tt", ":tabnew<CR>",                            { desc = "Open new tab"       } )
map("n", "tx", ":tabclose<CR>",                          { desc = "Close current tab"  } )

-- Easy splits
map("n", "vv", "<C-w>v",                                 { desc = "Vertical split" })
map("n", "ss", "<C-w>s",                                 { desc = "Horizontal split" })
map("n", "<leader>-", ":wincmd _<cr>:wincmd |<CR>",      { desc = "Maximize split" })
map("n", "<leader>=", ":wincmd =<cr>",                   { desc = "Equalize splits" })
map("n", "<leader><leader>", "<C-^>",                    { desc = "Switch to alternate file" })

-- Colorizer
map("n", "<leader>ct", ":ColorizerToggle<CR>",           { desc = "Toggle Colorizer" })

-- RenderMarkdown
map("n", "<leader>rmt", ":RenderMarkdown toggle<CR>",    { desc = "Toggle RenderMarkdown" })

-- CodeCompanion Keymaps
map("n", "<leader>cca", ":CodeCompanionActions<CR>",     { desc = "CodeCompanion Actions" })
map("n", "<leader>ccp", ":CodeCompanion<CR>",            { desc = "Open CodeCompanion" })
map("n", "<leader>ccc", ":CodeCompanionChat Toggle<CR>", { desc = "Toggle CodeCompanion Chat" })

-- NvimTree Keymaps
map("n", '<C-\\>', ":NvimTreeFindFileToggle<CR>",        { desc = "Toggle NvimTree" })

-- Other.nvim Keymaps
map("n", "<leader>ll", "<cmd>:Other<CR>",                { desc = "Other" })
map("n", "<leader>ltn", "<cmd>:OtherTabNew<CR>",         { desc = "Other Tab New" })
map("n", "<leader>lp", "<cmd>:OtherSplit<CR>",           { desc = "Other Split" })
map("n", "<leader>lv", "<cmd>:OtherVSplit<CR>",          { desc = "Other VSplit" })
map("n", "<leader>lc", "<cmd>:OtherClear<CR>",           { desc = "Other Clear" })
map("n", "<leader>lt", "<cmd>:Other test<CR>",           { desc = "Other test" })
map("n", "<leader>ls", "<cmd>:Other scss<CR>",           { desc = "Other scss" })

-- Lazy Nvim keymaps
map("n", "<leader>lp", "<cmd>:Lazy profile<CR>",         { desc = "Lazy profile" })
map("n", "<leader>lu", "<cmd>:Lazy update<CR>",          { desc = "Lazy update" })

-- Organize imports
-- Temporary for go files, until I find a better solution
-- local organize_imports = function()
--   vim.lsp.buf.code_action(
--     {
--       filter = function(a)
--         return string.find(a.title, "Organize")
--       end,
--       apply = true
--     }
--   )
-- end
-- vim.api.nvim_create_user_command("OrganizeImport", organize_imports, {})
-- map("n", "<C-O>", ":OrganizeImport<CR>")

--- Applies an LSP code action that matches the word "import" in its title.
-- This function filters available code actions provided by the LSP client,
-- selecting only those whose title contains the word "import", and then
-- automatically applies the selected action.
local apply_import = function()
  vim.lsp.buf.code_action(
    {
      filter = function(a)
        return string.find(a.title, "import")
      end,
      apply = true
    }
  )
end

vim.api.nvim_create_user_command("ApplyImport", apply_import, {})

map("n", "<C-Space>", ":ApplyImport<CR>", { desc = "Apply import code action" })

map("n", "<Space>bg", ":suspend<CR>", { desc = "Suspend Neovim" })
