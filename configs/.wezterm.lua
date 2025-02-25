-- ln -sf ~/projects/nvim/configs/.wezterm.lua ~/.wezterm.lua
local wezterm = require("wezterm")

return {
    max_fps = 240,
	-- font
	font = wezterm.font("Iosevka Nerd Font Mono", { weight = "Medium" }),
	font_size = 12,
	line_height = 1,
	use_fancy_tab_bar = false,
	enable_tab_bar = false,
}
