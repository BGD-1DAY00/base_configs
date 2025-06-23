# Neovim Configuration Agent Guide

## Architecture
This is a personal Neovim configuration using lazy.nvim plugin manager. Main structure:
- `init.lua` - Entry point, loads lazy.nvim and basic settings
- `lua/config/lazy.lua` - Lazy.nvim bootstrap and setup
- `lua/plugins/` - Plugin configurations organized by functionality
- `lua/plugins/lsp/` - LSP-specific configurations (mason, lua_ls, typescript)

## Build/Install Commands
- `:Lazy` - Open plugin manager UI
- `:Lazy sync` - Install/update all plugins  
- `:TSUpdate` - Update treesitter parsers
- `:Mason` - Open LSP server manager
- `make` - Build command for avante.nvim plugin (run from plugin directory)

## Code Style & Conventions
- Use snake_case for file names (e.g., `avante_ai.lua`, `lazy-git-ui.lua`)
- Plugin configs return tables with plugin specs
- Use descriptive comments for keybindings with `desc` parameter
- LSP keybindings follow standard conventions: `gd` (definition), `gr` (references), `K` (hover)
- Leader key is space (`<space>`)
- Local leader is backslash (`\`)
- Prefer explicit dependency declarations in plugin specs
- Use lazy loading with `event = "VeryLazy"` for non-essential plugins
- Configure plugin options in `opts` table when possible
