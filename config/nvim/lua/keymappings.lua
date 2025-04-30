local utils = require("utils")

local map = utils.map

-- Tab Shortcuts
map("n", "tf", ":tabfirst<CR>")
map("n", "tn", ":tabnext<CR>")
map("n", "tp", ":tabprev<CR>")
map("n", "tl", ":tablast<CR>")
map("n", "tt", ":tabnew<CR>")
map("n", "tx", ":tabclose<CR>")

-- LSP
map("n", "K", vim.lsp.buf.hover)
map("n", "gp", function () vim.diagnostic.jump({ count = -1, float = true }) end)
map("n", "gn", function () vim.diagnostic.jump({ count = 1, float = true }) end)
map("n", "<C-W>d", vim.diagnostic.open_float)
map("n", "go", vim.lsp.buf.type_definition)
map("n", "gD", vim.lsp.buf.declaration)
map("n", "<C-]>", vim.lsp.buf.definition)
map("n", "grn", vim.lsp.buf.rename)
map("n", "gra", vim.lsp.buf.code_action)
map("n", "grr", vim.lsp.buf.references)
map("n", "gri", vim.lsp.buf.implementation)
map("n", "gO", vim.lsp.buf.document_symbol)
map("n", "<C-S>", vim.lsp.buf.signature_help)
map("n", "gaf", function() vim.lsp.buf.format({ async = true }) end)

-- Organize imports
-- Temporary for go files, until I find a better solution
local organize_imports = function()
  vim.lsp.buf.code_action(
    {
      filter = function(a)
        return string.find(a.title, "Organize")
      end,
      apply = true
    }
  )
end
vim.api.nvim_create_user_command("OrganizeImport", organize_imports, {})
map("n", "<C-O>", ":OrganizeImport<CR>")

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

map("n", "<C-Space>", ":ApplyImport<CR>")

-- Easy splits
map("n", "vv", "<C-w>v")
map("n", "ss", "<C-w>s")
map("n", "<leader>-", ":wincmd _<cr>:wincmd |<CR>")
map("n", "<leader>=", ":wincmd =<cr>")
map("n", "<leader><leader>", "<C-^>")

vim.cmd('com! FormatJSON :%!jq \'.\'')
vim.cmd('com! MinifyJSON :%!jq -c \'.\'')

-- Colorizer
map("n", "<leader>ct", ":ColorizerToggle<CR>")

-- RenderMarkdown
map("n", "<leader>rmt", ":RenderMarkdown toggle<CR>")
