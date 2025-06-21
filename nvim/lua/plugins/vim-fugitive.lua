return {
  'tpope/vim-fugitive',
  cmd = {'Git', 'Gdiffsplit', 'Gread', 'Gwrite', 'Ggrep', 'GMove', 'GDelete', 'GBrowse'},
  keys = {
    {'<leader>gs', '<cmd>Git<cr>', desc = 'Git status'},
    {'<leader>ga', '<cmd>Git add .<cr>', desc = 'Git add all'},
    {'<leader>gc', '<cmd>Git commit<cr>', desc = 'Git commit'},
    {'<leader>gp', '<cmd>Git push<cr>', desc = 'Git push'},
    {'<leader>gl', '<cmd>Git log<cr>', desc = 'Git log'},
    {'<leader>gd', '<cmd>Gdiffsplit<cr>', desc = 'Git diff'},
    {'<leader>gb', '<cmd>Git blame<cr>', desc = 'Git blame'},
    {'<leader>gw', '<cmd>Gwrite<cr>', desc = 'Git add current file'},
    {'<leader>gr', '<cmd>Gread<cr>', desc = 'Git checkout current file'},
  },
}
