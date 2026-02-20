# Claude Setup Instructions

Instructions for Claude Code to set up a new WSL/Linux development environment.
A human can also follow these steps manually.

## Prerequisites

- A fresh Ubuntu WSL2 instance (22.04+) or Ubuntu Linux machine
- Internet access
- This repo cloned to `~/.dotfiles`

## Step-by-Step Setup

### 1. Run the automated installer

```bash
~/.dotfiles/install.sh
```

This handles: apt packages, rbenv + Ruby 3.2.2, NVM + Node 24, uv (Python),
GitHub CLI, Claude Code, dotfile symlinks, MCP memory server, WSL systemd
config, and git identity.

If you only want to link the dotfiles (tools already installed):

```bash
~/.dotfiles/install.sh --link
```

Individual tools can be installed separately:

```bash
~/.dotfiles/scripts/node.sh       # NVM + Node + ~/.local/bin symlinks
~/.dotfiles/scripts/python.sh     # uv/uvx
~/.dotfiles/scripts/ruby.sh       # rbenv + Ruby
~/.dotfiles/scripts/mcp.sh        # MCP servers + ~/.local/bin symlinks
```

### 2. Post-install: Authenticate services

After install.sh completes, these need manual/interactive auth:

```bash
# GitHub CLI
gh auth login

# Claude Code
claude
# Follow the OAuth flow on first launch
```

### 3. Post-install: Verify everything works

Run these to confirm:

```bash
ruby -v          # Should show 3.2.2
node -v          # Should show v24.x
uv --version     # Should show latest
git --version    # Should show 2.34+
gh auth status   # Should show logged in
claude --version # Should show latest
```

Verify PATH symlinks:

```bash
which node npm npx mcp-server-memory uv
# All should point to ~/.local/bin/ or ~/.nvm/...
```

### 4. Clone projects

```bash
mkdir -p ~/projects
cd ~/projects
gh repo clone jonnyallred/boardgame-retreat
```

## What the Dotfiles Configure

### Shell (bash)
- Standard Ubuntu bashrc with color prompt
- rbenv initialization for Ruby version management
- NVM initialization for Node version management
- ~/.local/bin in PATH for user-installed binaries

### Git
- GitHub CLI credential helper (no SSH keys needed, uses gh auth)
- Default branch: main
- Pull strategy: rebase

### Claude Code
- MCP memory server for persistent context across sessions
- Tool permission allowlist covering: git, ruby/rails, node/npm, python,
  docker, and common CLI utilities
- Global `CLAUDE.md` with cross-project instructions (linked to `~/CLAUDE.md`)
- Custom skills directory (linked to `~/.claude/skills/`)

### WSL
- Systemd enabled for proper service management

## Updating Dotfiles

When you change a config file on a running machine:

```bash
# Files are symlinked, so changes are already in the repo.
cd ~/.dotfiles
git add -A
git commit -m "Update description here"
git push
```

On other machines, pull the changes:

```bash
cd ~/.dotfiles
git pull
# Changes take effect immediately for symlinked files.
# For .bashrc changes: source ~/.bashrc
```

## Adding New Config Files

1. Put the file in the appropriate subdirectory under `~/.dotfiles/`
2. Add a `link_file` entry in the `link_dotfiles()` function in `install.sh`
3. Document it in this file
4. Commit and push

## Troubleshooting

- **rbenv not found after install**: Run `source ~/.bashrc` or open a new terminal
- **NVM not found**: Same fix - `source ~/.bashrc`
- **Claude Code auth expired**: Run `claude` and re-authenticate
- **WSL systemd not working**: Run `wsl --shutdown` from Windows PowerShell, then reopen
- **MCP memory server fails**: Run `~/.dotfiles/scripts/mcp.sh` to reinstall,
  or check that `~/.local/bin/mcp-server-memory` exists
- **uv not found**: Run `~/.dotfiles/scripts/python.sh` to install
