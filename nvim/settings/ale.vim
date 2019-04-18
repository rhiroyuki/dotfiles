if has_key(g:plugs, 'ale')
  let g:ale_linters = {
        \'jsx': ['stylelint', 'eslint'],
        \'ruby': ['standard', 'reek']
        \}
  let g:ale_linter_aliases = { 'jsx': 'css' }
  let g:ale_fixers = { 'javascript': ['eslint'] }
  let g:ale_completion_enabled = 0
endif
