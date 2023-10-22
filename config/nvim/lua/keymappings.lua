local map = function(mode, key, command, opts)
  local merged_opts = vim.tbl_deep_extend('force', { noremap = true, silent = true }, opts or {})
  vim.api.nvim_set_keymap(mode, key, command, merged_opts)
end

-- Tab Shortcuts
map('n', 'tf', ':tabfirst<CR>')
map('n', 'tn', ':tabnext<CR>')
map('n', 'tp', ':tabprev<CR>')
map('n', 'tl', ':tablast<CR>')
map('n', 'tt', ':tabnew<CR>')
map('n', 'tx', ':tabclose<CR>')

-- LSP
map('n', 'K', ':lua vim.lsp.buf.hover()<CR>')
map('n', '[d', ':lua vim.diagnostic.goto_prev()<CR>')
map('n', ']d', ':lua vim.diagnostic.goto_next()<CR>')
map('n', 'gl', ':lua vim.diagnostic.open_float()<CR>')
map('n', 'gs', ':lua vim.lsp.buf.signature_help()<CR>')
map('n', 'gr', ':lua vim.lsp.buf.references()<CR>')
map('n', 'go', ':lua vim.lsp.buf.type_definition()<CR>')
map('n', 'gi', ':lua vim.lsp.buf.implementation()<CR>')
map('n', 'gD', ':lua vim.lsp.buf.declaration()<CR>')
map('n', 'gd', ':lua vim.lsp.buf.definition()<CR>')
map('n', '<leader>lc', ':lua vim.lsp.buf.code_action()<CR>')
map('n', '<leader>la', ':lua vim.lsp.buf.format({async = true})<CR>')
map('n', '<leader>lr', ':lua vim.lsp.buf.rename()<CR>')

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

map('n', '<C-Space>', ':ApplyImport<CR>')

-- map('n', '<C-u>', '<cmd>call smoothie#do("zz")<CR><cmd>call smoothie#do("\\<C-u>")<CR>')
-- map('n', '<C-d>', '<cmd>call smoothie#do("zz")<CR><cmd>call smoothie#do("\\<C-d>")<CR>')

-- Easy splits
map('n', 'vv', '<C-w>v')
map('n', 'ss', '<C-w>s')
map('n', '<leader>-', ':wincmd _<cr>:wincmd |<CR>')
map('n', '<leader>=', ':wincmd =<cr>')
map('n', '<leader><leader>', '<C-^>')

vim.cmd('com! FormatJSON :%!jq \'.\'')
vim.cmd('com! MinifyJSON :%!jq -c \'.\'')

-- Colorizer
map('n', '<leader>ct', ':ColorizerToggle<CR>')
