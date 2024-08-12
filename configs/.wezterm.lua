-- ln -sf ~/projects/nvim/configs/.wezterm.lua ~/.wezterm.lua
local wezterm = require("wezterm")

return {
	default_cursor_style = "BlinkingBlock",
	colors = {
		cursor_bg = "#A6ACCD",
		cursor_border = "#A6ACCD",
		cursor_fg = "#1B1E28",
	},
	-- font
	font = wezterm.font("JetBrains Mono", { weight = "Medium" }),
	font_size = 12,
	line_height = 1,
	-- tab bar
	use_fancy_tab_bar = false,
	enable_tab_bar = false,
}
