vim.cmd("filetype plugin off")

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

-- General Neovim API config
require("config.remap")
require("config.options")

-- Plugins
require("config.lazy")          -- Community
require("personal.notepad")     -- Personal
require("personal.diagnostics") -- Personal

vim.cmd.colorscheme "duskfox"
