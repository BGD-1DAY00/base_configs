return {
  "3rd/image.nvim",
  config = function()
    require("image").setup({
      backend = "kitty",
      hijack_file_patterns = { 
        "*.png", "*.jpg", "*.jpeg", 
        "*.gif", "*.webp", "*.svg" 
      },
    })
  end
}
