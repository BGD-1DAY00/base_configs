return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See # Preview Mode for more information
  },
  lazy = false, -- neo-tree will lazily load itself
  keys = {
    -- Add keybinding to toggle neo-tree
   --  { "<leader>e", ":Neotree toggle<CR>", desc = "Toggle Neo-tree" },
    -- Or use Ctrl+n if you prefer
     { "<C-n>", ":Neotree toggle<CR>", desc = "Toggle Neo-tree" },
  },
  ---@module "neo-tree"
  ---@type neotree.Config?
  opts = {
    -- fill any relevant options here
    close_if_last_window = true, -- Close Neo-tree if it's the last window
    popup_border_style = "rounded",
    enable_git_status = true,
    window = {
        position = "left",
        window = 50, 
        mappings = {
          ["<leader>cr"] = "set_root",
          ["C"] = "set_root",
          ["<BS>"] = "navigate_up",
          ["."] = "set_root",
        },
    }, 
    enable_diagnostics = true,
    filesystem = {
      follow_current_file = {
        enabled = true, -- This will find and focus the current file in the tree
      },
      hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
    },
  },
}
