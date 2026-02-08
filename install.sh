#!/usr/bin/env bash
#
# install.sh - Bootstrap a new WSL/Linux machine with dotfiles and dev tools
#
# Usage:
#   ~/.dotfiles/install.sh          # Full install (dotfiles + tools)
#   ~/.dotfiles/install.sh --link   # Only symlink dotfiles (skip tool install)
#
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_SUFFIX="backup.$(date +%Y%m%d%H%M%S)"

log()  { echo -e "\033[1;32m==>\033[0m $*"; }
warn() { echo -e "\033[1;33m==> WARNING:\033[0m $*"; }
err()  { echo -e "\033[1;31m==> ERROR:\033[0m $*" >&2; }

# --- Symlink helper ---
link_file() {
    local src="$1" dst="$2"
    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
        log "Backing up $dst -> $dst.$BACKUP_SUFFIX"
        mv "$dst" "$dst.$BACKUP_SUFFIX"
    elif [ -L "$dst" ]; then
        rm "$dst"
    fi
    log "Linking $src -> $dst"
    ln -s "$src" "$dst"
}

# --- Symlink dotfiles ---
link_dotfiles() {
    log "Linking dotfiles..."
    link_file "$DOTFILES_DIR/bash/bashrc" "$HOME/.bashrc"
    link_file "$DOTFILES_DIR/bash/profile" "$HOME/.profile"
    link_file "$DOTFILES_DIR/git/gitconfig" "$HOME/.gitconfig"
    mkdir -p "$HOME/.claude"
    link_file "$DOTFILES_DIR/claude/settings.json" "$HOME/.claude/settings.json"
    link_file "$DOTFILES_DIR/claude/settings.local.json" "$HOME/.claude/settings.local.json"
    log "Dotfiles linked."
}

# --- Install system packages ---
install_packages() {
    log "Updating apt and installing base packages..."
    sudo apt-get update -qq
    sudo apt-get install -y -qq \
        build-essential curl wget git unzip \
        libssl-dev libreadline-dev zlib1g-dev libyaml-dev libffi-dev
}

# --- Install GitHub CLI ---
install_gh() {
    if command -v gh &>/dev/null; then
        log "GitHub CLI already installed ($(gh --version | head -1))"
        return
    fi
    log "Installing GitHub CLI..."
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
        | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt-get update -qq && sudo apt-get install -y -qq gh
}

# --- Install rbenv + Ruby ---
install_ruby() {
    local ruby_version="${1:-3.2.2}"
    if command -v rbenv &>/dev/null; then
        log "rbenv already installed"
    else
        log "Installing rbenv..."
        git clone https://github.com/rbenv/rbenv.git "$HOME/.rbenv"
        git clone https://github.com/rbenv/ruby-build.git "$HOME/.rbenv/plugins/ruby-build"
    fi
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
    if rbenv versions | grep -q "$ruby_version"; then
        log "Ruby $ruby_version already installed"
    else
        log "Installing Ruby $ruby_version (this takes a few minutes)..."
        rbenv install "$ruby_version"
        rbenv global "$ruby_version"
    fi
}

# --- Install NVM + Node ---
install_node() {
    local node_version="${1:-24}"
    if [ -d "$HOME/.nvm" ]; then
        log "NVM already installed"
    else
        log "Installing NVM..."
        curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
    fi
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    if nvm ls "$node_version" &>/dev/null; then
        log "Node $node_version already installed"
    else
        log "Installing Node $node_version..."
        nvm install "$node_version"
    fi
}

# --- Install Claude Code ---
install_claude() {
    if command -v claude &>/dev/null; then
        log "Claude Code already installed ($(claude --version 2>/dev/null || echo 'unknown'))"
        return
    fi
    log "Installing Claude Code..."
    curl -fsSL https://claude.ai/install.sh | sh
}

# --- Install MCP memory server ---
install_mcp_memory() {
    if command -v npm &>/dev/null; then
        log "Installing MCP memory server globally..."
        npm install -g @modelcontextprotocol/server-memory
    else
        warn "npm not available, skipping MCP memory server install"
    fi
}

# --- WSL config ---
setup_wsl() {
    if grep -qi microsoft /proc/version 2>/dev/null; then
        log "WSL detected. Checking /etc/wsl.conf..."
        if [ ! -f /etc/wsl.conf ] || ! grep -q "systemd=true" /etc/wsl.conf; then
            log "Enabling systemd in /etc/wsl.conf..."
            echo -e "\n[boot]\nsystemd=true" | sudo tee /etc/wsl.conf > /dev/null
            warn "Restart WSL for systemd changes to take effect: wsl --shutdown"
        else
            log "WSL systemd already enabled"
        fi
    fi
}

# --- Git config (interactive) ---
setup_git_identity() {
    if [ -z "$(git config --global user.name)" ]; then
        echo ""
        read -rp "Git user.name (e.g., Jonathan Allred): " git_name
        git config --global user.name "$git_name"
    fi
    if [ -z "$(git config --global user.email)" ]; then
        read -rp "Git user.email (e.g., jonnyallred@gmail.com): " git_email
        git config --global user.email "$git_email"
    fi
    git config --global init.defaultBranch main
    git config --global pull.rebase true
    log "Git identity configured: $(git config --global user.name) <$(git config --global user.email)>"
}

# --- Main ---
main() {
    log "Starting dotfiles setup from $DOTFILES_DIR"
    echo ""
    if [ "${1:-}" = "--link" ]; then
        link_dotfiles
        log "Done! (link-only mode)"
        return
    fi
    install_packages
    install_gh
    install_ruby "3.2.2"
    install_node "24"
    install_claude
    link_dotfiles
    install_mcp_memory
    setup_wsl
    setup_git_identity
    echo ""
    log "Setup complete! Open a new shell or run: source ~/.bashrc"
}

main "$@"
