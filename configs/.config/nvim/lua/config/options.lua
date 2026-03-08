vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"

-- Indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 0
vim.opt.softtabstop = 0
vim.opt.expandtab = false
vim.opt.smarttab = false

-- Formatting
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakat = " "
vim.opt.breakindent = true
vim.opt.formatoptions = ""

-- Enable mouse mode.
vim.opt.mouse = "a"

-- Sync clipboard between OS and Neovim.
vim.schedule(function()
	vim.opt.clipboard = "unnamed"
end)

vim.opt.undofile = true

-- Searching
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Highlight when yanking
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.opt.termguicolors = true

vim.opt.scrolloff = 8

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

vim.opt.list = true
vim.opt.listchars = { tab = "│ ", lead = "·", trail = "·", multispace = " ", nbsp = "␣" }

vim.opt.inccommand = "split"

-- Line highlighting
vim.opt.cursorline = false
