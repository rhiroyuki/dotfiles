if has_key(g:plugs, 'vim-test')
  " vim-test mappings
  nnoremap <Leader>rs :TestFile<CR>
  nnoremap <Leader>rn :TestNearest<CR>
  nnoremap <Leader>rl :TestLast<CR>
  nnoremap <Leader>ra :TestSuite<CR>
  nnoremap <Leader>rj :TestVisit<CR>

  " vim-test send tests to vim tmux runner
  let test#strategy = 'vtr'
endif
