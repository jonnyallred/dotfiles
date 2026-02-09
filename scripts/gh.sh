#!/usr/bin/env bash
#
# gh.sh - Install GitHub CLI
#
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

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
    log "GitHub CLI installed."
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    install_gh
fi
