require("config.lazy")
require("lazy").setup({
  {"nvim-treesitter/nvim-treesitter", branch = 'master', lazy = false, build = ":TSUpdate"}
})

-- Enable system clipboard integration
vim.opt.clipboard = "unnamedplus"
-- vim.opt.relativenumber = true
vim.opt.number = true 
