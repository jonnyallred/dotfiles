#!/usr/bin/env bash
#
# ruby.sh - Install rbenv + Ruby
#
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

install_ruby() {
    local ruby_version="${1:-3.2.2}"
    if command -v rbenv &>/dev/null; then
        log "rbenv already installed"
    else
        if [ -d "$HOME/.rbenv" ]; then
            log "rbenv directory exists, skipping clone"
        else
            log "Installing rbenv..."
            git clone https://github.com/rbenv/rbenv.git "$HOME/.rbenv"
            git clone https://github.com/rbenv/ruby-build.git "$HOME/.rbenv/plugins/ruby-build"
        fi
    fi
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
    if rbenv versions | grep -q "$ruby_version"; then
        log "Ruby $ruby_version already installed"
    else
        log "Installing Ruby $ruby_version (this takes a few minutes)..."
        rbenv install "$ruby_version"
        rbenv global "$ruby_version"
    fi
    log "Ruby setup complete."
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    install_ruby "$@"
fi
