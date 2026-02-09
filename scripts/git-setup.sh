#!/usr/bin/env bash
#
# git-setup.sh - Configure git identity (interactive)
#
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

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

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    setup_git_identity
fi
