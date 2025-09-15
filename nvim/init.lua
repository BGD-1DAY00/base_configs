vim.g.maplocalleader = ","
require("config.lazy")
require("lazy").setup({
  {"nvim-treesitter/nvim-treesitter", branch = 'master', lazy = false, build = ":TSUpdate"}
})

-- Enable system clipboard integration
vim.opt.clipboard = "unnamedplus"
vim.opt.ignorecase = true
vim.opt.relativenumber = true
vim.opt.number = true 
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.showbreak = "↪ "
vim.opt.conceallevel = 2
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format, { desc = 'LSP Format' })	

