#!/bin/bash
set -e
# 1. Install Home Brew
if [[ "$(which brew)" =~ "not found" ]]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "\$(${HOMEBREW_PREFIX}/bin/brew shellenv)"' >> ~/.zprofile
  eval "\$(${HOMEBREW_PREFIX}/bin/brew shellenv)"
fi

# 2. Install zsh
brew install zsh

# 3. Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 4. Install Powerlevel10k
brew install powerlevel10k

# 5. Install Nerd Fonts
brew install font-hack-nerd-font \
  font-meslo-for-powerline \
  font-roboto-mono-nerd-font \
  font-sourcecodepro-nerd-font \
  font-ubuntu-nerd-font \
  font-fantasque-sans-mono-nerd-font \
  font-mononoki-nerd-font \
  font-iosevka-nerd-font \
  font-jetbrains-mono-nerd-font \
  font-cascadia-nerd-font

# 6. Install FZF
brew install ripgrep fzf

# 7. Install terminal apps
brew tap cowsay-org/cowsay
brew install bat exa fd btop htop ncdu neofetch nnn tldr tree zsh-syntax-highlighting zsh-autosuggestions zsh-completions zsh-history-substring-search zsh-navigation-tools cowsay-apj fortune

# 8. Install wezterm
brew install wezterm
cp -r .config/wezterm ~/.config/wezterm

# 9. Install sketchybar
./config/sketchybar/helpers/install.sh
mv ~/.config/sketchybar ~/.config/sketchybar.bak
cp -r .config/sketchybar ~/.config/sketchybar

# 10. Install golang
echo "======= Install Golang for: $OSKERNEL-$GOARCH"
./bin/update-go 1.22.5

# 11. Install nvm
echo "======= Install NVM"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
source ~/.zshrc

# 12. Install nodejs
echo "======= Install NodeJS"
nvm install --tls
nvm alias default node

# 13. Install terraform
echo "======= Install Terraform"
brew install terraform terraform-docs tflint terraform-ls

# 14. Install neovim
brew install neovim
cp -r .config/nvim ~/.config/nvim
bash ./install-nvim.sh

# 15. Config git alias
echo "======= Configuring git alias..."
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status

