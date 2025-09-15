return {
	"epwalsh/obsidian.nvim",
	version = "*",
	lazy = false,
	ft = "markdown",

	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
		"nvim-treesitter/nvim-treesitter",
		"hrsh7th/nvim-cmp",
	},

	config = function()
		require("obsidian").setup({
			-- SIMPLE WORKSPACES - Each is just a folder, no nested structure
			workspaces = {
				{
					name = "personal",
					path = vim.fn.expand("~/.config/notes/personal"),
				},
				{
					name = "work",
					path = vim.fn.expand("~/.config/notes/work"),
				},
				{
					name = "videos",
					path = vim.fn.expand("~/.config/notes/videos"),
				},
				{
					name = "learning",
					path = vim.fn.expand("~/.config/notes/learning"),
				},
			},

			callbacks = {
				-- Runs right after entering a note buffer
				enter_note = function(client, note)
					vim.bo.modifiable = true
				end,

				-- Runs when leaving a note buffer
				leave_note = function(client, note)
					vim.bo.modifiable = true
				end,

				-- Runs before writing the buffer
				pre_write_note = function(client, note)
					vim.bo.modifiable = true
				end,
			},

			-- NO default subfolder - notes go directly to workspace root
			notes_subdir = nil,

			-- Disable daily notes
			daily_notes = {
				folder = nil,
			},

			-- Completion
			completion = {
				nvim_cmp = true,
				min_chars = 2,
			},

			-- Simple note naming
			note_id_func = function(title)
				if title ~= nil then
					return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
				else
					return tostring(os.time())
				end
			end,

			preferred_link_style = "wiki",

			-- Minimal frontmatter
			note_frontmatter_func = function(note)
				return {
					tags = note.tags,
					date = os.date("%Y-%m-%d"),
				}
			end,

			-- Disable templates
			templates = {
				folder = nil,
				substitutions = {},
			},

			-- Simple UI
			ui = {
				enable = true,
				checkboxes = {
					[" "] = { char = "☐", hl_group = "ObsidianTodo" },
					["x"] = { char = "✔", hl_group = "ObsidianDone" },
				},
			},

			-- Simple mappings
			mappings = {
				["gf"] = {
					action = function()
						return require("obsidian").util.gf_passthrough()
					end,
					opts = { noremap = false, expr = true, buffer = true },
				},
				["<leader>ch"] = {
					action = function()
						return require("obsidian").util.toggle_checkbox()
					end,
					opts = { buffer = true },
				},
			},

			-- Where to put new notes when no path specified
			new_notes_location = "current",
		})

		-- SIMPLE SHORTCUTS
		local opts = { noremap = true, silent = true }

		-- Workspace switching
		vim.keymap.set("n", "<leader>ow", ":ObsidianWorkspace<CR>",
			{ desc = "Switch Obsidian workspace" })

		-- Quick workspace switches
		vim.keymap.set("n", "<leader>owp", ":ObsidianWorkspace personal<CR>",
			{ desc = "Switch to personal workspace" })
		vim.keymap.set("n", "<leader>oww", ":ObsidianWorkspace work<CR>",
			{ desc = "Switch to work workspace" })
		vim.keymap.set("n", "<leader>owv", ":ObsidianWorkspace videos<CR>",
			{ desc = "Switch to videos workspace" })
		vim.keymap.set("n", "<leader>owl", ":ObsidianWorkspace learning<CR>",
			{ desc = "Switch to learning workspace" })

		-- Create note in current workspace (no subfolders!)
		vim.keymap.set("n", "<leader>onn", ":ObsidianNew<CR>",
			{ desc = "New note in current workspace" })

		-- Quick note creation with workspace switch
		local function note_in_workspace(workspace)
			return function()
				vim.cmd("ObsidianWorkspace " .. workspace)
				vim.defer_fn(function()
					vim.cmd("ObsidianNew")
				end, 100)
			end
		end

		vim.keymap.set("n", "<leader>onp", note_in_workspace("personal"),
			{ desc = "New note in personal" })
		vim.keymap.set("n", "<leader>onw", note_in_workspace("work"),
			{ desc = "New note in work" })
		vim.keymap.set("n", "<leader>onv", note_in_workspace("videos"),
			{ desc = "New note in videos" })
		vim.keymap.set("n", "<leader>onl", note_in_workspace("learning"),
			{ desc = "New note in learning" })

		-- Other Obsidian shortcuts
		vim.keymap.set("n", "<leader>onf", ":ObsidianQuickSwitch<CR>",
			{ desc = "Find/switch note" })
		vim.keymap.set("n", "<leader>ons", ":ObsidianSearch<CR>",
			{ desc = "Search in notes" })
		vim.keymap.set("n", "<leader>onb", ":ObsidianBacklinks<CR>",
			{ desc = "Show backlinks" })
		vim.keymap.set("n", "<leader>ont", ":ObsidianTags<CR>",
			{ desc = "Browse tags" })

		-- Link operations
		vim.keymap.set("v", "<leader>oll", ":ObsidianLink<CR>",
			{ desc = "Link selected text" })
		vim.keymap.set("v", "<leader>oln", ":ObsidianLinkNew<CR>",
			{ desc = "Link to new note" })

		-- Show current workspace
		vim.api.nvim_create_user_command("ObsidianCurrentWorkspace", function()
			local client = require("obsidian").get_client()
			if client and client.current_workspace then
				vim.notify("Current workspace: " .. client.current_workspace.name, vim.log.levels.INFO)
			else
				vim.notify("No workspace active", vim.log.levels.WARN)
			end
		end, {})

		vim.keymap.set("n", "<leader>owc", ":ObsidianCurrentWorkspace<CR>",
			{ desc = "Show current workspace" })

		-- Create workspace directories (flat structure, no subfolders)
		local workspaces = { "personal", "work", "videos", "learning" }
		for _, ws in ipairs(workspaces) do
			vim.fn.mkdir(vim.fn.expand("~/.config/notes/" .. ws), "p")
		end
	end,
}
