vim.opt.swapfile = false

-- Left col
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"

-- Searching
vim.opt.ignorecase = true

-- Sync clipboard between OS and Neovim.
-- vim.schedule(function()
-- 	vim.opt.clipboard = "unnamed"
-- end)
vim.opt.clipboard = "unnamedplus"
-- Highlight when yanking
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

vim.opt.listchars = { tab = "│ ", lead = "·", trail = "·", multispace = " ", nbsp = "␣" }

-- Enable mouse mode.
vim.opt.mouse = "a"
