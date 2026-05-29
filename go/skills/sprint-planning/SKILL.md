---
name: sprint-planning
description: Sprint Review and Planning for PITCREW project - velocity analysis, carryover management, and sprint composition
---

# Sprint Review and Planning

Guide for conducting Sprint Review and Sprint Planning for PITCREW project.

> Related: `jira-estimation` (for story point scale and estimation guidelines)

## PITCREW Project Conventions

### Sprint Naming
- Format: `PitCrew Sprint N` (e.g. `PitCrew Sprint 11`)
- Board: `PitCrew` (scrum)

### Sprint Duration
- Typically 2-3 weeks (adjust based on team cadence)

### Custom Fields
- Story Points: `customfield_10028`
- Sprint: `customfield_10020`

## JIRA CLI Commands

### Sprint Discovery

```bash
# List active sprints
jira sprint list --project PITCREW --state active

# List future sprints
jira sprint list --project PITCREW --state future

# Get sprint ID for adding issues
jira sprint list --project PITCREW --state future | grep "Sprint NNN"
```

### Sprint Issues

```bash
# List all issues in a sprint
jira issue list --jql 'project = PITCREW AND sprint = "PitCrew Sprint NNN"' --plain --no-truncate

# List closed issues
jira issue list --jql 'project = PITCREW AND sprint = "PitCrew Sprint NNN" AND status = Closed' --plain --no-truncate

# List open issues (carryover candidates)
jira issue list --jql 'project = PITCREW AND sprint = "PitCrew Sprint NNN" AND status != Closed' --plain --no-truncate
```

### Story Points

```bash
# Get story points for an issue
jira issue view <KEY> --raw | jq '.fields.customfield_10028'

# Batch get story points for multiple issues
for key in PITCREW-1234 PITCREW-1235 PITCREW-1236; do
  jira issue view "$key" --raw 2>/dev/null | jq -r '{key: .key, summary: .fields.summary, status: .fields.status.name, assignee: .fields.assignee.displayName, storyPoints: (.fields.customfield_10028 // 0)} | "\(.key)|\(.status)|\(.assignee // "Unassigned")|\(.storyPoints)|\(.summary)"'
done
```

### Issue Management

```bash
# Create a task
jira issue create --project PITCREW --type Task --summary "<summary>" --no-input

# Add issue to sprint (by sprint ID)
jira sprint add <sprint-id> <issue-key-1> <issue-key-2>

# Transition issue to Closed
jira issue move <KEY> "Closed"

# Add comment
jira issue comment add <KEY> "<comment-text>"
```

### Setting Story Points

> **Note:** Story Points (`customfield_10028`) cannot be reliably set via CLI. Set manually in JIRA UI after creating issues.

## GitHub PR Status Check

### Check PR Status

```bash
# Check single PR
gh pr view <number> --repo <org>/<repo> --json title,state,reviewDecision,mergeable,updatedAt

# Check PRs in your team's repositories
gh pr view <n> --repo <org>/<repo>
```

### PR Status Interpretation

| Field | Values | Meaning |
|-------|--------|---------|
| `state` | OPEN, MERGED, CLOSED | PR lifecycle |
| `reviewDecision` | APPROVED, REVIEW_REQUIRED, CHANGES_REQUESTED | Review status |
| `mergeable` | MERGEABLE, CONFLICTING, UNKNOWN | Can be merged |

### Find PRs for Issues

```bash
# Search by keyword
gh search prs --repo <org>/<repo> "<keyword>" --json number,title,state

# List PRs by author
gh pr list --repo <org>/<repo> --author <username> --state all
```

## Sprint Review Workflow

### 1. Gather Sprint Data

```bash
# Get all issues with story points
jira issue list --jql 'project = PITCREW AND sprint = "PitCrew Sprint NNN"' --plain --no-truncate

# For each issue, get story points
jira issue view <KEY> --raw | jq '{key, summary: .fields.summary, status: .fields.status.name, points: .fields.customfield_10028}'
```

### 2. Calculate Statistics

| Metric | Formula |
|--------|---------|
| Total Committed | Sum of all story points |
| Completed | Sum of points where status = Closed |
| Completion Rate | Completed / Total x 100 |
| Daily Velocity | Completed / Working Days |

### 3. Identify Themes

Group completed work by category:
- Feature development
- Bug fixes
- Technical debt
- Documentation
- Customer requests
- Operational tasks

### 4. Team Performance

| Team Member | Closed | Open | Total | Completion % |
|-------------|--------|------|-------|--------------|

