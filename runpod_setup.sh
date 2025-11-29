#!/bin/bash
# Full setup script for RunPod Slurm cluster
# Usage: curl -s https://raw.githubusercontent.com/dillonplunkett/runpod_dotfiles/main/runpod_setup.sh | bash

set -e

USER=$(whoami)
VAST_DIR="/workspace-vast/$USER"

echo "=============================================="
echo "  RunPod Cluster Setup for $USER"
echo "=============================================="

# 1) Install system dependencies
echo ""
echo "=== [1/6] Installing system dependencies ==="
sudo apt-get update
sudo apt-get install -y \
    less nano htop ncdu nvtop lsof rsync btop jq \
    zsh tmux git curl fzf \
    nodejs npm

# 2) Create VAST directory structure
echo ""
echo "=== [2/6] Creating directories on VAST ==="
mkdir -p "$VAST_DIR/git" "$VAST_DIR/exp" "$VAST_DIR/envs"
mkdir -p "$VAST_DIR/.uv/python" "$VAST_DIR/.cache/uv"

# 3) Setup uv and Python virtual environment
echo ""
echo "=== [3/6] Setting up uv and Python ==="
export UV_PYTHON_INSTALL_DIR="$VAST_DIR/.uv/python"
export UV_CACHE_DIR="$VAST_DIR/.cache/uv"

curl -LsSf https://astral.sh/uv/install.sh | sh
source "$HOME/.local/bin/env"

cd "$VAST_DIR/envs"
uv python install 3.11
uv venv
source .venv/bin/activate
uv pip install ipykernel
python -m ipykernel install --user --name=venv

# 4) Clone and setup dotfiles
echo ""
echo "=== [4/6] Setting up dotfiles ==="
cd "$VAST_DIR/git"
if [[ ! -d "dotfiles" ]]; then
    git clone https://github.com/dillonplunkett/runpod_dotfiles.git dotfiles
fi
cd dotfiles
chmod +x install.sh deploy.sh
./install.sh
./deploy.sh

# 5) Setup git config
echo ""
echo "=== [5/6] Configuring git ==="
read -p "Enter your git email: " GIT_EMAIL
read -p "Enter your git name: " GIT_NAME
git config --global user.email "$GIT_EMAIL"
git config --global user.name "$GIT_NAME"

# 6) Install Claude Code
echo ""
echo "=== [6/6] Installing Claude Code ==="
sudo npm install -g @anthropic-ai/claude-code

echo ""
echo "=============================================="
echo "  Setup complete!"
echo "=============================================="
echo ""
echo "Next steps:"
echo "  1. Reconnect your terminal or run 'zsh'"
echo "  2. Run 'claude' to authenticate Claude Code"
echo "  3. Generate SSH key for GitHub: ssh-keygen -t ed25519"
echo "     Then add to GitHub: cat ~/.ssh/id_ed25519.pub"
echo ""
