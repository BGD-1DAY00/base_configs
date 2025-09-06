return {
	-- Telescope core
	{
		'nvim-telescope/telescope.nvim',
		branch = '0.1.x',
		dependencies = {
			'nvim-lua/plenary.nvim',
			-- CRITICAL: Native FZF sorter for 50-90% performance improvement
			{
				'nvim-telescope/telescope-fzf-native.nvim',
				build = 'make',
				cond = function()
					return vim.fn.executable('make') == 1
				end,
			},
		},
		cmd = "Telescope",
		keys = {
			-- Smart file finding: Uses git_files in git repos, find_files elsewhere
			{
				"<leader>ff",
				function()
					local ok = pcall(require('telescope.builtin').git_files, {
						show_untracked = true,
					})
					if not ok then
						require('telescope.builtin').find_files({
							hidden = true,
							no_ignore = false,
						})
					end
				end,
				desc = "Find Files (Smart)"
			},
			-- Force find_files for when you need everything
			{
				"<leader>fF",
				function()
					require('telescope.builtin').find_files({
						hidden = true,
						no_ignore = false,
					})
				end,
				desc = "Find Files (All)"
			},

			-- Other useful mappings
			{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
			{ "<leader>fb", "<cmd>Telescope buffers<cr>",   desc = "Buffers" },
			{ "<leader>fr", "<cmd>Telescope oldfiles<cr>",  desc = "Recent Files" },
			{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },

			-- Quick access to config files
			{
				"<leader>fc",
				function()
					require('telescope.builtin').find_files({
						cwd = vim.fn.expand("~/.config"),
						hidden = true,
					})
				end,
				desc = "Find Config Files"
			},

			-- Search from project root
			{
				"<leader>fp",
				function()
					local root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
					require('telescope.builtin').find_files({
						cwd = root or vim.fn.getcwd(),
						hidden = true,
					})
				end,
				desc = "Find from Project Root"
			},

			-- Quick access to important directories without the cruft
			{
				"<leader>fd",
				function()
					require('telescope.builtin').find_files({
						cwd = vim.fn.expand("~/Documents"),
						hidden = false,
					})
				end,
				desc = "Find in Documents"
			},
		},
		config = function()
			local telescope = require('telescope')
			local actions = require('telescope.actions')

			-- Check if ripgrep and fd are available
			local has_rg = vim.fn.executable('rg') == 1
			local has_fd = vim.fn.executable('fd') == 1

			-- Warn user if performance tools aren't installed
			if not has_rg then
				vim.notify(
					"ripgrep not found! Install it for 10x better performance: brew install ripgrep",
					vim.log.levels.WARN
				)
			end
			if not has_fd then
				vim.notify(
					"fd not found! Install it for better file finding: brew install fd",
					vim.log.levels.INFO
				)
			end

			-- Build find_command based on what's available
			local find_command = nil
			if has_fd then
				find_command = {
					'fd',
					'--type', 'f',
					'--type', 'l', -- Include symlinks
					'--hidden',
					'--follow',
					'--exclude', '.git',
					'--exclude', 'node_modules',
					'--exclude', 'Library',
					'--exclude', '.Trash',
					'--exclude', 'build',
					'--exclude', 'dist',
					'--exclude', 'target',
					'--exclude', '*.app',
					'--exclude', 'Applications',
					'--exclude', 'Movies',
					'--exclude', 'Music',
					'--exclude', 'Pictures',
					'--exclude', '.android',
					'--exclude', '.gradle',
					'--exclude', '.expo',
					'--exclude', 'Pods',
					'--exclude', '.terraform.d',
					'--exclude', '.docker',
					'--exclude', '.aws',
					'--exclude', '.cache',
					'--max-depth', '6', -- Limit search depth
				}
			elseif has_rg then
				find_command = {
					'rg',
					'--files',
					'--hidden',
					'--follow',
					'--glob', '!.git/*',
					'--glob', '!node_modules/*',
					'--glob', '!Library/*',
					'--glob', '!.Trash/*',
					'--glob', '!build/*',
					'--glob', '!dist/*',
					'--glob', '!*.app',
					'--glob', '!Applications/*',
					'--glob', '!Movies/*',
					'--glob', '!Music/*',
					'--glob', '!Pictures/*',
					'--max-filesize', '5M',
				}
			else
				-- Fallback to find (will be slow)
				find_command = { 'find', '.', '-type', 'f' }
			end

			telescope.setup({
				defaults = {
					-- Use ripgrep for grepping (MUCH faster than grep)
					vimgrep_arguments = has_rg and {
						'rg',
						'--color=never',
						'--no-heading',
						'--with-filename',
						'--line-number',
						'--column',
						'--smart-case',
						'--hidden',
						'--follow',
						-- Critical: Use glob patterns in ripgrep, NOT file_ignore_patterns
						'--glob', '!**/.git/*',
						'--glob', '!**/node_modules/*',
						'--glob', '!**/Library/*', -- macOS Library folder
						'--glob', '!**/.Trash/*',
						'--glob', '!**/build/*',
						'--glob', '!**/dist/*',
						'--glob', '!**/target/*',
						'--glob', '!**/*.lock',
						'--glob', '!**/.DS_Store',
						'--max-filesize', '5M', -- Skip files larger than 5MB
					} or {
						'grep',
						'--recursive',
						'--line-number',
						'--column',
						'--with-filename',
						'--no-heading',
						'--color=never',
						'--smart-case',
					},

					-- Performance optimizations
					path_display = { "truncate" }, -- NEVER use "smart" - causes massive slowdowns
					sorting_strategy = "ascending",
					selection_strategy = "reset",
					scroll_strategy = "limit",

					-- Faster layout
					layout_strategy = "horizontal",
					layout_config = {
						horizontal = {
							prompt_position = "top",
							preview_width = 0.55,
							results_width = 0.8,
						},
						vertical = {
							mirror = false,
						},
						width = 0.85,
						height = 0.80,
						preview_cutoff = 120,
					},

					-- Limit results for better performance
					wrap_results = false,
					dynamic_preview_title = false,

					-- Better mappings
					mappings = {
						i = {
							["<C-n>"] = actions.cycle_history_next,
							["<C-p>"] = actions.cycle_history_prev,
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
							["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
							["<Esc>"] = actions.close,
							["<C-u>"] = false, -- Clear prompt instead of scroll
						},
						n = {
							["<Esc>"] = actions.close,
							["q"] = actions.close,
						},
					},
				},

				pickers = {
					find_files = {
						-- Use the pre-built find_command (NOT a function)
						find_command = find_command,
						hidden = true,
						no_ignore = false,
						follow = true,
						-- Disable preview for find_files to avoid errors
						previewer = false,
					},

					git_files = {
						show_untracked = true,
						recurse_submodules = false, -- Don't search in submodules
						previewer = false, -- Disable preview to avoid errors
					},

					live_grep = {
						only_sort_text = true, -- Don't search filenames
						additional_args = function()
							return { "--max-filesize", "1M" } -- Skip large files in grep
						end,
					},

					buffers = {
						sort_lastused = true,
						sort_mru = true,
						ignore_current_buffer = true,
						previewer = false, -- Faster buffer switching
					},

					oldfiles = {
						only_cwd = true, -- Only show files from current directory
						previewer = false, -- Disable preview
					},
				},

				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true, -- Override the generic sorter
						override_file_sorter = true, -- Override the file sorter
						case_mode = "smart_case", -- Smart case search
					},
				},
			})

			-- Load FZF extension if it was built successfully
			pcall(telescope.load_extension, 'fzf')

			-- Optional: Create a .rgignore file in your home directory
			-- This will be automatically respected by ripgrep
			local rgignore_path = vim.fn.expand("~/.rgignore")
			if vim.fn.filereadable(rgignore_path) == 0 then
				vim.notify(
					"Consider creating ~/.rgignore with patterns to ignore globally.\n" ..
					"Example content:\n" ..
					"Library/\n" ..
					"*.app\n" ..
					"node_modules/\n" ..
					".git/",
					vim.log.levels.INFO
				)
			end
		end,
	},
}
