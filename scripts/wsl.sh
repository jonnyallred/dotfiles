#!/usr/bin/env bash
#
# wsl.sh - Configure WSL systemd
#
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

setup_wsl() {
    if ! grep -qi microsoft /proc/version 2>/dev/null; then
        log "Not running in WSL, skipping"
        return
    fi
    log "WSL detected. Checking /etc/wsl.conf..."
    if [ ! -f /etc/wsl.conf ] || ! grep -q "systemd=true" /etc/wsl.conf; then
        log "Enabling systemd in /etc/wsl.conf..."
        echo -e "\n[boot]\nsystemd=true" | sudo tee /etc/wsl.conf > /dev/null
        warn "Restart WSL for systemd changes to take effect: wsl --shutdown"
    else
        log "WSL systemd already enabled"
    fi
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    setup_wsl
fi
