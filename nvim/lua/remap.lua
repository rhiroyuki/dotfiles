-- Tab Shortcuts
vim.g.mapleader = ' '

vim.keymap.set('n', 'tf', ':tabfirst<cr>')
vim.keymap.set('n', 'tn', ':tabnext<cr>')
vim.keymap.set('n', 'tp', ':tabprev<cr>')
vim.keymap.set('n', 'tl', ':tablast<cr>')
vim.keymap.set('n', 'tt', ':tabnew<cr>')
vim.keymap.set('n', 'tx', ':tabclose<cr>')

-- " Manage Vim config more easily
vim.keymap.set('n', '<leader>ve', ':vsplit $MYVIMRC<cr>')
vim.keymap.set('n', '<leader>vr', ':source $MYVIMRC<cr>')

--" " Easy splits
vim.keymap.set('n', 'vv', '<C-w>v')
vim.keymap.set('n', 'ss', '<C-w>s')

vim.keymap.set('n', '<leader>-', ':wincmd _<cr>:wincmd \\|<cr>')
-- " nnoremap <Leader>- :wincmd _<cr>:wincmd \|<cr>
vim.keymap.set('n', '<leader>=', ':wincmd =<cr>')
-- " nnoremap <Leader>= :wincmd =<cr>
vim.keymap.set('n', '<leader><leader>', '<C-^>')
-- " nnoremap <leader><leader> <C-^>
vim.keymap.set('n', '0', '^')
-- " nnoremap 0 ^

-- com! FormatJSON :%!jq '.'
-- com! MinifyJSON :%!jq -c '.'
-- nnoremap <C-f> :Rg!<cr>
-- inoremap <S-Tab> <C-d>
