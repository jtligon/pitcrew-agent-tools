# PITCREW Agent Tools - Quick Start

Get up and running with the PITCREW agent container in 5 minutes.

## Prerequisites

- [Podman](https://podman.io/getting-started/installation) or Docker installed
- [Just](https://github.com/casey/just#installation) command runner (optional, makes commands easier)
- Jira API token (see below)

## Get Your Jira API Token

### Option 1: If you already have ~/.config/jira/auth.sh

The `just` commands automatically source `~/.config/jira/auth.sh` if it exists, so you can skip to the Quick Start section below.

### Option 2: Create a new token

1. Go to https://id.atlassian.com/manage-profile/security/api-tokens
2. Click "Create API token"
3. Give it a name like "PITCREW Agent"
4. Copy the token and save it:

```bash
mkdir -p ~/.config/jira
cat > ~/.config/jira/auth.sh <<EOF
export JIRA_API_TOKEN="your-token-here"
EOF
chmod 600 ~/.config/jira/auth.sh
```

## Quick Start

### Option 1: Using `just` (Recommended)

The `just` commands automatically source `~/.config/jira/auth.sh` if it exists.

```bash
# 1. Build the container
just build

# 2. First-time setup - configure jira CLI
just setup
# When prompted, enter:
#   - Installation: Cloud (or Server if using self-hosted)
#   - Jira URL: https://issues.redhat.com (or your company's Jira URL)
#   - Login: your-email@company.com
#   - Project: PITCREW

# 3. Test the connection
just test-jira

# 4. Start working
just shell
```

### Option 2: Using podman directly

```bash
# 1. Build the container
podman build -t pitcrew-agent .

# 2. Source your auth script and run setup
source ~/.config/jira/auth.sh
podman run -it --rm \
  -v pitcrew-config:/home/agent/.config \
  -v $(pwd):/workspace \
  -e JIRA_API_TOKEN="$JIRA_API_TOKEN" \
  pitcrew-agent bash -c "jira init && bash"

# 3. Test jira connection (token still in environment)
podman run -it --rm \
  -v pitcrew-config:/home/agent/.config \
  -e JIRA_API_TOKEN="$JIRA_API_TOKEN" \
  pitcrew-agent jira issue list --project PITCREW

# 4. Start working
podman run -it --rm \
  -v pitcrew-config:/home/agent/.config \
  -v $(pwd):/workspace \
  -e JIRA_API_TOKEN="$JIRA_API_TOKEN" \
  pitcrew-agent
```

**Tip:** Create an alias in your shell rc file:

```bash
# Add to ~/.bashrc or ~/.zshrc
alias pitcrew='source ~/.config/jira/auth.sh && podman run -it --rm -v pitcrew-config:/home/agent/.config -v $(pwd):/workspace -e JIRA_API_TOKEN="$JIRA_API_TOKEN" pitcrew-agent'
```

Then just run: `pitcrew`

## What's Inside the Container?

The container includes:
- **jira-cli** - Query and manage Jira issues
- **gh** - GitHub CLI
- **Skills** - Automatically copied to `~/.claude/skills/`
- **Standard tools** - jq, yq, ripgrep, git, curl

## Try the Skills

Once in the container, test the jira commands from the skills:

```bash
# List untriaged bugs
jira issue list -q 'project = PITCREW AND issuetype = Bug AND labels != triaged'

# List open features  
jira issue list -q 'project = PITCREW AND issuetype = Feature'

# View a specific issue
jira issue view PITCREW-123
```

## Using with Claude Code

The skills are automatically synced to `~/.claude/skills/` in the container. When you use Claude Code (if installed in the container or accessed externally), it will have access to all the PITCREW skills.

For now, you can use the container to:
1. Query Jira with the JQL patterns from the skills
2. Test and refine your workflows
3. Run the commands the skills document

## Persistence

Your configuration is stored in a podman volume named `pitcrew-config`. This means:
- ✅ Jira CLI configuration persists across container runs
- ✅ You only need to run `jira init` once
- ✅ Your API token is stored securely in the volume

To start fresh, remove the volume:
```bash
just clean
# or
podman volume rm pitcrew-config
```

## Environment Variables

Create a `.env` file (copy from `.env.example`):

```bash
cp .env.example .env
# Edit .env and add your tokens
```

Then load it:
```bash
source .env
just shell
```

## Troubleshooting

### "jira: command not found"
The container wasn't built yet. Run `just build` first.

### "Authentication failed"
Check your JIRA_API_TOKEN is correct and hasn't expired.

### "Project PITCREW does not exist"
Make sure you configured the jira CLI with the right project name during `jira init`.

### Skills not showing up
Skills are synced on container startup to `~/.claude/skills/`. Check:
```bash
ls ~/.claude/skills/
```

## Next Steps

- Read [INSTALL.md](INSTALL.md) for detailed setup
- Check [go/skills/README.md](go/skills/README.md) for skill documentation
- Customize skills for your team's workflows
