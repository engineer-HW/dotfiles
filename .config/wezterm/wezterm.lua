local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- 見た目
config.font_size = 12.0
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.window_decorations = "RESIZE"
config.use_fancy_tab_bar = true
config.show_new_tab_button_in_tab_bar = false

config.colors = {
  foreground = "#E6D6C2",
  background = "#111111",

  cursor_bg = "#FFB86C",
  cursor_fg = "#111111",
  cursor_border = "#FFB86C",

  tab_bar = {
    inactive_tab_edge = "none",
  },
}

-- タブバー設定
config.window_frame = {
  inactive_titlebar_bg = "none",
  active_titlebar_bg = "none",
}

config.window_background_gradient = {
  colors = { "#000000" },
}

local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local background = "#1A1A1A"
  local foreground = "#E6D6C2"
  local edge_background = "none"

  if tab.is_active then
    background = "#FFB86C"
    foreground = "#111111"
  elseif hover then
    background = "#2A2A2A"
    foreground = "#E6D6C2"
  end

  local edge_foreground = background
  local title = "  " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "  "

  return {
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_LEFT_ARROW },

    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = title },

    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_RIGHT_ARROW },
  }
end)

-- 背景を透過
config.window_background_opacity = 0.85

if wezterm.target_triple:find("windows") then
  config.win32_system_backdrop = "Acrylic"
elseif wezterm.target_triple:find("darwin") then
  config.macos_window_background_blur = 20
end

-- OSごとのデフォルトシェル
if wezterm.target_triple:find("windows") then
  config.default_prog = { "powershell.exe" }
elseif wezterm.target_triple:find("darwin") then
  config.default_prog = { "/bin/zsh" }
else
  config.default_prog = { "/bin/bash" }
end

config.keys = require("keybinds").keys
config.key_tables = require("keybinds").key_tables

config.leader = { key = "q", mods = "CTRL", timeout_milliseconds = 2000 }

return config