let is_tmux = $TMUX

if is_tmux != ""
  autocmd VimEnter * VtrAttachToPane
endif

