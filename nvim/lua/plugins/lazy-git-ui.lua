return {
  "kdheepak/lazygit.nvim",
  dependencies = {
      "nvim-lua/plenary.nvim",
  },
  keys = {
    {'<leader>lg', '<cmd>LazyGit<cr>', desc = 'LazyGit'},
    {'<leader>lG', '<cmd>LazyGitConfig<cr>', desc = 'LazyGit Config'},
  },
}
