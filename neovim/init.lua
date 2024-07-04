
local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap
keymap("i", "jj", "<ESC>", opts)
vim.api.nvim_create_user_command('Black', 'silent !black -q %', {})
