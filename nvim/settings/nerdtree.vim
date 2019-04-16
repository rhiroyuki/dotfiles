" Make nerdtree look nice

let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrows = 1
let g:NERDTreeWinSize = 30
let g:NERDTreeQuitOnOpen=1

" Disable netrw since we are using nerdtree
let g:loaded_netrwPlugin = 1

function! NERDTreeFindToggle()
  if g:NERDTree.IsOpen()
    NERDTreeFind
    q
  else
    NERDTreeFind
  endif
endfunction

" Open the project tree and expose current file in the nerdtree with Ctrl-\
command! LocalNERDTreeToggle call NERDTreeFindToggle()
nnoremap <silent> <C-\> :LocalNERDTreeToggle<cr>
