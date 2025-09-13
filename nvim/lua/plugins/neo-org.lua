return {
	"nvim-neorg/neorg",
	lazy = false,                  -- Neorg needs to load immediately
	version = "*",                 -- Pin to latest stable release
	dependencies = {
		"nvim-lua/plenary.nvim", -- Required dependency
		"nvim-treesitter/nvim-treesitter", -- For syntax highlighting
	},
	config = function()
		require("neorg").setup {
			load = {
				["core.defaults"] = {},
				["core.concealer"] = {
					config = {
						icon_preset = "diamond", -- basic|varied|diamond
					}
				},
				["core.dirman"] = {
					config = {
						workspaces = {
							notes = "~/.config/notes",
						},
						default_workspace = "notes",
					},
				},
			},
		}

		vim.wo.foldlevel = 99 -- Open all folds by default
		vim.wo.conceallevel = 2 -- Hide markup, show custom icons
	end,
}
