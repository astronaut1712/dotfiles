#!/bin/bash
echo "======= Install dependencies..."
sudo apt update
sudo apt install zsh curl git tmux wget vim jq
echo "======= Install oh-my-zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "======= Install themes/plugins for oh-my-zsh..."
ZSH_CUSTOM=$HOME/.oh-my-zsh/custom
mkdir  -p $ZSH_CUSTOM/plugins
mkdir  -p $ZSH_CUSTOM/themes
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
wget -O $ZSH_CUSTOM/themes/pi.zsh-theme https://raw.githubusercontent.com/tobyjamesthomas/pi/master/pi.zsh-theme
git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10

# Install golang
echo "======= Install Golang for: $OSKERNEL-$GOARCH"
curl -L -O https://golang.org/dl/go${GO_VERSION}.${OSKERNEL}-${GOARCH}.tar.gz
ls -l
sudo tar xvf -C /usr/local/go go${GO_VERSION}.${OSKERNEL}-${GOARCH}.tar.gz

# Install rust
# echo "======= Install Rust..."
# curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install nodejs
echo "======= Install NodeJS..."
sudo apt install node

# Config tmux
echo "======= Setup Tmux..."
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
pip3 install powerline-status
pip3 install pyvim

mv ~/.zshrc ~/.zshrc.bak 2>/dev/null
ln -s $PWD/.zshrc ~/.zshrc
ln -s $PWD/.tmux.conf ~/.tmux.conf
ln -s $PWD/.vimrc ~/.vimrc
ln -s $PWD/.vimrc.local.bundles ~/.vimrc.local.bundles
ln -s $PWD/.vimrc.func ~/.vimrc.func

# Config git alias
echo "======= Configuring git alias..."
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status


# Install nerdfonts
echo "======= Install NerdFonts..."
git clone --depth=1 -q https://github.com/ryanoasis/nerd-fonts.git 
cd nerd-fonts
./install.sh

cd ..
# Install terraform & terraform for vim
echo "======= Install Terraform..."
./install-tf.sh

