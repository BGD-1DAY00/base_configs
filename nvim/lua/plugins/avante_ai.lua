-- nvim/lua/plugins/avante.lua
return {
	"yetone/avante.nvim",
	build = "make", -- ⚠️ Must add this line!
	event = "VeryLazy",
	version = false, -- Never set this to "*"!
	---@module 'avante'
	---@type avante.Config
	opts = {
		provider = "claude", -- or "openai"
		providers = {
			gemini = {
				endpoint = "https://generativelanguage.googleapis.com/v1beta",
				model = "gemini-2.5-flash", -- or "gemini-pro"
				api_key_name = "GEMINI_API_KEY", -- Environment variable name
				timeout = 30000,
				extra_request_body = {
					temperature = 0.3,
					maxOutputTokens = 3072,
				},
			},
			claude = {
				endpoint = "https://api.anthropic.com",
				model = "claude-3-5-haiku-latest",
				api_key_name = "ANTHROPIC_API_KEY", -- Environment variable name
				timeout = 30000,
				extra_request_body = {
					temperature = 0.3,
					max_tokens = 3072,
				},
			},
			openai = {
				endpoint = "https://api.openai.com/v1",
				model = "gpt-4o",
				timeout = 30000,
				extra_request_body = {
					temperature = 0.3,
					max_tokens = 3072,
				},
			},
		},
	},
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		{
			-- Image pasting support
			"HakonHarnes/img-clip.nvim",
			event = "VeryLazy",
			opts = {
				default = {
					embed_image_as_base64 = false,
					prompt_for_file_name = false,
					drag_and_drop = {
						insert_mode = true,
					},
					use_absolute_path = true, -- required for Windows
				},
			},
		},
		{
			-- Markdown rendering
			'MeanderingProgrammer/render-markdown.nvim',
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},
	},
}
