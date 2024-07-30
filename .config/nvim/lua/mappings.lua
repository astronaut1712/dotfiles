require "nvchad.mappings"

local map = vim.keymap.set
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvchad/mappings.lua
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
-- terminal
map("t", "<C-x>", "<C-\\><C-N>", { desc = "terminal escape terminal mode" })

-- Go
map("n", "gl", "<cmd>GoLintEx<CR>", { desc = "Go lint" })
