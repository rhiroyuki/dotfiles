if has_key(g:plugs, 'lightline.vim')
  let g:lightline = {
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ], [ 'readonly', 'relativepath', 'modified' ] ]
        \ },
        \ 'colorscheme': 'gruvbox'
        \ }
endif