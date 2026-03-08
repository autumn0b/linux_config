return {
	"thesimonho/kanagawa-paper.nvim",
	enabled = true,
	config = function()
		require("kanagawa-paper").setup({
			transparent = true
		})
	end
}
