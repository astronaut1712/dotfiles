#!/bin/bash
echo "======= Install dependencies"
brew tap superbrothers/zsh-kubectl-prompt
brew install zsh curl git tmux wget vim jq ctags fzf python  lazygit kubeseal tig k9s kubectl zsh-kubectl-prompt rbenv ruby-build
sudo ln -s -f /opt/homebrew/bin/python3 /usr/local/bin/python
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
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k

# Install golang
echo "======= Install Golang for: $OSKERNEL-$GOARCH"
curl -L -O https://golang.org/dl/go${GO_VERSION}.${OSKERNEL}-${GOARCH}.tar.gz
sudo rm -rf /usr/local/go
sudo tar xvf go${GO_VERSION}.${OSKERNEL}-${GOARCH}.tar.gz -C /usr/local
rm -f go${GO_VERSION}.${OSKERNEL}-${GOARCH}.tar.gz

# Install rust
# echo "======= Install Rust..."
# curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install nodejs
echo "======= Install NodeJS..."
export NVM_DIR="$HOME/.nvm" && (
  git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
  cd "$NVM_DIR"
  git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
) && \. "$NVM_DIR/nvm.sh"


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
ln -s $PWD/.vimrc.funcs ~/.vimrc.funcs

# Config git alias
echo "======= Configuring git alias..."
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status

# Cowsay
brew tap cowsay-org/cowsay
brew install cowsay-apj
brew install fortune

# Setup vim
# vim +PlugInstall

# Install nerdfonts
echo "======= Install NerdFonts..."
git clone --depth=1 -q https://github.com/ryanoasis/nerd-fonts.git 
cd nerd-fonts
./install.sh

cd ..
# Install terraform & terraform for vim
echo "======= Install Terraform..."
./install-tf.sh
cd ..
