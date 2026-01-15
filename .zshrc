# History
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# Navigation
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_SILENT

# Completion
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Colors
autoload -Uz colors && colors
export CLICOLOR=1

# Git prompt
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' %F{green}(%b)%f'
setopt PROMPT_SUBST
PROMPT='%F{blue}%~%f${vcs_info_msg_0_} %# '

# Key bindings - up/down search history based on what's typed
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward

# Aliases
alias ll='ls -la'
alias la='ls -A'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias e='code'


alias g='git'
alias gs='git status'
alias gd='git diff'
alias gc='git commit'
alias gco='git checkout'
alias gb='git branch'
alias gl='git log --oneline -20'
alias gp='git push'
alias gpu='git pull'

alias cc='pwd | tr -d "\n" | pbcopy && echo "Copied: $(pwd)"'

# Functions
mkcd() { mkdir -p "$1" && cd "$1" }

# Rust
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# Local overrides (not tracked)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
