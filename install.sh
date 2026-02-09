#!/usr/bin/env bash
#
# install.sh - Bootstrap a new WSL/Linux machine with dotfiles and dev tools
#
# Usage:
#   ~/.dotfiles/install.sh          # Full install (dotfiles + tools)
#   ~/.dotfiles/install.sh --link   # Only symlink dotfiles (skip tool install)
#   ~/.dotfiles/install.sh --help   # Show usage info
#
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$DOTFILES_DIR/scripts"

source "$SCRIPTS_DIR/common.sh"

# Source all module scripts (defines their functions without running them)
source "$SCRIPTS_DIR/packages.sh"
source "$SCRIPTS_DIR/gh.sh"
source "$SCRIPTS_DIR/ruby.sh"
source "$SCRIPTS_DIR/node.sh"
source "$SCRIPTS_DIR/python.sh"
source "$SCRIPTS_DIR/claude.sh"
source "$SCRIPTS_DIR/mcp.sh"
source "$SCRIPTS_DIR/wsl.sh"
source "$SCRIPTS_DIR/git-setup.sh"

# --- Symlink dotfiles ---
link_dotfiles() {
    log "Linking dotfiles..."
    link_file "$DOTFILES_DIR/bash/bashrc" "$HOME/.bashrc"
    link_file "$DOTFILES_DIR/bash/profile" "$HOME/.profile"
    link_file "$DOTFILES_DIR/git/gitconfig" "$HOME/.gitconfig"
    mkdir -p "$HOME/.claude"
    link_file "$DOTFILES_DIR/claude/settings.json" "$HOME/.claude/settings.json"
    link_file "$DOTFILES_DIR/claude/settings.local.json" "$HOME/.claude/settings.local.json"
    log "Dotfiles linked."
}

usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Bootstrap a new WSL/Linux machine with dotfiles and dev tools.

Options:
  --link    Only symlink dotfiles (skip tool installation)
  --help    Show this help message

Individual scripts can also be run standalone:
  ~/.dotfiles/scripts/node.sh       # Install NVM + Node only
  ~/.dotfiles/scripts/ruby.sh       # Install rbenv + Ruby only
  ~/.dotfiles/scripts/python.sh     # Install uv only
  ~/.dotfiles/scripts/gh.sh         # Install GitHub CLI only
  ~/.dotfiles/scripts/claude.sh     # Install Claude Code only
  ~/.dotfiles/scripts/mcp.sh        # Install MCP servers only
  ~/.dotfiles/scripts/packages.sh   # Install apt packages only
  ~/.dotfiles/scripts/wsl.sh        # Configure WSL only
  ~/.dotfiles/scripts/git-setup.sh  # Configure git identity only
EOF
}

# --- Main ---
main() {
    case "${1:-}" in
        --help|-h)
            usage
            return
            ;;
        --link)
            log "Starting dotfiles setup from $DOTFILES_DIR (link-only mode)"
            echo ""
            link_dotfiles
            log "Done! (link-only mode)"
            return
            ;;
    esac

    log "Starting dotfiles setup from $DOTFILES_DIR"
    echo ""

    install_packages
    install_gh
    install_ruby "3.2.2"
    install_node "24"
    install_python
    install_claude
    link_dotfiles
    install_mcp_memory
    setup_wsl
    setup_git_identity

    echo ""
    log "Setup complete! Open a new shell or run: source ~/.bashrc"
}

main "$@"
