local wezterm = require 'wezterm'
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Color scheme
config.color_scheme = 'Catppuccin Mocha' -- or 'Dracula', 'Tokyo Night', etc.

-- Font configuration
config.font = wezterm.font('JetBrains Mono', { weight = 'Medium' })
config.font_size = 14.0

-- Window settings
config.window_background_opacity = 0.9
config.window_decorations = "RESIZE" -- or "TITLE" | "NONE"
config.window_close_confirmation = 'AlwaysPrompt'

-- Tab bar
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = false
config.use_fancy_tab_bar = true

-- Scrollback
config.scrollback_lines = 10000

-- Cursor
config.default_cursor_style = 'BlinkingBlock'
config.cursor_blink_rate = 500

-- Key bindings (optional)
config.keys = {
  {
    key = 't',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SpawnTab 'CurrentPaneDomain',
  },
  {
    key = 'w',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.CloseCurrentTab { confirm = true },
  },
}

return config
