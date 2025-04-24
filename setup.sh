#!/usr/bin/env bash

set -euo pipefail

source ./tools.sh

echo "Check latest version of this repo."
pushd "$HOME/dotfiles" >/dev/null
if git diff --quiet; then
    git pull --rebase
else
    echo "Unstaged changes detected — skipping pull to avoid conflicts."
fi
popd

read -r -p "Would you like to install all tools and set up your environment? [y/N] " response
if [[ ! "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo "⚠️ Skipping install. You can run setup later or update with './setup.sh --update'"
    exit 0
fi

echo "📥 Installing required packages..."
sudo apt update && sudo apt install -y \
    mc \
    keychain \
    ncdu \
    feh \
    gzip \
    vim \
    zsh \
    stow \
    git \
    curl \
    jq \
    shellcheck \
    fonts-powerline

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

# --- install list of tools ---
tools=("terraform" "delta_install" "fzf" "bat" "forgit")
install_tools "${tools[@]}"

pushd "$HOME/dotfiles" >/dev/null
# --- Restore dotfiles with stow ---
echo "🔗 Stowing dotfiles..."
stow zsh p10k vim
popd

# --- Set zsh as default shell ---
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "🐚 Changing default shell to zsh..."
    chsh -s "$(which zsh)"
    echo "🐚 Switching to Zsh..."
    exec zsh
else
    echo "✅ zsh is already the default shell."
fi

echo -e "\n 🤖 Setup complete!"

echo -e "\n ------------------------------------------------ \n \n"
echo -e "💡 Upgradable packages \n"
apt list --upgradable
echo -e "\n \n ------------------------------------------------ \n \n"
