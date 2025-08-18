return {
  "renerocksai/telekasten.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "mattn/calendar-vim" -- Add calendar plugin
  },
  config = function()
    require('telekasten').setup({
      home = vim.fn.expand("~/zettelkasten"), -- Put the name of your notes directory here
      
      -- Optional configuration
      take_over_my_home = true,
      auto_set_filetype = true,
      dailies = vim.fn.expand("~/zettelkasten/daily"),
      weeklies = vim.fn.expand("~/zettelkasten/weekly"),
      templates = vim.fn.expand("~/zettelkasten/templates"),
      
      -- Image settings
      image_subdir = "img",
      extension = ".md",
      
      -- New note filename format
      new_note_filename = "title",
      uuid_type = "%Y%m%d%H%M",
      uuid_sep = "-",
      
      -- Tag settings
      tag_notation = "#tag",
      
      -- Calendar settings
      plug_into_calendar = true,
      calendar_opts = {
        weeknm = 4,
        calendar_monday = 1,
        calendar_mark = 'left-fit',
      },
      
      -- Follow link behavior
      follow_creates_nonexisting = true,
      dailies_create_nonexisting = true,
      weeklies_create_nonexisting = true,
      
      -- Journal template
      journal_auto_open = false,
      
      -- Close after yanking link
      close_after_yanking = false,
      insert_after_inserting = true,
      
      -- Telescope settings
      show_tags_theme = "ivy",
      subdirs_in_links = true,
      template_new_note = vim.fn.expand("~/zettelkasten/templates/new_note.md"),
      template_new_daily = vim.fn.expand("~/zettelkasten/templates/daily.md"),
      template_new_weekly = vim.fn.expand("~/zettelkasten/templates/weekly.md"),
      
      -- File browser command
      command_palette_theme = "ivy",
      show_tags_theme = "ivy",
      subdirs_in_links = true,
      
      -- Media preview
      media_previewer = "telescope-media-files",
    })
  end,
  
  keys = {
    -- Main panel - shows all available commands
    { "<leader>z", "<cmd>Telekasten panel<CR>", desc = "Telekasten Panel" },
    
    -- Most used functions
    { "<leader>zf", "<cmd>Telekasten find_notes<CR>", desc = "Find Notes" },
    { "<leader>zg", "<cmd>Telekasten search_notes<CR>", desc = "Search Notes" },
    { "<leader>zd", "<cmd>Telekasten goto_today<CR>", desc = "Today's Note" },
    { "<leader>zz", "<cmd>Telekasten follow_link<CR>", desc = "Follow Link" },
    { "<leader>zn", "<cmd>Telekasten new_note<CR>", desc = "New Note" },
    { "<leader>zc", "<cmd>Telekasten show_calendar<CR>", desc = "Show Calendar" },
    { "<leader>zb", "<cmd>Telekasten show_backlinks<CR>", desc = "Show Backlinks" },
    
    -- Weekly notes
    { "<leader>zw", "<cmd>Telekasten goto_thisweek<CR>", desc = "This Week's Note" },
    { "<leader>zW", "<cmd>Telekasten find_weekly_notes<CR>", desc = "Find Weekly Notes" },
    
    -- Links and tags
    { "<leader>zl", "<cmd>Telekasten insert_link<CR>", desc = "Insert Link" },
    { "<leader>zt", "<cmd>Telekasten show_tags<CR>", desc = "Show Tags" },
    { "<leader>zy", "<cmd>Telekasten yank_notelink<CR>", desc = "Yank Note Link" },
    { "<leader>zF", "<cmd>Telekasten find_friends<CR>", desc = "Find Friends" },
    
    -- Templates and todos
    { "<leader>zT", "<cmd>Telekasten new_templated_note<CR>", desc = "New Templated Note" },
    { "<leader>z<space>", "<cmd>Telekasten toggle_todo<CR>", desc = "Toggle Todo" },
    
    -- Images and media
    { "<leader>zi", "<cmd>Telekasten paste_img_and_link<CR>", desc = "Paste Image & Link" },
    { "<leader>zI", "<cmd>Telekasten insert_img_link<CR>", desc = "Insert Image Link" },
    { "<leader>zp", "<cmd>Telekasten preview_img<CR>", desc = "Preview Image" },
    { "<leader>zm", "<cmd>Telekasten browse_media<CR>", desc = "Browse Media" },
    
    -- Utility
    { "<leader>zr", "<cmd>Telekasten rename_note<CR>", desc = "Rename Note" },
    { "<leader>zv", "<cmd>Telekasten switch_vault<CR>", desc = "Switch Vault" },
    
    -- Insert mode mappings
    { "[[", "<cmd>Telekasten insert_link<CR>", mode = "i", desc = "Insert Link" },
  },
  
  -- Load only for markdown files and when explicitly called
  ft = { "markdown" },
  cmd = { "Telekasten" },
}
