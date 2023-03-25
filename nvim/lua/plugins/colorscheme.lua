return {
  {
    'ajmwagar/vim-deus',
    priority = 1000,
    config = function()
      vim.opt.background = 'dark'
      vim.cmd.colorscheme('deus')
    end
  },
  'ajmwagar/lightline-deus',
  'itchyny/lightline.vim'
}
