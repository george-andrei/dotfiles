# 🛠 Dotfiles Setup

This repository provides a streamlined and modular way to configure your development environment using **Zsh**, **Oh My Zsh**, and several useful plugins. The `setup.sh` script automates the installation and configuration process.

## 🔗 Requirements

- git
- [Nerd font](https://www.nerdfonts.com/font-downloads) (BlexMono)

## 🚀 Installation

### 1️⃣ Clone the Repository

```bash
git clone https://github.com/george-andrei/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 2️⃣ Run the Setup Script

```bash
./setup.sh
```

The script will prompt you to confirm the installation before proceeding.

## 🔄 Updating

To update all tools and plugins:

```bash
./setup.sh
```

The script will automatically update **Oh My Zsh**, **Powerlevel10k**, **fzf**, **forgit**, and **Zsh plugins**.

## ⚙️ What the Setup Script Does

1. Installs necessary packages (Zsh, Stow, etc.)
2. Clones or updates:
   - Oh My Zsh
   - Powerlevel10k theme
   - Forgit plugin
   - fzf for fuzzy searching
   - zsh-autosuggestions & zsh-syntax-highlighting
3. Uses **Stow** to manage dotfiles
4. Ensures Zsh is set as the default shell
5. Starts Zsh if not already running

## 🎨 Enable Plugins & Theme

Make sure your `~/.zshrc` includes these plugins:

```zsh
plugins=(
        git
        history
        zsh-autosuggestions
        zsh-syntax-highlighting
        aws
        terraform
        docker
        fzf
        forgit
)

source $ZSH/oh-my-zsh.sh
```

## ❌ Uninstalling

To remove the configurations and reset your shell:

```bash
stow -D zsh p10k vim
rm -rf ~/.oh-my-zsh ~/.fzf ~/.zshrc ~/.p10k.zsh
```

# 📓 Notes

- [Notes & bookmarks](./notes.md)
