#!/usr/bin/env bash

set -e

# Set git config options
git config --global user.name "Samuel Attard"
git config --global user.email "samuel.r.attard@gmail.com"
git config --global commit.gpgsign true
git config --global tag.gpgsign true
git config --global pull.rebase false
git config --global init.defaultBranch main

# Install stuff
sudo apt update

sudo touch /etc/zsh/zlogin && sudo mv /etc/zsh/zlogin /etc/zsh/zlogin.bak
sudo apt --yes install zsh python3-dev python3-pip python3-setuptools direnv
sudo rm /etc/zsh/zlogin && sudo mv /etc/zsh/zlogin.bak /etc/zsh/zlogin

sudo pip3 install thefuck
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash

# Install oh-my-zsh
sudo rm -rf $HOME/.oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Configure pure prompt
mkdir -p "$HOME/.zsh"
git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"

# Configure zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Configure zsh
cp .zshrc ~/.zshrc

# Set up default node
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install $(node -v) || true
nvm use --delete-prefix $(node -v) || true
nvm alias default $(node -v)

# Configure bash to spawn zsh
echo "zsh || true" >> ~/.bashrc
echo "exit" >> ~/.bashrc
