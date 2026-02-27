return {
	"echasnovski/mini.nvim",
	config = function()
		require('mini.ai').setup { n_lines = 500 }

		require('mini.surround').setup()

		require('mini.tabline').setup()

		require('mini.files').setup
		{
			mappings = {
				close       = '<leader>x',
				go_in       = 'L',
				go_in_plus  = '<enter>',
				go_out      = 'H',
				go_out_plus = '',
				mark_goto   = '',
				mark_set    = '',
				reset       = '',
				reveal_cwd  = '',
				show_help   = '',
				synchronize = '=',
				trim_left   = '<',
				trim_right  = '>',
			},
		}

		require('mini.move').setup
		{
			-- Use an empty string to disable a setting.
			mappings = {
				-- Move selection in Visual mode.
				left = "<Left>",
				right = "<Right>",
				down = "<Down>",
				up = "<Up>",

				-- Move current line in Normal mode
				line_left = "<Left>",
				line_right = "<Right>",
				line_down = "<Down>",
				line_up = "<Up>"
			},

			-- Moving behavior options.
			options = {
				-- Reindent selection during vertical move
				reindent_linewise = true,
			}
		}

		local statusline = require("mini.statusline")
		statusline.setup({ use_icons = vim.g.have_nerd_font })

		-- -- You can configure sections in the statusline by overriding their
		-- -- default behavior. For example, here we set the section for
		-- -- cursor location to LINE:COLUMN
		-- ---@diagnostic disable-next-line: duplicate-set-field
		-- statusline.section_location = function()
		-- 	return "%2l:%-2v"
		-- end
	end
}
