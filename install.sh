#!/bin/bash
GO_VERSION=${GO_VERSION:-1.14.7}

brew install zsh curl git tmux
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
cp .zshrc ~/

# Install golang
OSKERNEL=$(uname -s | awk '{print tolower($0)}')
curl https://golang.org/dl/go${GO_VERSION}.${OSKERNEL}-amd64.tar.gz
sudo tar xvf -C /usr/local/go go${GO_VERSION}.${OSKERNEL}-amd64.tar.gz

# Install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install vim
git clone https://github.com/astronaut1712/vim-ide.git
cd vim-ide
./install.sh

# Config tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
cp .tmux.conf ~/.tmux.conf

go get -u github.com/arl/gitmux
