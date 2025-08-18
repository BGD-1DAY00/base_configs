-- ~/.config/nvim/lua/plugins/augment.lua
return {
  'augmentcode/augment.vim',
  
  -- Dependencies
  dependencies = {
    -- Note: Requires Node.js 22.0.0+ to be installed on your system
  },
  
  -- Load the plugin early since it provides completion functionality
  event = { "BufReadPre", "BufNewFile" },
  
  -- Plugin configuration
  config = function()
    -- Configure workspace folders (REQUIRED for best experience)
    -- Start with 1-3 active projects, NOT your entire IdeaProjects folder!
    vim.g.augment_workspace_folders = {
      -- Option 1: Specific active projects (recommended)
      "~/IdeaProjects/my-current-main-project",
      "~/IdeaProjects/shared-components-lib",
      
      -- Option 2: Dynamic - always include current working directory
      -- vim.fn.getcwd(),
      
      -- DON'T DO THIS - too slow and confusing:
      -- "~/IdeaProjects",  -- ❌ Will include everything
    }
    
    -- Optional: Disable default tab mapping if you want custom keybinds
    -- vim.g.augment_disable_tab_mapping = true
    
    -- Optional: Disable completions entirely (if you only want chat)
    -- vim.g.augment_disable_completions = true
    
    -- Set up custom keybindings
    local function map(mode, lhs, rhs, opts)
      opts = opts or {}
      opts.silent = opts.silent ~= false
      vim.keymap.set(mode, lhs, rhs, opts)
    end
    
    -- Completion keybinds
    -- Default is <Tab> to accept suggestions, but you can customize:
    -- map('i', '<C-y>', '<cmd>call augment#Accept()<cr>', { desc = 'Accept Augment suggestion' })
    -- map('i', '<CR>', '<cmd>call augment#Accept("\\n")<cr>', { desc = 'Accept suggestion or newline' })
    
    -- Chat commands with leader key mappings
    map('n', '<leader>ac', ':Augment chat ', { desc = 'Augment Chat (type your message)' })
    map('v', '<leader>ac', ':Augment chat ', { desc = 'Augment Chat about selection' })
    map('n', '<leader>an', '<cmd>Augment chat-new<cr>', { desc = 'Augment New Chat' })
    map('n', '<leader>at', '<cmd>Augment chat-toggle<cr>', { desc = 'Augment Toggle Chat Panel' })
    
    -- Status and management commands
    map('n', '<leader>as', '<cmd>Augment status<cr>', { desc = 'Augment Status' })
    map('n', '<leader>al', '<cmd>Augment log<cr>', { desc = 'Augment Log' })
    map('n', '<leader>ai', '<cmd>Augment signin<cr>', { desc = 'Augment Sign In' })
    map('n', '<leader>ao', '<cmd>Augment signout<cr>', { desc = 'Augment Sign Out' })
    
    -- Create user commands for easier access
    vim.api.nvim_create_user_command('AugmentStatus', 'Augment status', {})
    vim.api.nvim_create_user_command('AugmentSignIn', 'Augment signin', {})
    vim.api.nvim_create_user_command('AugmentSignOut', 'Augment signout', {})
    vim.api.nvim_create_user_command('AugmentLog', 'Augment log', {})
    vim.api.nvim_create_user_command('AugmentChatNew', 'Augment chat-new', {})
    vim.api.nvim_create_user_command('AugmentChatToggle', 'Augment chat-toggle', {})
    
    -- Auto-create .augmentignore if it doesn't exist in workspace folders
    local function create_augmentignore()
      for _, folder in ipairs(vim.g.augment_workspace_folders or {}) do
        local expanded_folder = vim.fn.expand(folder)
        local ignore_file = expanded_folder .. '/.augmentignore'
        
        -- Check if .augmentignore exists, if not create a basic one
        if vim.fn.filereadable(ignore_file) == 0 then
          local ignore_content = {
            "# Augment ignore file",
            "# Add patterns to ignore files/directories from Augment context",
            "node_modules/",
            ".git/",
            "*.log",
            "dist/",
            "build/",
            ".env*",
            "# Add your own patterns below:",
            ""
          }
          
          local file = io.open(ignore_file, 'w')
          if file then
            for _, line in ipairs(ignore_content) do
              file:write(line .. '\n')
            end
            file:close()
            vim.notify('Created .augmentignore at ' .. ignore_file, vim.log.levels.INFO)
          end
        end
      end
    end
    
    -- Create augmentignore files on startup
    vim.defer_fn(create_augmentignore, 1000)  -- Delay to ensure workspace is set up
    
    -- Helpful autocmds
    local augment_group = vim.api.nvim_create_augroup('AugmentSetup', { clear = true })
    
    -- Show a reminder about signing in if not authenticated
    vim.api.nvim_create_autocmd('VimEnter', {
      group = augment_group,
      callback = function()
        vim.defer_fn(function()
          vim.notify(
            'Augment Plugin Loaded! Use :Augment signin to authenticate, then start coding for AI completions.',
            vim.log.levels.INFO,
            { title = 'Augment.vim' }
          )
        end, 2000)
      end,
    })
  end,
}
