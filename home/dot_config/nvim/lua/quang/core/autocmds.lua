-- Define autocommands with Lua APIs
-- See: h:api-autocmd, h:augroup

local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd -- Create autocommand

-- Set indentation to 2 spaces
augroup("setIndent", { clear = true })
augroup("enableTreesitter", { clear = true })
autocmd("Filetype", {
	group = "enableTreesitter",
	pattern = {
		"go",
		"python",
		"javascript",
		"typescript",
		"gomod",
		"gosum",
		"lua",
		"svelte",
		"vue",
		"regex",
	},
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
	pattern = { "lua", "rust", "yaml", "markdown", "html", "css", "json", "tsx", "jsx" },
	callback = function(args)
		vim.treesitter.start()
		vim.bo[args.buf].expandtab = true
		vim.bo[args.buf].shiftwidth = 2
		vim.bo[args.buf].tabstop = 2
		vim.bo[args.buf].softtabstop = 2
	end,
})

autocmd("BufReadPre", {
	callback = function()
		local size = vim.fn.getfsize(vim.fn.expand("%"))
		if size > 200 * 1024 then
			vim.opt.cursorline = false
			vim.opt.colorcolumn = ""
			vim.opt.syntax = "off"
			vim.opt.wrap = false
		end
	end,
})
