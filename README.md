# dotfiles

Personal dotfiles and WSL environment setup for development with Claude Code.

## What's Included

```
scripts/          Modular install scripts (each runnable standalone)
  common.sh       Shared helpers (log, warn, err, link_file)
  packages.sh     apt base packages
  gh.sh           GitHub CLI
  ruby.sh         rbenv + Ruby 3.2.2
  node.sh         NVM + Node 24 + ~/.local/bin symlinks
  python.sh       uv (Python package manager)
  claude.sh       Claude Code CLI
  mcp.sh          MCP servers (memory) + ~/.local/bin symlinks
  wsl.sh          WSL systemd config
  git-setup.sh    Git identity (interactive)
bash/             Shell configuration
  bashrc          .bashrc (with rbenv + nvm init)
  profile         .profile
  zshrc           .zshrc (oh-my-zsh, not currently active)
git/              Git configuration
  gitconfig       .gitconfig
claude/           Claude Code settings
  settings.json           MCP server config
  settings.local.json     Tool permissions
wsl/              WSL-specific config
  wsl.conf        /etc/wsl.conf
env.template      Generic environment variable template
install.sh        Main orchestrator (calls scripts/)
```

## Getting Started (New Machine)

1. **Clone the repo**

   ```bash
   git clone git@github.com:jonnyallred/dotfiles.git ~/.dotfiles
   ```

2. **Run the bootstrap script**

   ```bash
   ~/.dotfiles/install.sh
   ```

   This installs: system packages, rbenv + Ruby 3.2.2, NVM + Node 24,
   GitHub CLI, uv (Python), Claude Code, MCP memory server, and symlinks
   all config files.

   To only symlink dotfiles (if tools are already installed):

   ```bash
   ~/.dotfiles/install.sh --link
   ```

3. **Or install individual tools**

   Each script in `scripts/` can be run standalone:

   ```bash
   ~/.dotfiles/scripts/node.sh        # Just Node
   ~/.dotfiles/scripts/python.sh      # Just uv
   ~/.dotfiles/scripts/ruby.sh 3.3.0  # Ruby with custom version
   ```

   Run `~/.dotfiles/install.sh --help` for the full list.

4. **Authenticate services** (interactive, can't be automated)

   ```bash
   gh auth login        # GitHub CLI
   claude               # Claude Code - follow OAuth flow on first launch
   ```

5. **Verify**

   ```bash
   ruby -v              # 3.2.2
   node -v              # v24.x
   uv --version         # latest
   gh auth status       # logged in
   claude --version     # latest
   ```

6. **Clone projects**

   ```bash
   mkdir -p ~/projects
   gh repo clone jonnyallred/boardgame-retreat ~/projects/boardgame-retreat
   ```

Or, have Claude do it all: open Claude Code and say
"Follow the instructions in `~/.dotfiles/CLAUDE-SETUP.md`".

See `CLAUDE-SETUP.md` for more detail and troubleshooting.

## How Symlinks Work

The install script symlinks config files from the repo into their expected locations:

```
~/.bashrc                      → ~/.dotfiles/bash/bashrc
~/.profile                     → ~/.dotfiles/bash/profile
~/.gitconfig                   → ~/.dotfiles/git/gitconfig
~/.claude/settings.json        → ~/.dotfiles/claude/settings.json
~/.claude/settings.local.json  → ~/.dotfiles/claude/settings.local.json
```

Edits to any of these files are edits to the repo. Run `git status` in
`~/.dotfiles` to see changes, then commit and push as usual.

## Adding New Dotfiles

1. Copy the file into the appropriate subdirectory
2. Add a `link_file` entry in the `link_dotfiles()` function in `install.sh`
3. Commit and push
