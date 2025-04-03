install_tools() {
    local tools=("$@")

    for tool in "${tools[@]}"; do
        ${tool}
    done
}

terraform() {
    if ! command -v terraform &>/dev/null && [[ ! -f /etc/apt/sources.list.d/hashicorp.list ]]; then
        echo "📦 Adding Terraform repo..."
        wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    fi

    echo "📥 Installing terraform package"
    sudo apt update && sudo apt install -y \
        terraform
}

delta() {
    pushd "$HOME/dotfiles" >/dev/null

    # --- wget and un-tar delta ---
    delta_tag_name=$(curl -s https://api.github.com/repos/dandavison/delta/releases/latest | jq -r .tag_name)
    wget -qO- https://github.com/dandavison/delta/releases/download/"$delta_tag_name"/delta-"$delta_tag_name"-x86_64-unknown-linux-gnu.tar.gz |
        sudo tar -xzf - -C /usr/bin --strip-components=1 delta-"$delta_tag_name"-x86_64-unknown-linux-gnu/

    # --- setup git to use delta ---
    git config --global core.pager delta
    git config --global interactive.diffFilter 'delta --color-only'
    git config --global delta.navigate true
    git config --global delta.side-by-side true
    git config --global delta.line-numbers true
    git config --global merge.conflictStyle zdiff3
}

fzf() {
    # --- Set up fzf ---
    FZF_DIR="$HOME/.fzf"
    if [ ! -d "$FZF_DIR" ]; then
        echo "🔍 Installing fzf..."
        git clone --depth=1 https://github.com/junegunn/fzf.git "$FZF_DIR"
        "$FZF_DIR"/install --all
    else
        echo "✅ fzf already installed."
        echo "🔄 Updating fzf..."
        pushd "$FZF_DIR" >/dev/null
        git pull --rebase
        popd >/dev/null
    fi
}

bat() {
    # --- Set up zsh-bat ---
    BATCAT_DIR="${ZSH_CUSTOM:-$ZSH/custom}/plugins/zsh-bat"
    if [ ! -d "$BATCAT_DIR" ]; then
        echo "🎨 Installing zsh-bat..."
        git clone https://github.com/george-andrei/zsh-bat.git "$BATCAT_DIR"
    else
        echo "✅ zsh-bat already installed."
        echo "🔄 Updating zsh-bat..."
        pushd "$BATCAT_DIR" >/dev/null
        git pull --rebase
        popd >/dev/null
    fi
}

forgit() {
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
}

# install_tools "tool1" "tool2"

# tools=("terraform" "delta" "fzf" "bat" "forgit")
# install_tools "${tools[@]}"
