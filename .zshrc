# ==========================================
# PATH Configuration
# ==========================================
# Add custom bin directories to PATH
export PATH=$HOME/.config/bin:$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# ==========================================
# Oh My Zsh Configuration
# ==========================================
# Path to your Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme (robbyrussell is clean and fast)
ZSH_THEME="robbyrussell"

# ==========================================
# Oh My Zsh Settings (Optimized)
# ==========================================
# Auto-update without asking (keeps tools current)
zstyle ':omz:update' mode auto

# How often to auto-update (in days)
zstyle ':omz:update' frequency 13

# Enable command auto-correction (suggests fixes for typos)
ENABLE_CORRECTION="true"

# Show dots while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Show timestamps in history (useful for debugging)
HIST_STAMPS="yyyy-mm-dd"

# Speed up git status in large repositories (uncomment if needed)
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# ==========================================
# Plugins
# ==========================================
plugins=(
  git                      # Git integration and aliases
  z                       # Jump to directories based on frequency/recency
  zsh-autosuggestions     # Fish-like autosuggestions
  zsh-syntax-highlighting # Syntax highlighting for commands
  web-search              # Enables 'google' command for web searches
  history                 # History command enhancements
  docker                  # Docker commands completion and aliases
  colored-man-pages       # Adds colors to man pages
  extract                 # 'x' command to extract archives
  command-not-found       # Suggests packages for missing commands
  copypath                # Copy current directory path to clipboard
  dirhistory              # Navigation with Alt+Left/Right/Up
  zsh-autocomplete
)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh
# ==========================================
# User Configuration
# ==========================================
# Language environment
export LANG=en_US.UTF-8

# Preferred editor (change 'code' to 'vim' or 'nvim' if preferred)
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'  # Use vim when SSHing
else
  export EDITOR='nvim' # Use VS Code locally
fi

# ==========================================
# Development Tools
# ==========================================
#
# Bun
export PATH="/Users/saadosman/.bun/bin:$PATH"

# Android Development Commands
# Source Android-specific commands from separate file
if [ -f ~/.config/zsh/android-commands.zsh ]; then
    source ~/.config/zsh/android-commands.zsh
fi

source ~/.config/zsh/java.zsh

# ==========================================
# API Keys and Secrets
# ==========================================
# Source secrets file if it exists (more secure than inline keys)
if [ -f ~/.config/secrets.zsh ]; then
  source ~/.config/secrets.zsh
else
  # Fallback (consider moving to ~/.config/secrets.zsh)
  export GEMINI_API_KEY=AIzaSyC3NkQN4gDIID18vGRR9V5OLBjUD08roFg
fi


# ==========================================
# Helpful Aliases
# ==========================================
# Git shortcuts
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gpl='git pull'
alias gco='git checkout'
alias gb='git branch'
alias glog='git log --oneline --graph --decorate'

# Directory navigation
alias ll='ls -alh'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Quick edits
alias zshconfig='$EDITOR ~/.zshrc'
alias ohmyzsh='$EDITOR ~/.oh-my-zsh'
alias reload='source ~/.zshrc'

# Safety nets
alias rm='rm -i'  # Confirm before removing
alias cp='cp -i'  # Confirm before overwriting
alias mv='mv -i'  # Confirm before overwriting

# Shortcuts
alias h='history'
alias c='clear'
alias code.='code .'

# Show/hide hidden files in Finder (macOS)
alias showfiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder'
alias hidefiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder'

# IP addresses
alias ip='curl -s ifconfig.me'
alias localip='ipconfig getifaddr en0'

# ==========================================
# Custom Functions
# ==========================================
# Create directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Search history
hgrep() {
    history | grep "$1"
}


# Quick backup of a file
backup() {
    cp "$1" "$1.backup-$(date +%Y%m%d-%H%M%S)"
}

# ==========================================
# End of .zshrc
# ==========================================
