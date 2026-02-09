#!/usr/bin/env bash
#
# mcp.sh - Install MCP servers + symlinks to ~/.local/bin
#
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

install_mcp_memory() {
    # Ensure npm is available (may need to load nvm)
    if ! command -v npm &>/dev/null; then
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    fi
    if ! command -v npm &>/dev/null; then
        warn "npm not available, skipping MCP memory server install"
        return
    fi

    log "Installing MCP memory server globally..."
    npm install -g @modelcontextprotocol/server-memory

    # Symlink mcp-server-memory to ~/.local/bin
    local node_bin
    node_bin="$(dirname "$(which node)")"
    mkdir -p "$HOME/.local/bin"
    if [ -f "$node_bin/mcp-server-memory" ]; then
        ln -sf "$node_bin/mcp-server-memory" "$HOME/.local/bin/mcp-server-memory"
        log "Symlinked mcp-server-memory -> $HOME/.local/bin/mcp-server-memory"
    fi
    log "MCP memory server installed."
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    install_mcp_memory
fi
