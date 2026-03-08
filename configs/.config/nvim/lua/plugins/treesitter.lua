return { -- Highlight, edit, and navigate code
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	main = "nvim-treesitter.configs", -- Sets main module to use for opts
	-- [[ Configure Treesitter ]] See `:help nvim-treesitter`
	opts = {
		ensure_installed = {
			"c",
			"make",
			-- "bash",
			-- "c",
			-- "cpp",
			-- "cmake",
			-- "diff",
			-- "html",
			-- "lua",
			-- "luadoc",
			-- "markdown",
			-- "markdown_inline",
			-- "query",
			-- "vim",
			-- "vimdoc",
		},

		-- auto_install = false,
		-- highlight = {
		-- enable = true,
	},

	-- Additional treesitter modules
	--    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
	--    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
	--    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
}
