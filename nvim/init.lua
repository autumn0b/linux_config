vim.cmd("filetype plugin off")

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true -- change later when you figure out wtf this impacts

require("colors.nightfox")
vim.cmd.colorscheme "duskfox"

require("config.keybinds")
require("config.options")
require("plugins.mini")
require("plugins.auto_pairs")
require("plugins.blink_cmp")
-- lsp
-- telescope
-- treesitter
