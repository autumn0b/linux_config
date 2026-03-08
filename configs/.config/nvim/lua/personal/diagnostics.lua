-- [e]rror [f]loating window
-- Floating win is closed when the cursor moves
vim.keymap.set("n", "<leader>et", vim.diagnostic.open_float)

vim.diagnostic.config({
	virtual_text = false,
	float = {
		-- focusable = false,
		-- style = "minimal",
		border = "single",
		source = "always",
		header = "",
		prefix = ""
	},
	-- signs = true,
	underline = true,
	-- update_in_insert = true,
	severity_sort = true
})
