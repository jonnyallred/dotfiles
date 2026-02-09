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
    curl -fsSL https://claude.ai/install.sh | sh
    log "Claude Code installed."
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    install_claude
fi
