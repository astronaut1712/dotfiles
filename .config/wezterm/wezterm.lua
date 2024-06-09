local wezterm = require("wezterm")
local utils = require("utils")
local scheme = wezterm.get_builtin_color_schemes()["nord"]
local gpus = wezterm.gui.enumerate_gpus()
require("on")
local keybinds = require("keybinds")
local dimmer = { brightness = 0.1 }


---------------------------------------------------------------
--- Config
---------------------------------------------------------------
local config = {
  initial_cols = 120,
	font = wezterm.font("FiraCode Nerd Font Mono"),
	font_size = 14,
	-- cell_width = 1.1,
	-- line_height = 1.3,
	font_rules = {
		{
			italic = true,
			font = wezterm.font("FiraCode Nerd Font Mono", { italic = true }),
		},
		{
			italic = true,
			font = wezterm.font("JetBrainsMono Nerd Font Mono", { weight = "Bold", italic = true }),
		},
		{
			italic = true,
			font = wezterm.font("Hack Nerd Font Mono", { weight = "Bold", italic = true }),
		},
	},
	check_for_updates = true,
	use_ime = true,
	ime_preedit_rendering = "Builtin",
	-- use_dead_keys = false,
	warn_about_missing_glyphs = false,
	-- enable_kitty_graphics = false,
	animation_fps = 1,
	cursor_blink_ease_in = "Constant",
	cursor_blink_ease_out = "Constant",
	cursor_blink_rate = 0,
	color_scheme = "nordfox",
	color_scheme_dirs = { os.getenv("HOME") .. "/.config/wezterm/colors/" },
	hide_tab_bar_if_only_one_tab = false,
	adjust_window_size_when_changing_font_size = false,
	selection_word_boundary = " \t\n{}[]()\"'`,;:│=&!%",
  window_decorations = 'None',
	window_padding = {
		left = 2,
		right = 0,
		top = 10,
		bottom = 0,
	},
	use_fancy_tab_bar = false,
	tab_bar_at_bottom = false,
	colors = {
		tab_bar = {
			background = scheme.background,
			new_tab = { bg_color = "#2e3440", fg_color = scheme.ansi[8], intensity = "Bold" },
			new_tab_hover = { bg_color = scheme.ansi[1], fg_color = scheme.brights[8], intensity = "Bold" },
			-- format-tab-title
			-- active_tab = { bg_color = "#121212", fg_color = "#FCE8C3" },
			-- inactive_tab = { bg_color = scheme.background, fg_color = "#FCE8C3" },
			-- inactive_tab_hover = { bg_color = scheme.ansi[1], fg_color = "#FCE8C3" },
		},
	},
	exit_behavior = "CloseOnCleanExit",
	window_close_confirmation = "AlwaysPrompt",
	window_background_opacity = 0.9,
  background = {
    {
      source = {
        File = os.getenv("HOME")..'/Pictures/wezterm_goku.jpg',
      },
      width = '100%',
      repeat_x = 'NoRepeat',
      hsb = dimmer,
      attachment = { Parallax = 0.1 },
    },
  },
	-- disable_default_key_bindings = true,
	-- visual_bell = {
	-- 	fade_in_function = "EaseIn",
	-- 	fade_in_duration_ms = 150,
	-- 	fade_out_function = "EaseOut",
	-- 	fade_out_duration_ms = 150,
	-- },
	-- separate <Tab> <C-i>
	-- enable_csi_u_key_encoding = true,
	leader = { key = "Space", mods = "ALT" },
	-- keys = keybinds.create_keybinds(),
	-- key_tables = keybinds.key_tables,
	-- mouse_bindings = keybinds.mouse_bindings,
	-- https://github.com/wez/wezterm/issues/2756
	webgpu_preferred_adapter = gpus[1],
	front_end = "OpenGL",
}

config.hyperlink_rules = {
	-- Matches: a URL in parens: (URL)
	{
		regex = '\\((\\w+://\\S+)\\)',
		format = '$1',
		highlight = 1,
	},
	-- Matches: a URL in brackets: [URL]
	{
		regex = '\\[(\\w+://\\S+)\\]',
		format = '$1',
		highlight = 1,
	},
	-- Matches: a URL in curly braces: {URL}
	{
		regex = '\\{(\\w+://\\S+)\\}',
		format = '$1',
		highlight = 1,
	},
	-- Matches: a URL in angle brackets: <URL>
	{
		regex = '<(\\w+://\\S+)>',
		format = '$1',
		highlight = 1,
	},
	-- Then handle URLs not wrapped in brackets
	{
		-- Before
		--regex = '\\b\\w+://\\S+[)/a-zA-Z0-9-]+',
		--format = '$0',
		-- After
		regex = '[^(]\\b(\\w+://\\S+[)/a-zA-Z0-9-]+)',
		format = '$1',
		highlight = 1,
	},
	-- implicit mailto link
	{
		regex = '\\b\\w+@[\\w-]+(\\.[\\w-]+)+\\b',
		format = 'mailto:$0',
	},
}
table.insert(config.hyperlink_rules, {
	regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]],
	format = "https://github.com/$1/$3",
})

local merged_config = utils.merge_tables(config, keybinds)
return utils.merge_tables(merged_config, {})
