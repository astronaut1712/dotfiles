-- return {
-- 	"glepnir/oceanic-material",
-- 	config = function()
-- 		vim.cmd("set background=dark")
-- 		vim.cmd("colorscheme oceanic_material")
-- 	end,
-- }
-- return {
-- 	"catppuccin/nvim",
-- 	name = "catppuccin",
-- 	priority = 1000,
-- 	config = function()
-- 		vim.cmd("colorscheme catppuccin-mocha")
-- 	end,
-- }

return {
	"EdenEast/nightfox.nvim",
	config = function()
		-- Default options
		require("nightfox").setup({
			options = {
				-- Compiled file's destination location
				compile_path = vim.fn.stdpath("cache") .. "/nightfox",
				compile_file_suffix = "_compiled", -- Compiled file suffix
				transparent = false, -- Disable setting background
				terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
				dim_inactive = false, -- Non focused panes set to alternative background
				module_default = true, -- Default enable value for modules
				colorblind = {
					enable = false, -- Enable colorblind support
					simulate_only = false, -- Only show simulated colorblind colors and not diff shifted
					severity = {
						protan = 0, -- Severity [0,1] for protan (red)
						deutan = 0, -- Severity [0,1] for deutan (green)
						tritan = 0, -- Severity [0,1] for tritan (blue)
					},
				},
				styles = { -- Style to be applied to different syntax groups
					comments = "NONE", -- Value is any valid attr-list value `:help attr-list`
					conditionals = "NONE",
					constants = "NONE",
					functions = "NONE",
					keywords = "NONE",
					numbers = "NONE",
					operators = "NONE",
					strings = "NONE",
					types = "NONE",
					variables = "NONE",
				},
				inverse = { -- Inverse highlight for different types
					match_paren = false,
					visual = false,
					search = false,
				},
				modules = { -- List of various plugins and additional options
					-- ...
				},
			},
			palettes = {},
			specs = {},
			groups = {},
		})

		-- setup must be called before loading
		vim.cmd("colorscheme nightfox")
	end,
}

-- return {
-- 	"folke/tokyonight.nvim",
-- 	priority = 1000,
-- 	config = function()
-- 		local transparent = true
--
-- 		local bg = "#011628"
-- 		local bg_dark = "#011423"
-- 		local bg_highlight = "#143652"
-- 		local bg_search = "#0A64AC"
-- 		local bg_visual = "#275378"
-- 		local fg = "#CBE0F0"
-- 		local fg_dark = "#B4D0E9"
-- 		local fg_gutter = "#627E97"
-- 		local border = "#547998"
--
-- 		require("tokyonight").setup({
-- 			style = "night",
-- 			transparent = transparent,
-- 			styles = {
-- 				sidebars = transparent and "transparent" or "dark",
-- 				floats = transparent and "transparent" or "dark",
-- 			},
-- 			on_colors = function(colors)
-- 				colors.bg = bg
-- 				colors.bg_dark = transparent and colors.none or bg_dark
-- 				colors.bg_float = transparent and colors.none or bg_dark
-- 				colors.bg_highlight = bg_highlight
-- 				colors.bg_popup = bg_dark
-- 				colors.bg_search = bg_search
-- 				colors.bg_sidebar = transparent and colors.none or bg_dark
-- 				colors.bg_statusline = transparent and colors.none or bg_dark
-- 				colors.bg_visual = bg_visual
-- 				colors.border = border
-- 				colors.fg = fg
-- 				colors.fg_dark = fg_dark
-- 				colors.fg_float = fg
-- 				colors.fg_gutter = fg_gutter
-- 				colors.fg_sidebar = fg_dark
-- 			end,
-- 		})
--
-- 		vim.cmd("colorscheme tokyonight-storm")
-- 	end,
-- }
