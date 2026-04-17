-- Define autocommands with Lua APIs
-- See: h:api-autocmd, h:augroup

local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd -- Create autocommand

-- Set indentation to 2 spaces
augroup("setIndent", { clear = true })
autocmd("Filetype", {
	group = "setIndent",
	pattern = { "go" },
	callback = function(args)
		vim.treesitter.start()
		vim.bo[args.buf].expandtab = true
		vim.bo[args.buf].shiftwidth = 4
		vim.bo[args.buf].tabstop = 4
		-- vim.bo[args.buf].softtabstop = 4
	end,
})
autocmd("Filetype", {
	group = "setIndent",
	pattern = { "lua" },
	command = "setlocal shiftwidth=2 tabstop=2",
})
