return {
	'akinsho/toggleterm.nvim',
	version = "*",
	config = function()
		require("toggleterm").setup({
			-- Use a function for dynamic sizing based on window size
			size = function(term)
				if term.direction == "horizontal" then
					return 15 -- 15 lines for horizontal
				elseif term.direction == "vertical" then
					return vim.o.columns * 0.3 -- 30% of window width
				end
			end,
			open_mapping = [[<c-\>]],
			hide_numbers = true,
			shade_terminals = true,
			shading_factor = 2,
			start_in_insert = true,
			direction = 'vertical',
			persist_size = true,
			persist_mode = true,
			close_on_exit = true,
			shell = vim.o.shell,
			float_opts = {
				border = 'curved',
				winblend = 0,
				highlights = {
					border = "Normal",
					background = "Normal",
				},
			},
		})

		-- Terminal mode keymaps (FIX: underscores not asterisks!)
		function _G.set_terminal_keymaps() -- <- Fixed here
			local opts = { buffer = 0 }
			vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
			vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
			vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
			vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
			vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
			vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
			vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
		end

		-- Apply keymaps to each terminal buffer
		vim.cmd('autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()')

		-- Your existing mappings
		vim.keymap.set('n', '<leader>t1', '<cmd>1ToggleTerm<cr>', { desc = 'Terminal 1' })
		vim.keymap.set('n', '<leader>t2', '<cmd>2ToggleTerm<cr>', { desc = 'Terminal 2' })
		vim.keymap.set('n', '<leader>t3', '<cmd>3ToggleTerm<cr>', { desc = 'Terminal 3' })
		vim.keymap.set('n', '<leader>t4', '<cmd>4ToggleTerm<cr>', { desc = 'Terminal 4' })
		vim.keymap.set('n', '<leader>tt', '<cmd>TermSelect<cr>', { desc = 'Select Terminal' })

		-- Add direction-specific shortcuts
		vim.keymap.set('n', '<leader>tv', '<cmd>ToggleTerm direction=vertical<cr>',
			{ desc = 'Vertical Terminal' })
		vim.keymap.set('n', '<leader>th', '<cmd>ToggleTerm direction=horizontal<cr>',
			{ desc = 'Horizontal Terminal' })
		vim.keymap.set('n', '<leader>tf', '<cmd>ToggleTerm direction=float<cr>', { desc = 'Floating Terminal' })
		vim.keymap.set('n', '<leader>ta', '<cmd>ToggleTermToggleAll<cr>', { desc = 'Toggle All Terminals' })

		-- Window resize keymaps (for normal mode)
		vim.keymap.set('n', '<C-Up>', ':resize -2<CR>', { desc = 'Decrease height' })
		vim.keymap.set('n', '<C-Down>', ':resize +2<CR>', { desc = 'Increase height' })
		vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', { desc = 'Decrease width' })
		vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', { desc = 'Increase width' })
	end,
}
