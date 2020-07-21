if has_key(g:plugs, 'nord-vim')
  let g:nord_italic=1
  let g:nord_italic_comments = 1
  let g:nord_bold_vertical_split_line = 1

  colorscheme nord

"   try
"     colorscheme nord
"   catch
"     colorscheme gruvbox
"   endtry
endif
