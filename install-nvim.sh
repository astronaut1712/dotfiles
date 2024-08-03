#!/bin/bash

# Install neovim
brew install neovim
cp -r .config/nvim ~/.config/nvim

# Install language servers
brew install lua-language-server \
  typescript-language-server \
  bash-language-server \
  terraform-ls \
  yaml-language-server

# Install neovim plugins
brew install lazygit

