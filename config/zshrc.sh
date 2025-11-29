# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to config directory (where this file lives)
CONFIG_DIR="$(dirname "$(readlink -f "${(%):-%x}")")"

# Set path to oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load.
ZSH_THEME="powerlevel10k/powerlevel10k"

# Autocomplete _ and - interchangeably. Requires case-insensitive completion.
HYPHEN_INSENSITIVE="true"

# Set format of timestamp in `history` command.
HIST_STAMPS="yyyy-mm-dd"

plugins=(
  git vscode z zsh-autosuggestions zsh-syntax-highlighting
  zsh-history-substring-search
)

# zsh-completions has to be loaded like this
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
autoload -U compinit && compinit

source $ZSH/oh-my-zsh.sh

# User configuration

# Source additional config files
[[ -f "$CONFIG_DIR/aliases.sh" ]] && source "$CONFIG_DIR/aliases.sh"
[[ -f "$CONFIG_DIR/p10k.zsh" ]] && source "$CONFIG_DIR/p10k.zsh"

# RunPod cluster settings
export HF_HOME=/workspace-vast/pretrained_ckpts
export UV_PYTHON_INSTALL_DIR=/workspace-vast/$(whoami)/.uv/python
export UV_CACHE_DIR=/workspace-vast/$(whoami)/.cache/uv

# Initialize uv if installed
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# Auto-activate venv if it exists
[[ -f "/workspace-vast/$(whoami)/envs/.venv/bin/activate" ]] && source "/workspace-vast/$(whoami)/envs/.venv/bin/activate"

# Initialize fzf if installed (for Ctrl+R history search, etc.)
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
command -v fzf &> /dev/null && eval "$(fzf --zsh 2>/dev/null)"

# Personal aliases
alias zshconfig="code ~/.zshrc"
alias mv="mv -iv"
alias cp="cp -iv"
alias lt='ll -tr'
