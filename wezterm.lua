local wezterm = require 'wezterm'

local config = {
  font = wezterm.font_with_fallback(
    {
      "JetBrains Mono",
      { family = "Symbols Nerd Font Mono", scale = 0.90  }
    }
  )
}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.color_scheme = 'Catppuccin Macchiato'

config.hide_tab_bar_if_only_one_tab = true

config.window_background_opacity = 1

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

return config
