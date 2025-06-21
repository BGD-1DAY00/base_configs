return {
	'nvim-telescope/telescope.nvim',
	branch = '0.1.x', -- Use branch instead of old tag
	dependencies = { 'nvim-lua/plenary.nvim' },
	cmd = "Telescope", -- Load when :Telescope command is used
	keys = {
		{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
		{ "<leader>fg", "<cmd>Telescope live_grep<cr>",  desc = "Live Grep" },
		{ "<leader>fb", "<cmd>Telescope buffers<cr>",    desc = "Buffers" },
		{ "<leader>fh", "<cmd>Telescope help_tags<cr>",  desc = "Help Tags" },
	},
	config = function()
		-- THIS IS THE KEY FIX: Initialize Telescope
		require('telescope').setup({
			defaults = {
				-- Optional: Basic configuration
				file_ignore_patterns = { "node_modules", ".git/" },
				layout_config = {
					horizontal = { preview_width = 0.6 },
				},
			},
			pickers = {
				find_files = {
					hidden = true
				}
			},
		})
	end,
}
