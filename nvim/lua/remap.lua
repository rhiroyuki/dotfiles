-- Only non-plugin dependent remaps
-- Tab Shortcuts
vim.keymap.set('n', 'tf', ':tabfirst<cr>', { noremap = true })
vim.keymap.set('n', 'tn', ':tabnext<cr>', { noremap = true })
vim.keymap.set('n', 'tp', ':tabprev<cr>', { noremap = true })
vim.keymap.set('n', 'tl', ':tablast<cr>', { noremap = true })
vim.keymap.set('n', 'tt', ':tabnew<cr>', { noremap = true })
vim.keymap.set('n', 'tx', ':tabclose<cr>', { noremap = true })

-- Manage Vim config more easily
vim.keymap.set('n', '<leader>ve', ':vsplit $MYVIMRC<cr>', { noremap = true })
vim.keymap.set('n', '<leader>vr', ':source $MYVIMRC<cr>', { noremap = true })

-- LSP
vim.keymap.set('n', 'K', ':lua vim.lsp.buf.hover()<CR>', { noremap = true })
vim.keymap.set('n', '[d', ':lua vim.diagnostic.goto_prev()<CR>', { noremap = true })
vim.keymap.set('n', ']d', ':lua vim.diagnostic.goto_next()<CR>', { noremap = true })
vim.keymap.set('n', 'gl', ':lua vim.diagnostic.open_float()<CR>', { noremap = true })
vim.keymap.set('n', 'gs', ':lua vim.lsp.buf.signature_help()<CR>', { noremap = true })
vim.keymap.set('n', 'gr', ':lua vim.lsp.buf.references()<CR>', { noremap = true })
vim.keymap.set('n', 'go', ':lua vim.lsp.buf.type_definition()<CR>', { noremap = true })
vim.keymap.set('n', 'gi', ':lua vim.lsp.buf.implementation()<CR>', { noremap = true })
vim.keymap.set('n', 'gD', ':lua vim.lsp.buf.declaration()<CR>', { noremap = true })
vim.keymap.set('n', 'gd', ':lua vim.lsp.buf.definition()<CR>', { noremap = true })
vim.keymap.set('n', '<leader>lc', ':lua vim.lsp.buf.code_action()<CR>', { noremap = true })
vim.keymap.set('n', '<leader>la', ':lua vim.lsp.buf.format({async = true})<CR>', { noremap = true })
vim.keymap.set('n', '<leader>lr', ':lua vim.lsp.buf.rename()<CR>', { noremap = true })

-- Easy splits
vim.keymap.set('n', 'vv', '<C-w>v', { noremap = true })
vim.keymap.set('n', 'ss', '<C-w>s', { noremap = true })
vim.keymap.set('n', '<leader>-', ':wincmd _<cr>:wincmd |<cr>', { noremap = true })
vim.keymap.set('n', '<leader>=', ':wincmd =<cr>', { noremap = true })
vim.keymap.set('n', '<leader><leader>', '<C-^>', { noremap = true })

vim.cmd('com! FormatJSON :%!jq \'.\'')
vim.cmd('com! MinifyJSON :%!jq -c \'.\'')
