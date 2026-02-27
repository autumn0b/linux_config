-- System clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

vim.keymap.set("n", "<leader>p", "\"+p")
vim.keymap.set("v", "<leader>p", "\"+p")

-- Cursor becomes vertically centered.
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Search word is centered.
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")

-- <Esc> clears search highlight.
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")


-- Diagnostic keymaps.
--   <leader>ef : [e]rror [f]loating window
--   [e]rrors [a]ll
vim.keymap.set("n", "<leader>ea", vim.diagnostic.setloclist)
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>")

-- Navigate between window panes.
vim.keymap.set("n", "<C-h>", "<C-w><C-h>")
vim.keymap.set("n", "<C-l>", "<C-w><C-l>")
vim.keymap.set("n", "<C-j>", "<C-w><C-j>")
vim.keymap.set("n", "<C-k>", "<C-w><C-k>")

-- Buffers
vim.keymap.set("n", "<leader>d", function()
	MiniFiles.open(vim.api.nvim_buf_get_name(0), true)
	-- MiniFiles.open(MiniFiles.get_latest_path())
end)
vim.keymap.set("n", "<leader>q", "<cmd>bd<cr>")
vim.keymap.set("n", "<leader>Q", "<cmd>bd!<cr>")


-- Tabline navigation
vim.keymap.set("n", "<leader>,", "<cmd>bp<cr>")
vim.keymap.set("n", "<leader>.", "<cmd>bn<cr>")

-- Easy tables
--   [t]able [n]ew
vim.keymap.set("n", "<leader>tn", ":EasyTablesCreateNew ")
--   [t]able [e]dit
vim.keymap.set("n", "<leader>te", ":EasyTablesImportThisTable ")

-- [a]uto_[s]ave toggle
vim.api.nvim_set_keymap("n", "<leader>as", ":ASToggle<cr>", {})


-- <leader>gd : [g]oto [d]efinition
-- <leader>gr : [g]oto [r]eferences
-- <leader>fd : [s]earch [d]ocument symbols
-- <leader>fw : [s]earch [w]orkspace symbols
-- <leader>rn : [r]e [n]ame

-- auto_complete
--   <down>    : [n]ext item.
--   <up>      : [p]revious item.
--   <C-right> : accept the item
--   (?) <C-left> : manually trigger auto_cmp
--
--   <C-b> : scroll [b]ack in the documentation window
--   <C-f> : scroll [f]orward in the documentation window

-- Telescope directory search
--   <leader>sf : [s]earch all [f]iles
--   <leader>sn : [s]earch [notes]
--   <leader>sc : [s]earch [c]ode
--   <leader>sv : [s]earch neo[v]im config


-- LSP
--   <leader>lh : [L]SP Inlay [H]ints
