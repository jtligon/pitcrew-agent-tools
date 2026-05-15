# Installation Guide

Setup guide for using PITCREW Agent Tools skills.

## Prerequisites

- [Jira CLI](https://github.com/ankitpokhrel/jira-cli) for querying JIRA
- Access to the PITCREW JIRA project
- (Optional) [Claude Code](https://claude.ai/code) for using skills

## Install Jira CLI

### macOS

```bash
brew install ankitpokhrel/jira-cli/jira-cli
```

### Linux

```bash
# Download latest release
curl -fsSL https://github.com/ankitpokhrel/jira-cli/releases/latest/download/jira_<version>_linux_x86_64.tar.gz -o jira.tar.gz
tar -xzf jira.tar.gz
sudo mv jira /usr/local/bin/
```

### Verify Installation

```bash
jira version
```

## Configure Jira CLI

The skills use the `jira` CLI to query and manage issues. Configure it for your PITCREW project:

```bash
jira init
```

Follow the prompts:
- **Installation:** Cloud or Server (depending on your setup)
- **Server URL:** Your JIRA instance URL (e.g., `https://issues.redhat.com` or `https://yourcompany.atlassian.net`)
- **Login:** Your email
- **Default Project:** `PITCREW`
- **Default Board:** Your team's board name

#### Create a Jira API Token

1. Go to https://id.atlassian.com/manage-profile/security/api-tokens
2. Click **Create API token**
3. Save it to `~/.config/jira/auth.sh`:

```bash
mkdir -p ~/.config/jira
cat > ~/.config/jira/auth.sh <<EOF
export JIRA_API_TOKEN="your-token-here"
export JIRA_AUTH_TYPE="bearer"
EOF
chmod 600 ~/.config/jira/auth.sh
```

#### Test Configuration

```bash
source ~/.config/jira/auth.sh
jira issue list --project PITCREW
```

You should see your PITCREW issues listed.

## Clone the Repository

```bash
git clone https://github.com/jtligon/pitcrew-agent-tools.git
cd pitcrew-agent-tools
```

## Using the Skills

### Option 1: With Claude Code

Skills are automatically available when Claude Code runs in this directory:

```bash
cd pitcrew-agent-tools
# Open in Claude Code
```

Then reference skills in conversation:
- "Using feature-triage, check PITCREW-1234 for duplicates"
- "List untriaged bugs in PITCREW"
- "Help me estimate PITCREW-5678"

#### Global Skills (Optional)

To use skills in any project:

```bash
cp -r go/skills/* ~/.claude/skills/
```

### Option 2: Use JQL Queries Directly

Each skill contains JQL queries you can use with jira CLI or Jira web UI:

```bash
# From bug-triage skill
jira issue list -q 'project = PITCREW AND issuetype = Bug AND labels != triaged'

# From feature-triage skill  
jira issue list -q 'project = PITCREW AND issuetype = Feature'
```

## Available Skills

| Skill | Description | Use When |
|-------|-------------|----------|
| `bug-triage` | Bug categorization and severity assessment | Triaging new bugs |
| `bug-investigation` | Root cause analysis patterns | Investigating bug causes |
| `feature-triage` | RFE duplicate detection | Triaging feature requests |
| `jira-estimation` | Story point estimation | Estimating work effort |
| `sprint-planning` | Sprint review and planning | Planning sprints |
| `pipeline-jira` | JIRA linking patterns | Linking related issues |

## Common Workflows

### Triage a Bug

```
"List untriaged bugs in PITCREW"
"Using bug-triage, categorize PITCREW-1234"
```

Claude will:
1. Query for bugs without the `triaged` label
2. Analyze the bug details
3. Recommend priority, labels, and next steps

### Check for Feature Duplicates

```
"Using feature-triage, check if PITCREW-5678 is a duplicate"
```

Claude will:
1. Read the RFE description
2. Search closed RFEs for similar requests
3. Recommend whether team review is needed

### Estimate Story Points

```
"Estimate story points for PITCREW-9012"
```

Claude will:
1. Analyze the issue scope
2. Search for comparable completed stories
3. Recommend points with reasoning

### Plan a Sprint

```
"Help me plan Sprint 42"
```

Claude will:
1. List carryover items from the previous sprint
2. Calculate velocity and capacity
3. Recommend sprint composition

## Customizing Skills

Skills are markdown files in `go/skills/<skill-name>/SKILL.md`. You can:

1. **Edit existing skills** to match your team's workflows
2. **Add new skills** by creating a new directory with a `SKILL.md` file
3. **Customize JQL queries** to match your JIRA project structure

### Skill File Format

```markdown
---
name: skill-name
description: Brief description of what this skill provides
---

# Skill Title

Knowledge and instructions for the skill...

## Section 1
Content...
```

## Troubleshooting

### Jira CLI not found

Install the Jira CLI:
```bash
# macOS
brew install ankitpokhrel/jira-cli/jira-cli

# Linux
go install github.com/ankitpokhrel/jira-cli/cmd/jira@latest

# Or download from: https://github.com/ankitpokhrel/jira-cli/releases
```

### Wrong issue types in queries

Edit the skill files and update JQL queries to match your JIRA project's issue types. Common types:
- `Bug`
- `Story`
- `Task`
- `Epic`
- `Feature`

Check your project's issue types in JIRA and update queries accordingly.

### Skills not loading

Make sure you're in the `pitcrew-agent-tools` directory or have copied skills to `~/.claude/skills/`.

## Next Steps

- Customize `CLAUDE.md` with PITCREW-specific context
- Update JQL queries in skills to match your issue types
- Add Automotive domain knowledge to relevant skills
- Create new skills for team-specific workflows
