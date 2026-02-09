#!/usr/bin/env bash
#
# packages.sh - Install base apt packages
#
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

install_packages() {
    log "Updating apt and installing base packages..."
    sudo apt-get update -qq
    sudo apt-get install -y -qq \
        build-essential curl wget git unzip \
        libssl-dev libreadline-dev zlib1g-dev libyaml-dev libffi-dev
    log "Base packages installed."
}

# Run directly if not sourced
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    install_packages
fi
