-- Define autocommands with Lua APIs
-- See: h:api-autocmd, h:augroup

local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd -- Create autocommand

-- Set indentation to 2 spaces
augroup("setIndent", { clear = true })
autocmd("Filetype", {
  group = "setIndent",
  pattern = {
    "go",
    "python",
    "javascript",
    "typescript",
    "gomod",
    "gosum",
    "svelte",
    "vue",
    "regex",
    "tsx",
    "jsx",
  },
  command = "setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4",
})
autocmd("Filetype", {
  group = "setIndent",
  pattern = { "lua", "rust", "yaml", "markdown", "html", "css", "json" },
  command = "setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2",
})

autocmd("BufReadPre", {
  callback = function()
    local size = vim.fn.getfsize(vim.fn.expand "%")
    if size > 200 * 1024 then
      vim.opt.cursorline = false
      vim.opt.colorcolumn = ""
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    pcall(vim.treesitter.start)
  end,
})

local create_cmd = vim.api.nvim_create_user_command

create_cmd("TSInstallAll", function()
  local spec = require("lazy.core.config").plugins["nvim-treesitter"]
  local opts = type(spec.opts) == "table" and spec.opts or {}
  require("nvim-treesitter").install(opts.ensure_installed)
end, {})
