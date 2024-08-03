#!/bin/bash
set -e
# 1. Install Home Brew
if [[ "$(which brew)" =~ "not found" ]]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "\$(${HOMEBREW_PREFIX}/bin/brew shellenv)"' >> ~/.zprofile
  eval "\$(${HOMEBREW_PREFIX}/bin/brew shellenv)"
else
  brew update
fi

# 2. Install zsh
brew install zsh

# 3. Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 4. Install Powerlevel10k
brew install powerlevel10k

# 5. Install Nerd Fonts
echo "======= Install nerd fonts"
brew install font-hack-nerd-font \
  font-meslo-for-powerline \
  font-roboto-mono-nerd-font \
  font-source-code-pro \
  font-ubuntu-nerd-font \
  font-fantasque-sans-mono-nerd-font \
  font-mononoki-nerd-font \
  font-jetbrains-mono-nerd-font 

# 6. Install wezterm
echo "======= [BEGIN] Install wezterm"
brew install wezterm
cp -r .config/wezterm ~/.config/wezterm
echo "======= [DONE] Install wezterm"

# 7. Install sketchybar
echo "======= [BEGIN] Install sketchybar"
./.config/sketchybar/helpers/install.sh
cp -r .config/sketchybar ~/.config/sketchybar
echo "======= [DONE] Install sketchybar"

# 8. Install golang
echo "======= [BEGIN] Install Golang for: $OSKERNEL-$GOARCH"
./bin/update-go $GO_VERSION
echo "======= [DONE] Install Golang for: $OSKERNEL-$GOARCH"

# 9. Install nvm
echo "======= [BEGIN] Install NVM"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
echo "======= [DONE] Install NVM"

# 10. Install nodejs
echo "======= Install NodeJS"
nvm install --lts
nvm alias default node

# 11. Install terraform
echo "======= [BEGIN] Install Terraform"
brew install terraform terraform-docs tflint terraform-ls
echo "======= [DONE] Install Terraform"

# 12. Install neovim
echo "======= [BEGIN] Install NeoVim"
brew install neovim
cp -r .config/nvim ~/.config/nvim
bash ./install-nvim.sh
echo "======= [DONE] Install NeoVim"

# 13. Config git alias
echo "======= Configuring git alias..."
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status


# 14. Install terminal apps
echo "======= Install terminal apps"
brew tap cowsay-org/cowsay
brew install bat fd btop htop ncdu neofetch nnn tldr tree zsh-syntax-highlighting zsh-autosuggestions zsh-completions zsh-history-substring-search zsh-navigation-tools cowsay-apj fortune 2>/dev/null

