require("config.lazy")
require("lazy").setup({
  {"nvim-treesitter/nvim-treesitter", branch = 'master', lazy = false, build = ":TSUpdate"}
})

-- Enable system clipboard integration
vim.opt.clipboard = "unnamedplus"
vim.opt.ignorecase = true
-- vim.opt.relativenumber = true
vim.opt.number = true 
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.showbreak = "↪ "
