if has_key(g:plugs, 'emmet-vim')
  " Emmet configurations
  " extends jsx and let it create jsx tags
  " example: <div className="popup"></div>
  let g:user_emmet_settings = {
        \  'javascript.jsx' : {
        \      'extends' : 'jsx',
        \  },
        \}

  autocmd FileType html,css,javascript.jsx,javascript EmmetInstall
endif
