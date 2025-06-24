return {
  'akinsho/toggleterm.nvim',
  version = "*",
  config = function()
    require("toggleterm").setup({
      -- Add basic config to ensure it loads
      size = 20,
      open_mapping = [[<c-\>]],
      hide_numbers = true,
      shade_terminals = true,
      start_in_insert = true,
      direction = 'float',
    })
    
    -- Key mappings for multiple floating terminals
    vim.keymap.set('n', '<leader>t1', '<cmd>1ToggleTerm direction=float<cr>', { desc = 'Terminal 1' })
    vim.keymap.set('n', '<leader>t2', '<cmd>2ToggleTerm direction=float<cr>', { desc = 'Terminal 2' })
    vim.keymap.set('n', '<leader>t3', '<cmd>3ToggleTerm direction=float<cr>', { desc = 'Terminal 3' })
    vim.keymap.set('n', '<leader>t4', '<cmd>4ToggleTerm direction=float<cr>', { desc = 'Terminal 4' })
  end,
}
