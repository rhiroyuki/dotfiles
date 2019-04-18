if has_key(g:plugs, 'vim-tmux-runner')
  let is_tmux = $TMUX

  if is_tmux != ""
    autocmd VimEnter * VtrAttachToPane
  endif
endif
