-- lua/plugins/which-key.lua
return {
	'folke/which-key.nvim',

	-- Load after everything else is loaded
	event = "VeryLazy",

	config = function()
		local wk = require("which-key")

		wk.setup({
			-- Window appearance
			window = {
				border = "rounded", -- Border style
				position = "bottom", -- Position on screen
				margin = { 1, 0, 1, 0 }, -- Extra window margin [top, right, bottom, left]
				padding = { 2, 2, 2, 2 }, -- Extra window padding [top, right, bottom, left]
				winblend = 0, -- Transparency
			},

			-- Layout configuration
			layout = {
				height = { min = 4, max = 25 }, -- Min and max height
				width = { min = 20, max = 50 }, -- Min and max width
				spacing = 3, -- Spacing between columns
				align = "left", -- Align columns left, center or right
			},

			-- Basic settings
			plugins = {
				marks = true, -- Show marks
				registers = true, -- Show registers
				spelling = {
					enabled = true, -- Enable spelling suggestions
					suggestions = 20, -- How many suggestions to show
				},
				-- Built-in help for common vim motions/operators
				presets = {
					operators = true, -- g~ g= gq gc etc
					motions = true, -- w, e, b motions
					text_objects = true, -- di, da, ci, ca text objects
					windows = true, -- <c-w> window commands
					nav = true, -- ] [ navigation
					z = true, -- z commands
					g = true, -- g commands
				},
			},

			-- Trigger settings
			triggers = "auto", -- Automatically setup triggers
			timeout_len = 300, -- Time in ms to wait for key sequence
			show_help = true, -- Show help message on command line
		})
	end,
}
