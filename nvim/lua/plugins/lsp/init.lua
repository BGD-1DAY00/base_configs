-- plugins/lsp/init.lua
--
-- This file sets up:
-- 1. Basic LSP keybindings (gd, gr, K, etc.)
-- 2. How errors/warnings look
-- 3. Autocompletion popup
--
local mason_plugins = require("plugins.lsp.mason")
local lua_plugins = require("plugins.lsp.lua_ls")
return {
	-- PART 1: LSP Configuration (connects language servers to Neovim)
	{
		mason_plugins,
	},
	{
		lua_plugins,
	},
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			-- Shows "LSP loading..." messages in bottom right
			{ 'j-hui/fidget.nvim', opts = {} },
		},
		config = function()
			-- SECTION A: Global keybindings (work everywhere)
			-- These work even when LSP isn't attached to current file
			vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, { desc = 'Show error details' })
			vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous error' })
			vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next error' })
			vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, { desc = 'List all errors' })

			-- SECTION B: LSP-specific keybindings (only work when LSP is active)
			-- This runs every time an LSP connects to a file
			vim.api.nvim_create_autocmd('LspAttach', {
				group = vim.api.nvim_create_augroup('UserLspConfig', {}),
				callback = function(ev)
					-- ev.buf = the file the LSP just connected to
					local opts = { buffer = ev.buf } -- These keybinds only work in this specific file

					-- Navigation keybinds
					vim.keymap.set('n', 'gd', vim.lsp.buf.definition,
						vim.tbl_extend('force', opts, { desc = 'Go to where this is defined' }))
					vim.keymap.set('n', 'gr', vim.lsp.buf.references,
						vim.tbl_extend('force', opts, { desc = 'Find all uses of this' }))
					vim.keymap.set('n', 'gi', vim.lsp.buf.implementation,
						vim.tbl_extend('force', opts, { desc = 'Go to implementation' }))
					vim.keymap.set('n', 'gD', vim.lsp.buf.declaration,
						vim.tbl_extend('force', opts, { desc = 'Go to declaration' }))

					-- Documentation keybinds
					vim.keymap.set('n', 'K', vim.lsp.buf.hover,
						vim.tbl_extend('force', opts, { desc = 'Show docs for this' }))
					vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help,
						vim.tbl_extend('force', opts, { desc = 'Show function signature' }))

					-- Code action keybinds
					vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename,
						vim.tbl_extend('force', opts, { desc = 'Rename this variable/function' }))
					vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action,
						vim.tbl_extend('force', opts, { desc = 'Show quick fixes' }))

					-- Formatting keybind
					vim.keymap.set('n', '<space>f', function()
						vim.lsp.buf.format { async = true } -- Format code without blocking
					end, vim.tbl_extend('force', opts, { desc = 'Format this file' }))
				end,
			})

			-- SECTION C: How errors/warnings look visually
			vim.diagnostic.config({
				virtual_text = {
					prefix = '●', -- Show ● next to errors in code
				},
				float = {
					border = "rounded", -- Rounded corners on error popups
				},
				signs = true, -- Show error icons in left gutter
				underline = true, -- Underline errors in code
				update_in_insert = false, -- Don't show errors while typing
				severity_sort = true, -- Show most severe errors first
			})

			-- SECTION D: Error icons in the gutter (left side)
			local signs = {
				Error = " ", -- Red X for errors
				Warn = " ", -- Yellow warning triangle
				Hint = " ", -- Blue lightbulb for hints
				Info = " " -- Blue info icon
			}
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
			end
			require('lspconfig').lua_ls.setup {
				settings = {
					Lua = {
						runtime = { version = 'LuaJIT' },
						diagnostics = { globals = { 'vim' } },
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
						telemetry = { enable = false },
					},
				},
			}
		end,
	},

	-- PART 2: Autocompletion (the popup suggestions when typing)
	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			'hrsh7th/cmp-nvim-lsp', -- Get suggestions from LSP
			'hrsh7th/cmp-buffer', -- Get suggestions from current file text
			'hrsh7th/cmp-path', -- Get suggestions for file paths
		},
		config = function()
			local cmp = require('cmp')

			cmp.setup({
				-- Keybindings for the completion popup
				mapping = cmp.mapping.preset.insert({
					['<C-b>'] = cmp.mapping.scroll_docs(-4), -- Scroll up in documentation
					['<C-f>'] = cmp.mapping.scroll_docs(4), -- Scroll down in documentation
					['<C-Space>'] = cmp.mapping.complete(), -- Force show completions
					['<C-e>'] = cmp.mapping.abort(), -- Close completion popup
					['<CR>'] = cmp.mapping.confirm({ select = true }), -- Enter = accept suggestion
					['<Tab>'] = cmp.mapping.select_next_item(), -- Tab = next suggestion
					['<S-Tab>'] = cmp.mapping.select_prev_item(), -- Shift+Tab = previous suggestion
				}),

				-- Where to get completion suggestions from (in priority order)
				sources = cmp.config.sources({
					{ name = 'nvim_lsp' }, -- First priority: LSP suggestions (smart)
				}, {
					{ name = 'buffer' }, -- Second priority: words from current file
					{ name = 'path' }, -- Third priority: file/folder names
				})
			})
		end,
	},
}
