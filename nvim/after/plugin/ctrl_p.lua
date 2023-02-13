if packer_plugins["ctrlp.vim"] and packer_plugins["ctrlp.vim"].loaded then
  if vim.fn.executable('rg') then
    vim.opt.grepprg = 'rg\\ --color=never'
    vim.g.ctrl_p_user_command = 'rg %s --files --color=never --glob \"\"'
    vim.g.ctrlp_use_caching = 0
    vim.g.ctrp_follow_symlinks = 1
  end

  vim.g.ctrl_match_current_file = 1

  vim.keymap.set('n', '<Leader>h', ':CtrlPMRU<cr>')
end
