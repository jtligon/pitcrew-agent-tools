# PITCREW Agent Tools - Claude Code Instructions

This file provides guidance to Claude Code when working with PITCREW team workflows and tools.

## Team Overview

**PITCREW** is a product ownership team within Automotive Engineering at Red Hat.

## JIRA structure

PITCREW uses one project and **PitCrew** scrum board. Work is split by **component**:

| Component | Upstream repo | Notes |
|-----------|---------------|-------|
| Jumpstarter | https://github.com/jumpstarter-dev/jumpstarter | HiL testing (`python/`, `controller/`, `protocol/`, `e2e/`) |
| Automotive-dev-operator | https://github.com/centos-automotive-suite/automotive-dev-operator | CAIB / OS image builds (`caib` CLI, ImageBuild CRD) |
| Security | *(none)* | Product Security — **embargoed CVEs** assigned into PITCREW; not a product codebase |

See [docs/PHASE0.md](docs/PHASE0.md) for full inventory.

## JIRA Configuration

### Project
- **Primary Project**: PITCREW
- **Host**: redhat.atlassian.net
- **Board**: PitCrew
- **Labels**: https://github.com/jumpstarter-dev/jumpstarter/labels (Jumpstarter); confirm Automotive-dev-operator label conventions

### Common Workflows
- Bug triage and prioritization
- RFE (Request For Enhancement) management
- Sprint planning and estimation
- Backlog grooming

## Tools & Preferences

### Task Tracking
Use `bd` for local task tracking during development sessions.

### JIRA access

Use the **`jira` CLI only** for JIRA queries and updates. Do **not** use the Atlassian MCP plugin.

```bash
source ~/.config/jira/auth.sh
unset JIRA_AUTH_TYPE   # required for redhat.atlassian.net API tokens
```

Default project: `PITCREW`. Default board: `PitCrew`. Sprint names: `PitCrew Sprint N` (not `PITCREW - Sprint N`).

Example queries:
```bash
# List open bugs
jira issue list --project PITCREW -q 'project = PITCREW AND issuetype = Bug AND status not in (Closed, Done, Resolved)'

# View issue details
jira issue view <ISSUE-KEY>

# Search by component
jira issue list --project PITCREW -q 'project = PITCREW AND component = "YOUR-COMPONENT"'
```

## Skills Usage

Skills in `go/skills/` provide domain knowledge for common product owner tasks:

- **bug-triage** - Systematic bug triage workflow
- **feature-triage** - RFE duplicate detection and review recommendations
- **jira-estimation** - Effort estimation guidance

When triaging issues, refer to the relevant skill for:
- Query templates
- Decision criteria
- Team conventions
- Permission handling

## Communication Style

- Keep explanations concise
- Provide context through references rather than copying documentation
- Ask clarifying questions when needed
- Be direct and avoid over-politeness

## Workflow Pattern

Follow this pattern when working on JIRA-related tasks:
1. **Explore** - Query and understand current issue state
2. **Plan** - Design the triage/estimation approach
3. **Execute** - Apply decisions (labels, comments, links)
4. **Document** - Update skills if new patterns emerge

## Scope (Phase 0)

- **In scope:** JIRA PO workflows, upstream investigation (Jumpstarter, automotive-dev-operator)
- **Deferred:** OpenCode container, Go CLI, Jenkins CI monitoring

Details: [docs/PHASE0.md](docs/PHASE0.md)
