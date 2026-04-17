return {
	"lukas-reineke/indent-blankline.nvim",
	enabled = false,
	event = { "BufReadPre", "BufNewFile" },
	main = "ibl",
	---@module "ibl"
	---@type ibl.config
	opts = {
		-- indent = { char = "┊" },
	},
}
