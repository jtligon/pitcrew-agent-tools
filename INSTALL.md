# Installation Guide

Quick setup guide for using PITCREW Agent Tools skills with Claude Code.

## Prerequisites

- [Claude Code](https://claude.ai/code) installed (CLI, Desktop, or Web)
- [Jira CLI](https://github.com/ankitpokhrel/jira-cli) installed (for JIRA integration)
- Access to the PITCREW JIRA project

## Setup

### 1. Clone the Repository

```bash
git clone https://github.com/jtligon/pitcrew-agent-tools.git
cd pitcrew-agent-tools
```

### 2. Configure Jira CLI

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

1. Go to your JIRA profile → **Account Settings** → **Security** → **API tokens**
2. Click **Create API token**
3. Copy the token and provide it when `jira init` prompts

#### Verify Setup

```bash
jira issue list --project PITCREW
```

You should see your PITCREW issues listed.

### 3. Using Skills with Claude Code

Skills are automatically available when Claude Code runs in this directory. The skills are located in `go/skills/`.

#### Option A: Project-Level (Recommended)

When working in this directory, Claude Code automatically has access to all skills:

```bash
cd pitcrew-agent-tools
claude  # or open in Claude Code Desktop/Web
```

Then reference skills in your conversation:
- "Using the feature-triage skill, check PITCREW-1234 for duplicates"
- "Use bug-triage to categorize the new bugs"
- "Help me estimate PITCREW-5678 using jira-estimation"

#### Option B: Global Skills

To use these skills in any project, copy them to your global skills directory:

```bash
cp -r go/skills/* ~/.claude/skills/
```

Now these skills are available in any Claude Code session.

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
