vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.cmd("filetype plugin off")
vim.g.have_nerd_font = true -- change later when you figure out wtf this impacts

require("colors.nightfox")
require("colors.rose_pine")
vim.cmd.colorscheme("rose-pine-moon")

require("config.keybinds")
require("config.options")
require("plugins.mini")
require("plugins.auto_pairs")
require("plugins.blink_cmp")
require("plugins.lsp")
