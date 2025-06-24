return {
	"kdheepak/lazygit.nvim",
	cmd = {
		"LazyGit",
		"LazyGitConfig",
		"LazyGitCurrentFile",
		"LazyGitFilter",
		"LazyGitFilterCurrentFile",
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	keys = {
		{ "<leader>lg", "<cmd>LazyGit<cr>",       desc = "LazyGit" },
		{ "<leader>lG", "<cmd>LazyGitConfig<cr>", desc = "LazyGit Config" },
	},
	config = function()
		require("lazygit").setup({
			floating_window_winblend = 0,
			floating_window_scaling_factor = 0.9,
			floating_window_border_chars = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
			floating_window_use_plenary = 0,
			use_neovim_remote = 1,
		})
	end,
}
