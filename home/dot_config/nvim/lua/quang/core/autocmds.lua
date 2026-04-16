-- Define autocommands with Lua APIs
-- See: h:api-autocmd, h:augroup

local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd -- Create autocommand

-- Set indentation to 2 spaces
augroup("setIndent", { clear = true })
autocmd("Filetype", {
  group = "setIndent",
  pattern = { "go" },
  command = "setlocal shiftwidth=4 tabstop=4",
})

autocmd("FileType", {
  group = vim.api.nvim_create_augroup("FixTerraformCommentString", { clear = true }),
  callback = function(ev)
    vim.bo[ev.buf].commentstring = "# %s"
  end,
  pattern = { "terraform", "hcl" },
})

autocmd("BufWritePre", {
  pattern = { "*.tf", "*.hcl", "*.tfvars" },
  callback = function()
    vim.lsp.buf.format()
  end,
})

vim.filetype.add {
  extension = {
    tfvars = "hcl",
    yamltpl = "yaml",
    http = "hurl",
    goenv = "dotenv",
  },
}
