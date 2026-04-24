return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	version = "*",
	opts = {
		options = {
			mode = "buffers",
			seperator_style = "slant",
			show_indicator = true,
			indicator = {
				style = "icon",
				icon = "▎",
			},
			offsets = {
				{
					filetype = "NvimTree",
					text = "File Explorer",
					text_align = "center",
					separator = false,
				},
			},
		},
	},
}
