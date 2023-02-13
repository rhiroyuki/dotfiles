if packer_plugins["telescope.nvim"] and packer_plugins["telescope.nvim"].loaded then
	local builtin = require('telescope.builtin')

	vim.keymap.set('n', '<C-p>', builtin.find_files, {})
	vim.keymap.set('n', '<leader>h', builtin.oldfiles, {})
end
