# PITCREW Agent Tools - Claude Code Instructions

This file provides guidance to Claude Code when working with PITCREW team workflows and tools.

## Team Overview

**PITCREW** is a product ownership team within Automotive Engineering at Red Hat.

## JIRA Configuration

### Project
- **Primary Project**: PITCREW
- **Components**: (To be configured based on team structure)

### Common Workflows
- Bug triage and prioritization
- RFE (Request For Enhancement) management
- Sprint planning and estimation
- Backlog grooming

## Tools & Preferences

### Task Tracking
Use `bd` for local task tracking during development sessions.

### JIRA CLI
The `jira` CLI is used for issue management. Default project is PITCREW.

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

## Customization Notes

This CLAUDE.md should be customized with:
- Specific JIRA components used by PITCREW
- Team-specific labels and workflows
- Links to team documentation
- Automotive domain terminology
