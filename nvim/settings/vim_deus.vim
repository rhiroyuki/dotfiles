if has_key(g:plugs, 'vim-deus')
  set background=dark
  try
    colorscheme deus
  catch
    colorscheme default
  endtry
  " let g:lightline.colorscheme = 'onedark'
endif
