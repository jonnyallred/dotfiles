# dotfiles

Personal dotfiles and WSL environment setup for development with Claude Code.

## What's Included

```
bash/           Shell configuration
  bashrc        .bashrc (with rbenv + nvm init)
  profile       .profile
  zshrc         .zshrc (oh-my-zsh, not currently active)
git/            Git configuration
  gitconfig     .gitconfig
claude/         Claude Code settings
  settings.json           MCP server config
  settings.local.json     Tool permissions
wsl/            WSL-specific config
  wsl.conf      /etc/wsl.conf
env.template    Generic environment variable template
```

## Quick Start (New Machine)

```bash
# 1. Clone the repo
git clone git@github.com:jonnyallred/dotfiles.git ~/.dotfiles

# 2. Run the bootstrap script
~/.dotfiles/install.sh

# 3. Or, have Claude do it:
# Open Claude Code and say: "Follow the instructions in ~/.dotfiles/CLAUDE-SETUP.md"
```

## Manual Setup

See `CLAUDE-SETUP.md` for step-by-step instructions that work for both humans and Claude.

## Adding New Dotfiles

1. Copy the file into the appropriate subdirectory
2. Add a symlink entry in `install.sh`
3. Commit and push