### 5. Items Needing Attention

- PRs with conflicts (need rebase)
- Items in Review > 1 week
- Items not started
- Long-running items (> 100 days)

## Sprint Planning Workflow

### 1. Identify Carryover

```bash
# Open items from previous sprint
jira issue list --jql 'project = PITCREW AND sprint = "PitCrew Sprint NNN" AND status != Closed' --plain --no-truncate
```

### 2. Check GitHub PR Status

For each item in Review/In Progress, check if PR exists and its status:
- MERGEABLE + REVIEW_REQUIRED = Quick win, needs review
- CONFLICTING = Needs rebase before sprint
- No PR = Verify work has started

### 3. Calculate Projected Load

| Category | Points |
|----------|--------|
| Carryover - In Review | X |
| Carryover - In Progress | X |
| Carryover - New | X |
| New Work | X |
| **Total** | X |

### 4. Velocity Target

Based on previous sprint:
- If completion was < 50%, reduce commitment
- Target 70-80% completion rate
- Account for operational overhead

### 5. Risk Assessment

| Risk Level | Criteria |
|------------|----------|
| Low | In Review with mergeable PR |
| Medium | In Progress with active work |
| High | Not started, or 8+ point stories |

## Creating Recurring Sprint Tasks

> **Note:** Create these tasks only when requested by the user.

For recurring operational tasks that happen each sprint:

```bash
# Create operational task
jira issue create --project PITCREW --type Task \
  --summary "<task name> - Sprint NNN" \
  --no-input

# Add to sprint (get sprint ID first)
jira sprint add <sprint-id> <issue-key>
```

### Story Points
- Set manually in JIRA UI after creation based on team conventions

## Output Templates

### Sprint Review Summary

```markdown
## Sprint NNN Review - PITCREW

### Sprint Details
- **Sprint:** PitCrew Sprint NNN
- **Duration:** MMM DD - MMM DD, YYYY

### Sprint Statistics
| Metric | Value |
|--------|-------|
| Total Committed | X pts (N items) |
| Completed | X pts (N items) |
| Completion Rate | X% |

### Completed Work (X pts)

#### Theme 1
| Key | Summary | Owner | Pts |
|-----|---------|-------|-----|

#### Theme 2
...

### Team Performance
| Team Member | Closed | Open | Total | Completion |
|-------------|--------|------|-------|------------|

### Key Accomplishments
1. ...
2. ...

### Items Needing Attention
| Key | Summary | Issue |
|-----|---------|-------|

### Lessons Learned
| What Worked | What Didn't |
|-------------|-------------|
```

### Sprint Planning Summary

```markdown
## Sprint NNN Planning - PITCREW

### Sprint Details
- **Sprint:** PitCrew Sprint NNN
- **Duration:** MMM DD - MMM DD, YYYY

### Sprint Composition
| Category | Points | Items |
|----------|--------|-------|
| Operational Tasks | X | N |
| Carryover - In Review | X | N |
| Carryover - In Progress | X | N |
| Carryover - New | X | N |
| New Work | X | N |
| **Total** | X | N |

### Sprint Backlog
| Key | Summary | Assignee | Pts | Status |
|-----|---------|----------|-----|--------|

### Team Load
| Team Member | Points | Items | Notes |
|-------------|--------|-------|-------|

### Velocity Target
| Metric | Previous | Target |
|--------|----------|--------|
| Committed | X pts | X pts |
| Expected Completion | X pts | X pts |
| Daily Velocity | X pts | X pts |

### Risk Assessment
| Risk | Mitigation |
|------|------------|

### Action Items
| Action | Owner | Due |
|--------|-------|-----|
```

## Velocity Benchmarks

| Velocity | Assessment |
|----------|------------|
| > 5 pts/day | Excellent |
| 3-5 pts/day | Good |
| 2-3 pts/day | Below target |
| < 2 pts/day | Needs attention |

| Completion Rate | Assessment |
|-----------------|------------|
| > 80% | Excellent |
| 70-80% | Good (target) |
| 50-70% | Below target |
| < 50% | Needs attention |

## Tips

1. **Check PR status for Review items** - Quick wins if mergeable
2. **Watch 8-point stories** - High risk, consider splitting (see `jira-estimation` skill)
3. **Account for operational overhead** - Recurring tasks each sprint
4. **Realistic carryover** - Don't carry forward items that weren't started
5. **Close completed items** - Check if PRs were merged but JIRA not updated
6. **Rebase conflicting PRs** - Address before bringing into new sprint
