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

-- File formatting
-- require("syntax.pebl")
-- Colorschemes
-- require("petl").setup()
-- vim.cmd.colorscheme "petl"
-- vim.cmd.colorscheme "rose-pine-dawn"

vim.cmd.colorscheme "duskfox"
