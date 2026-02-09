#!/usr/bin/env bash
#
# node.sh - Install NVM + Node + symlinks to ~/.local/bin
#
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

install_node() {
    local node_major="${1:-24}"
    if [ -d "$HOME/.nvm" ]; then
        log "NVM already installed"
    else
        log "Installing NVM..."
        curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
    fi
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    if nvm ls "$node_major" &>/dev/null; then
        log "Node $node_major already installed"
    else
        log "Installing Node $node_major..."
        nvm install "$node_major"
    fi

    # Symlink node/npm/npx to ~/.local/bin for non-interactive processes
    local node_bin
    node_bin="$(dirname "$(nvm which current)")"
    mkdir -p "$HOME/.local/bin"
    for cmd in node npm npx; do
        if [ -f "$node_bin/$cmd" ]; then
            ln -sf "$node_bin/$cmd" "$HOME/.local/bin/$cmd"
            log "Symlinked $cmd -> $HOME/.local/bin/$cmd"
        fi
    done
    log "Node setup complete."
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    install_node "$@"
fi
