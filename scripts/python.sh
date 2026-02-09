#!/usr/bin/env bash
#
# python.sh - Install uv (Python package manager)
#
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

install_python() {
    if command -v uv &>/dev/null; then
        log "uv already installed ($(uv --version))"
        return
    fi
    log "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    log "uv installed to ~/.local/bin/uv"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    install_python
fi
