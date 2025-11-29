# Aliases for RunPod Slurm cluster

# =============================================================================
# Slurm Job Management
# =============================================================================

# View queue
alias q='squeue -o "%.18i %.9P %.30j %.8u %.2t %.10M %.4D %R"'
alias qme='squeue -u $(whoami) -o "%.18i %.9P %.30j %.8u %.2t %.10M %.4D %R"'
alias qnode='sinfo -N -l'
alias qall='squeue -o "%.18i %.9P %.30j %.8u %.2t %.10M %.4D %R %b"'

# Cancel jobs
alias scancel='scancel'
alias scancelme='scancel -u $(whoami)'

# Job info
alias sj='sacct -j'
alias sjob='scontrol show job'

# Quick interactive dev session (auto-killed at midnight PT)
alias dev='srun -p dev,overflow --qos=dev --cpus-per-task=8 --gres=gpu:1 --job-name=D_$(whoami) --mem=32G --pty zsh'
alias dev2='srun -p dev,overflow --qos=dev --cpus-per-task=16 --gres=gpu:2 --job-name=D_$(whoami) --mem=64G --pty zsh'
alias dev4='srun -p dev,overflow --qos=dev --cpus-per-task=32 --gres=gpu:4 --job-name=D_$(whoami) --mem=128G --pty zsh'
alias dev8='srun -p dev,overflow --qos=dev --cpus-per-task=64 --gres=gpu:8 --job-name=D_$(whoami) --mem=256G --pty zsh'

# Submit jobs with different priorities
# Usage: qrun <script.sh> - submits with high priority
qrun() {
    sbatch -p general --qos=high "$@"
}

# Usage: qrunlow <script.sh> - submits with low priority (can be preempted)
qrunlow() {
    sbatch -p general,overflow --qos=low "$@"
}

# =============================================================================
# Tmux Session Management
# =============================================================================

alias ta='tmux attach -t'
alias taa='tmux attach'
alias td='tmux detach'
alias ts='tmux new-session -s'
alias tl='tmux list-sessions'
alias tk='tmux kill-session -t'
alias tka='tmux kill-server'

# =============================================================================
# Directory Navigation
# =============================================================================

alias vast='cd /workspace-vast/$(whoami)'
alias vastgit='cd /workspace-vast/$(whoami)/git'
alias vastexp='cd /workspace-vast/$(whoami)/exp'

# =============================================================================
# Utility
# =============================================================================

# GPU monitoring
alias gpus='nvidia-smi'
alias gpuwatch='watch -n 1 nvidia-smi'

# Disk usage
alias usage='du -sh * | sort -h'
alias duh='du -h --max-depth=1 | sort -h'
