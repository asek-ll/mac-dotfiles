-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.window_close_confirmation = 'NeverPrompt'
-- config.color_scheme = 'OneHalfLight'
-- config.color_scheme = 'Papercolor Light (Gogh)'
config.color_scheme = 'Edge Light (base16)'
-- config.font = wezterm.font 'SFMono Nerd Font'
config.font = wezterm.font('SFMono Nerd Font', { weight = 'Medium' })
config.font_size = 16
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
    left = 8,
    right = 8,
    top = 0,
    bottom = -10,
}
-- config.line_height=0.995
config.freetype_load_flags = 'NO_HINTING'
config.window_decorations = 'RESIZE'

-- and finally, return the configuration to wezterm
return config
