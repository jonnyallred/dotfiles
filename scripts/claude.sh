#!/usr/bin/env bash
#
# claude.sh - Install Claude Code CLI
#
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

install_claude() {
    if command -v claude &>/dev/null; then
        log "Claude Code already installed ($(claude --version 2>/dev/null || echo 'unknown'))"
        return
    fi
    
    log "Installing Claude Code..."
    
    # Use the correct installation URL
    curl -fsSL https://claude.ai/install.sh | bash

    # Add to PATH for current session (bashrc may not be linked yet)
    export PATH="$HOME/.local/bin:$PATH"

    # Verify installation succeeded
    if command -v claude &>/dev/null; then
        log "Claude Code installed successfully: $(claude --version 2>/dev/null || echo 'unknown')"
    else
        log "WARNING: Installation completed but 'claude' command not found in PATH"
        log "You may need to restart your shell or add Claude to PATH manually"
        return 1
    fi
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    install_claude
fi
