#!/usr/bin/env bash

set -euo pipefail

MODE=${1:-}

# --- Update mode ---
if [[ "$MODE" == "--update" ]]; then
    echo "🔄 Updating system packages..."
    sudo apt update && sudo apt upgrade -y

    echo "🔁 Pulling latest dotfiles repo changes..."
    git pull --rebase

    echo "📦 Updating git submodules..."
    git submodule update --init --recursive
    git submodule foreach git pull origin master

    echo "🔗 Restowing dotfiles..."
    stow zsh p10k vim

    echo "✅ Update complete!"
    exit 0
fi

read -r -p "Would you like to install all tools and set up your environment? [y/N] " response
if [[ ! "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo "⚠️ Skipping install. You can run setup later or update with './setup.sh --update'"
    exit 0
fi

if ! command -v terraform &>/dev/null && [[ ! -f /etc/apt/sources.list.d/hashicorp.list ]]; then
    echo "📦 Adding Terraform repo..."
    wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
fi

echo "Updating system packages..."
sudo apt update -y 2 &>/dev/null

cd ~

echo "📥 Installing required packages..."
sudo apt update && sudo apt install -y \
    feh \
    gzip \
    vim \
    zsh \
    stow \
    git \
    curl \
    fonts-powerline \
    terraform

mkdir -p ~/temp

echo "📂 Initializing git submodules..."
git submodule update --init --recursive

echo "🔗 Stowing dotfiles..."
stow zsh p10k vim

echo "Check oh-my-zsh"
ZSH_DIR="$HOME/dotfiles/oh-my-zsh"
if [[ ! -f "$ZSH_DIR/oh-my-zsh.sh" ]]; then
    echo "❌ oh-my-zsh is missing or not fully initialized."
    echo "Run: git submodule update --init --recursive"
    exit 1
fi

if [[ "$SHELL" != "$(which zsh)" ]]; then
    echo "🐚 Changing default shell to zsh..."
    chsh -s "$(which zsh)"
else
    echo "✅ zsh is already your default shell."
fi

echo "🎉 Setup complete! Launch a new terminal session to enjoy your setup."
