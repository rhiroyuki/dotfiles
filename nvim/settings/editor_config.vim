if has_key(g:plugs, 'editorconfig-vim')
  "Compatibility editorconfig and timpope fugitive
  let g:EditorConfig_exclude_patterns = ['fugitive://.*']
endif
