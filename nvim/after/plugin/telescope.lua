if packer_plugins["telescope.nvim"] and packer_plugins["telescope.nvim"].loaded then
	local builtin = require('telescope.builtin')

	vim.keymap.set('n', '<C-p>', builtin.find_files, {})
end
