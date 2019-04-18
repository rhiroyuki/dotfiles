if has_key(g:plugs, 'vim-ripgrep')
  let g:rg_window_location = 'bot'

  nnoremap <leader>rg :Rg <cword><cr>
endif
