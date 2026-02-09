#!/usr/bin/env bash
#
# common.sh - Shared helpers for dotfiles scripts
#
# Sourced by other scripts; not meant to be run directly.
#

# Avoid double-sourcing
[[ -n "${_DOTFILES_COMMON_LOADED:-}" ]] && return
_DOTFILES_COMMON_LOADED=1

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
BACKUP_SUFFIX="backup.$(date +%Y%m%d%H%M%S)"

log()  { echo -e "\033[1;32m==>\033[0m $*"; }
warn() { echo -e "\033[1;33m==> WARNING:\033[0m $*"; }
err()  { echo -e "\033[1;31m==> ERROR:\033[0m $*" >&2; }

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
