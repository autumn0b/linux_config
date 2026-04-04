-- System clipboard
-- vim.keymap.set("n", "y", "\"+y")


-- <Esc> clears search highlight.
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Buffers
vim.keymap.set("n", "<leader>w", "<cmd>bd<cr>")
vim.keymap.set("n", "<leader>W", "<cmd>bd!<cr>")
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>")

-- Tabline navigation
vim.keymap.set("n", "<leader>,", "<cmd>bp<cr>")
vim.keymap.set("n", "<leader>.", "<cmd>bn<cr>")

--
vim.keymap.set("n", "<leader>cs", "<S-i>/* <esc><S-a> */<esc>_") -- [c]omment [s]tyles (css)
