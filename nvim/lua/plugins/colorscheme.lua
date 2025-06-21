-- Set your preferred colorscheme here
local CURRENT_COLORSCHEME = "catppuccin" -- Options: "tokyonight", "catppuccin", "gruvbox"

return {
	-- Catppuccin
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "macchiato", -- latte, frappe, macchiato, mocha
				background = {
					light = "mocchiato",
					dark = "mocha",
				},
				transparent_background = false,
				show_end_of_buffer = false,
				term_colors = true,
				integrations = {
					cmp = true,
					gitsigns = true,
					nvimtree = true,
					telescope = true,
					notify = false,
					mini = false,
				},
			})

			if CURRENT_COLORSCHEME == "catppuccin" then
				vim.cmd.colorscheme "catppuccin"
			end
		end,
	},

	-- Tokyo Night
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				style = "night", -- storm, moon, night, day
				light_style = "day",
				transparent = false,
				terminal_colors = true,
				styles = {
					comments = { italic = true },
					keywords = { italic = true },
					functions = {},
					variables = {},
				},
			})

			if CURRENT_COLORSCHEME == "tokyonight" then
				vim.cmd.colorscheme "tokyonight"
			end
		end,
	},

	{
		"ellisonleao/gruvbox.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("gruvbox").setup({
				terminal_colors = true,
				undercurl = true,
				underline = true,
				bold = true,
				italic = {
					strings = true,
					emphasis = true,
					comments = true,
					operators = false,
					folds = true,
				},
				strikethrough = true,
				invert_selection = false,
				invert_signs = false,
				invert_tabline = false,
				invert_intend_guides = false,
				inverse = true,
				contrast = "", -- can be "hard", "soft" or empty string
				palette_overrides = {},
				overrides = {},
				dim_inactive = false,
				transparent_mode = false,
			})

			if CURRENT_COLORSCHEME == "gruvbox" then
				vim.cmd.colorscheme "gruvbox"
			end
		end,
	},
}
