# PITCREW Agent Tools

Claude Code skills and tools for PITCREW - Automotive Engineering team.

## Quick Start

**Want to get up and running in 5 minutes?** See [QUICKSTART.md](QUICKSTART.md)

```bash
# Build the container with all tools pre-installed
podman build -t pitcrew-agent .

# Run and start working
export JIRA_API_TOKEN="your-token"
podman run -it --rm \
  -v pitcrew-config:/home/agent/.config \
  -v $(pwd):/workspace \
  -e JIRA_API_TOKEN="$JIRA_API_TOKEN" \
  pitcrew-agent
```

## What's Inside?

This repository provides:
- **6 Claude Code Skills** for PITCREW product owner workflows
- **Container with Tools** - jira-cli, gh, jq, ripgrep, and more
- **JQL Query Patterns** - Pre-built queries for PITCREW project

## Skills

Skills in `go/skills/` provide specialized knowledge for:

| Skill | Issue Type | Purpose |
|-------|------------|---------|
| `bug-triage` | Bug | Categorize and prioritize bugs |
| `bug-investigation` | Bug | Root cause analysis patterns |
| `feature-triage` | Feature | Find duplicates, recommend team review |
| `jira-estimation` | Story | Story point estimation |
| `sprint-planning` | Task, Story | Sprint review and planning |
| `pipeline-jira` | All | JIRA linking patterns |

## Documentation

- **[QUICKSTART.md](QUICKSTART.md)** - Get running in 5 minutes
- **[INSTALL.md](INSTALL.md)** - Detailed setup guide
- **[go/skills/README.md](go/skills/README.md)** - Skills documentation

## Container Approach

Based on the CoreOS project's container pattern, this repo provides a ready-to-use environment:

1. **Tools Pre-installed** - No need to install jira-cli, gh, etc.
2. **Skills Auto-synced** - Skills copy to `~/.claude/skills/` on startup
3. **Persistent Config** - Your jira setup persists in a volume

See [QUICKSTART.md](QUICKSTART.md) for usage examples.

## Issue Types

PITCREW uses these JIRA issue types:
- **Bug** - Defects and issues
- **Task** - Operational work
- **Story** - User stories
- **Epic** - Large initiatives
- **Feature** - Feature requests

Skills are configured with the correct JQL queries for each type.

## Contributing

When adding new skills:
- Create a new directory under `go/skills/`
- Include a `SKILL.md` file with frontmatter
- Document JIRA queries, workflows, and decision criteria
- Test in the container environment
- Update this README

## License

See LICENSE file for details.
