#!/bin/bash
# Deploy dotfiles by creating ~/.zshrc and ~/.tmux.conf that source the repo configs

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/config"

echo "=== Deploying dotfiles from $CONFIG_DIR ==="

# Backup existing configs if they exist and aren't symlinks
backup_if_exists() {
    local file="$1"
    if [[ -f "$file" && ! -L "$file" ]]; then
        echo "Backing up $file to ${file}.backup"
        mv "$file" "${file}.backup"
    elif [[ -L "$file" ]]; then
        echo "Removing existing symlink $file"
        rm "$file"
    fi
}

# Create .zshrc that sources our config
backup_if_exists "$HOME/.zshrc"
cat > "$HOME/.zshrc" << EOF
# Source dotfiles zshrc
source "$CONFIG_DIR/zshrc.sh"
EOF
echo "Created ~/.zshrc"

# Create .tmux.conf that sources our config
backup_if_exists "$HOME/.tmux.conf"
cat > "$HOME/.tmux.conf" << EOF
# Source dotfiles tmux config
source-file "$CONFIG_DIR/tmux.conf"
EOF
echo "Created ~/.tmux.conf"

# Change default shell to zsh
if [[ "$SHELL" != *"zsh"* ]]; then
    echo "=== Changing default shell to zsh ==="
    chsh -s "$(which zsh)"
fi

echo "=== Deploy complete ==="
echo "Start a new terminal or run 'zsh' to use your new config"
