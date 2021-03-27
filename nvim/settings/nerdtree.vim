if has_key(g:plugs, 'nerdtree')
  " Make nerdtree look nice
  let g:NERDTreeMinimalUI = 1
  let g:NERDTreeDirArrows = 1
  let g:NERDTreeWinSize = 30
  let g:NERDTreeQuitOnOpen=1

  " Disable nerdtree at vim startup ( `$vim .` )
  let g:NERDTreeHijackNetrw=0

  " Disable netrw since we are using nerdtree
  let g:loaded_netrwPlugin = 1

  function! NERDTreeFindToggle()
    if g:NERDTree.IsOpen()
      NERDTreeClose
    else
      NERDTreeFind
    endif
  endfunction

  " Open the project tree and expose current file in the nerdtree with Ctrl-\
  command! LocalNERDTreeToggle call NERDTreeFindToggle()
  nnoremap <silent> <C-\> :LocalNERDTreeToggle<cr>
else
  let g:netrw_banner       = 0
  let g:netrw_liststyle    = 3
  let g:netrw_winsize      = 18
  let g:netrw_browse_split = 0

  let g:NetrwIsOpen=0

  function! ToggleNetrw()
      if g:NetrwIsOpen
          let i = bufnr("$")
          while (i >= 1)
              if (getbufvar(i, "&filetype") == "netrw")
                  silent exe "bwipeout " . i 
              endif
              let i-=1
          endwhile
          let g:NetrwIsOpen=0
      else
          let g:NetrwIsOpen=1
          let current_filename=expand('%:t')
          silent Vexplore
          execute '/' . current_filename
          silent noh
      endif
  endfunction

  command! LocalNetrwToggle call ToggleNetrw()

  nnoremap <silent> <C-\> :LocalNetrwToggle<cr>
  autocmd FileType netrw setl bufhidden=delete
endif
