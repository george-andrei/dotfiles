#!/usr/bin/env bash

set -euo pipefail

echo "Check latest version of this repo."
pushd "$HOME/dotfiles" >/dev/null
git pull --rebase
popd

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

cd ~

echo "📥 Installing required packages..."
sudo apt update && sudo apt install -y \
    mc \
    ncdu \
    feh \
    gzip \
    vim \
    zsh \
    stow \
    git \
    curl \
    jq \
    fonts-powerline \
    terraform

# --- Set up Oh My Zsh ---
ZSH="$HOME/.oh-my-zsh"
if [ ! -d "$ZSH" ]; then
    echo "🛠 Installing Oh My Zsh..."
    git clone https://github.com/ohmyzsh/ohmyzsh.git "$ZSH"
else
    echo "✅ Oh My Zsh already installed."
    echo "🔄 Updating Oh My Zsh..."
    pushd "$ZSH" >/dev/null
    git pull --rebase
    popd >/dev/null
fi

# --- Set up powerlevel10k ---
P10K_DIR="${ZSH_CUSTOM:-$ZSH/custom}/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
    echo "🎨 Installing powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
else
    echo "✅ powerlevel10k already installed."
    echo "🔄 Updating powerlevel10k..."
    pushd "$P10K_DIR" >/dev/null
    git pull --rebase
    popd >/dev/null
fi

# --- Set up forgit plugin ---
FORGIT_DIR="${ZSH_CUSTOM:-$ZSH/custom}/plugins/forgit"
if [ ! -d "$FORGIT_DIR" ]; then
    echo "🔧 Installing forgit plugin..."
    git clone https://github.com/wfxr/forgit.git "$FORGIT_DIR"
else
    echo "✅ forgit already installed."
    echo "🔄 Updating forgit..."
    pushd "$FORGIT_DIR" >/dev/null
    git pull --rebase
    popd >/dev/null
fi

# --- Set up zsh-autosuggestions ---
AUTOSUGGESTIONS_DIR="${ZSH_CUSTOM:-$ZSH/custom}/plugins/zsh-autosuggestions"
if [ ! -d "$AUTOSUGGESTIONS_DIR" ]; then
    echo "💡 Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$AUTOSUGGESTIONS_DIR"
else
    echo "✅ zsh-autosuggestions already installed."
    echo "🔄 Updating zsh-autosuggestions..."
    pushd "$AUTOSUGGESTIONS_DIR" >/dev/null
    git pull --rebase
    popd >/dev/null
fi

# --- Set up zsh-syntax-highlighting ---
SYNTAX_HIGHLIGHTING_DIR="${ZSH_CUSTOM:-$ZSH/custom}/plugins/zsh-syntax-highlighting"
if [ ! -d "$SYNTAX_HIGHLIGHTING_DIR" ]; then
    echo "🎨 Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$SYNTAX_HIGHLIGHTING_DIR"
else
    echo "✅ zsh-syntax-highlighting already installed."
    echo "🔄 Updating zsh-syntax-highlighting..."
    pushd "$SYNTAX_HIGHLIGHTING_DIR" >/dev/null
    git pull --rebase
    popd >/dev/null
fi

# --- Set up fzf ---
FZF_DIR="$HOME/.fzf"
if [ ! -d "$FZF_DIR" ]; then
    echo "🔍 Installing fzf..."
    git clone --depth=1 https://github.com/junegunn/fzf.git "$FZF_DIR"
    $FZF_DIR/install --all
else
    echo "✅ fzf already installed."
    echo "🔄 Updating fzf..."
    pushd "$FZF_DIR" >/dev/null
    git pull --rebase
    popd >/dev/null
fi

pushd "$HOME/dotfiles" >/dev/null

# --- Restore dotfiles with stow ---
echo "🔗 Stowing dotfiles..."
stow zsh p10k vim

# --- Set zsh as default shell ---
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "🐚 Changing default shell to zsh..."
    chsh -s "$(which zsh)"
else
    echo "✅ zsh is already the default shell."
fi

# --- Switch to zsh ---
if [[ -n "${ZSH_VERSION-}" ]]; then
    echo "✅ Already running Zsh."
else
    echo "🐚 Switching to Zsh..."
    exec zsh
fi

echo "🤖 Setup complete!"
