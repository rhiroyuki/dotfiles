let vimsettings = '~/.vim/settings'

let NERDTreeQuitOnOpen=1
for fpath in split(globpath(vimsettings, '*.vim'), '\n')
  exe 'source' fpath
endfor
