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

### 2. Set up secrets management (pass + GPG)

`pass` and `direnv` are installed automatically by `install.sh`. The GPG key
and password store are NOT in this repo — they must be set up manually on each
machine.

**On a brand new machine (first time):**

```bash
# Generate a GPG key
gpg --full-generate-key
# Choose: RSA 4096, no expiration, your name + jonnyallred@gmail.com

# Init pass with the key fingerprint shown above
pass init <fingerprint>
pass git init
pass git remote add origin git@github.com:jonnyallred/secrets.git
pass git push -u origin main
```

**On a subsequent machine (already have a GPG key and secrets repo):**

```bash
# Copy jonny-gpg-public.asc and jonny-gpg-private.asc from your other machine
# (via USB, scp, etc — never send private key over unencrypted channels)

gpg --import ~/jonny-gpg-public.asc
gpg --import ~/jonny-gpg-private.asc

# Trust the key fully
gpg --edit-key <fingerprint>
# At the gpg> prompt: trust → 5 (ultimate) → quit

# Clone your secrets repo
pass clone git@github.com:jonnyallred/secrets.git

# Delete the key files now that they're imported
rm ~/jonny-gpg-public.asc ~/jonny-gpg-private.asc
```

**Exporting GPG key from an existing machine:**

```bash
gpg --export --armor <fingerprint> > ~/jonny-gpg-public.asc
gpg --export-secret-keys --armor <fingerprint> > ~/jonny-gpg-private.asc
```

**Daily usage:**

```bash
pass insert dev/my-api-key     # Add a secret (prompts for value)
pass dev/my-api-key            # Retrieve a secret
pass git push                  # Sync to other machines
pass git pull                  # Pull updates from another machine
```

**Wiring secrets into a project with direnv:**

Create a `.envrc` in the project root (do NOT commit this file):

```bash
export MY_API_KEY=$(pass dev/my-api-key)
```

Then run `direnv allow .` — the key will auto-load whenever you `cd` into the
directory and unset when you leave.

Add `.envrc` to your global gitignore if not already done:

```bash
echo ".envrc" >> ~/.gitignore_global
git config --global core.excludesfile ~/.gitignore_global
```

### 3. Post-install: Authenticate services

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

### Secrets (pass + direnv)
- `pass` stores GPG-encrypted secrets in `~/.password-store/`, synced via a
  private git repo at `git@github.com:jonnyallred/secrets.git`
- `direnv` auto-loads per-project secrets from `.envrc` files on `cd`
- The `direnv` shell hook is in `bash/bashrc`
- GPG key and secrets repo must be set up manually on each machine (see step 2)

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
- **pass: no GPG key**: Follow step 2 above to import your key or generate a new one
- **direnv not loading .envrc**: Run `direnv allow .` in the project directory
