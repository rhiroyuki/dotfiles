if has_key(g:plugs, 'ctrlp.vim') 
  if executable('rg')
    " https://elliotekj.com/posts/2016/11/22/setup-ctrlp-to-use-ripgrep-in-vim/
    " note that ripgrep uses .gitignore instead of wildignore
    set grepprg=rg\ --color=never
    let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
    let g:ctrlp_use_caching = 0
  endif

  let g:ctrlp_match_current_file = 1

  nnoremap <Leader>h :CtrlPMRU<CR>
endif
