return {
  "folke/which-key.nvim",
  config = function()
    require("which-key").setup({
      preset = "classic",
      delay = 500,
    })
  end
}
