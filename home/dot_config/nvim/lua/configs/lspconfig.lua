local nvlsp = require("nvchad.configs.lspconfig")

-- Default config applied to all servers (Neovim 0.11+ / nvim-lspconfig v1.0+)
vim.lsp.config("*", {
	on_attach = nvlsp.on_attach,
	on_init = nvlsp.on_init,
	capabilities = nvlsp.capabilities,
})

-- Enable servers (nvim-lspconfig provides default cmd/filetypes/root_markers)
vim.lsp.enable({
	"html",
	"cssls",
	"gopls",
	"yamlls",
	"terraformls",
	"ts_ls",
})
