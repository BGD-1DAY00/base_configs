-- plugins/mason.lua (or plugins/lsp/mason.lua)

-- MASON ECOSYSTEM EXPLAINED:
--
-- 1. MASON (Core) - The Downloader
--    • Downloads LSP binaries to ~/.local/share/nvim/mason/bin/
--    • Provides UI (:Mason command) to browse/install tools
--    • Manages versions and updates
--    • DOESN'T configure LSPs or start them - just downloads
--    • Think of it like: A package manager that downloads software but doesn't configure it
--
-- 2. MASON-LSPCONFIG - The Bridge  
--    • Connects Mason's download location to nvim-lspconfig
--    • Without bridge: nvim-lspconfig can't find Mason-installed LSPs
--    • With bridge: Points nvim-lspconfig to ~/.local/share/nvim/mason/bin/
--    • Auto-installs LSPs when you open supported files
--    • Maps Mason names to lspconfig names
--
-- 3. MASON-TOOL-INSTALLER - Non-LSP Tools
--    • LSP tools: tsserver, pyright (provide autocomplete, go-to-definition, errors)  
--    • Non-LSP tools: prettier, eslint_d (formatters and linters - simpler tools)
--    • LSPs are smart and understand code, formatters/linters just process text
--
-- IMPORTANT: This file only DOWNLOADS tools. You still need separate config files
-- (like typescript.lua) to actually CONFIGURE how the LSPs behave!
--
-- Example flow when opening app.ts:
-- 1. mason.lua: Downloads tsserver binary  
-- 2. mason-lspconfig: "Hey nvim-lspconfig, tsserver is at ~/.local/share/nvim/mason/bin/"
-- 3. typescript.lua: "Here's HOW to configure tsserver (settings, keybinds, etc.)"
-- 4. Result: TypeScript LSP works with your custom configuration
--
return {
  -- Mason: Package manager for LSP servers, linters, formatters
 {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup({
        ui = {
          border = "rounded",
          width = 0.8,
          height = 0.8,
          icons = {
            package_installed = "✓",
            package_pending = "➜", 
            package_uninstalled = "✗"
          }
        },
        -- Install packages to mason's bin directory
        install_root_dir = vim.fn.stdpath("data") .. "/mason",
        
        -- Automatically check for new versions
        max_concurrent_installers = 4,
      })
    end,
  },
  -- Mason-LSPconfig: Bridge between Mason and nvim-lspconfig
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'williamboman/mason.nvim', 'neovim/nvim-lspconfig' },
    config = function()
      require('mason-lspconfig').setup({
        -- Automatically install these LSP servers
        ensure_installed = {
          'ts_ls',         -- TypeScript/JavaScript (renamed from tsserver)
          'lua_ls',        -- Lua (for Neovim config)
          'pyright',       -- Python
          'eslint',        -- JavaScript linting
        },
        
        -- Install servers automatically when you open supported files
      })
      
      -- Automatically setup installed servers, sets up basic start functionality
      -- This tells mason how to start/run the lsp tool 
   end,
  },
  -- Optional: Mason Tool Installer (for non-LSP tools)
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = { 'williamboman/mason.nvim', 'neovim/nvim-lspconfig',  },
    config = function()
      require('mason-tool-installer').setup({
        -- Install these tools automatically
        ensure_installed = {
          -- Formatters
          'prettier',      -- JavaScript/TypeScript/JSON/CSS formatter
          -- 'black',      -- Python formatter
          
          -- Linters  
          'eslint_d',      -- Fast ESLint daemon
          -- 'flake8',     -- Python linter
        },
        
        -- Auto-update tools
        auto_update = false,
        run_on_start = true,
      })
    end,
  },
}
