return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "stylua",
        "yamlls",
        "html-lsp",
        "css-lsp",
        "prettier",
        "gopls",
        "terraform-lsp",
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "go",
        "gomod",
        "gosum",
        "gotmpl",
        "gowork",
        "yaml",
        "terraform",
        "http",
        "json",
        "asm",
        "hcl",
        "func",
        "solidity",
        "dockerfile",
        "helm",
        "hurl",
      },
    },
  },
}
