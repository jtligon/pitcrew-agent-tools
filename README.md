# PITCREW Agent Tools

Claude Code skills for PITCREW - Automotive Engineering team.

## Quick Start

```bash
# 1. Install jira CLI
brew install ankitpokhrel/jira-cli/jira-cli

# 2. Configure for PITCREW
source ~/.config/jira/auth.sh
unset JIRA_AUTH_TYPE
jira init   # board: PitCrew

# 3. Test it works
jira issue list --project PITCREW

# 4. Use with Claude Code
# Skills are automatically available when working in this directory
```

## What's Inside?

This repository provides:
- **8 Claude Code Skills** for PITCREW product owner workflows
- **JQL Query Patterns** - Pre-built queries for PITCREW project
- **Workflow Documentation** - Triage checklists, estimation guidelines, sprint planning

## Skills

Skills in `go/skills/` provide specialized knowledge for:

| Skill | Issue Type | Purpose |
|-------|------------|---------|
| `bug-triage` | Bug | Categorize and prioritize bugs |
| `bug-investigation` | Bug | Root cause analysis patterns |
| `feature-triage` | Feature | Find duplicates, recommend team review |
| `jira-estimation` | Story | Story point estimation |
| `sprint-planning` | Task, Story | Sprint review and planning |
| `pitcrew-repositories` | All | Upstream repo map (Jumpstarter, CAIB) |
| `triage-upstream` | — | Link GitHub issues ↔ PITCREW (`jira` / `upstream` labels) |
| `pipeline-jira` | All | JIRA linking patterns |

## Documentation

- **[INSTALL.md](INSTALL.md)** - Setup guide for jira CLI
- **[ROADMAP.md](ROADMAP.md)** - Customization checklist (porting from coreos-agent-tools)
- **[docs/PHASE0.md](docs/PHASE0.md)** - Scope, upstream repos, JIRA inventory
- **[go/skills/README.md](go/skills/README.md)** - Skills documentation

## Issue Types

PITCREW uses these JIRA issue types:
- **Bug** - Defects and issues
- **Task** - Operational work
- **Story** - User stories
- **Epic** - Large initiatives
- **Feature** - Feature requests

Skills are configured with the correct JQL queries for each type.

## Using the Skills

### With Claude Code

Skills are automatically available when you work in this directory with Claude Code:

```
"List untriaged bugs in PITCREW"
"Using feature-triage, check PITCREW-1234 for duplicates"
"Help me estimate PITCREW-5678"
```

### With jira CLI

Use the JQL queries from the skills directly:

```bash
# From bug-triage skill
jira issue list -q 'project = PITCREW AND issuetype = Bug AND labels != triaged'

# From feature-triage skill
jira issue list -q 'project = PITCREW AND issuetype = Feature AND status not in (Closed, Done)'

# From jira-estimation skill
jira issue list -q 'project = PITCREW AND issuetype = Story AND "Story Points[Number]" is EMPTY'
```

## Contributing

When adding new skills:
- Create a new directory under `go/skills/`
- Include a `SKILL.md` file with frontmatter
- Document JIRA queries, workflows, and decision criteria
- Update this README

## License

See LICENSE file for details.
