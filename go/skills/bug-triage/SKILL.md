---
name: bug-triage
description: Triage bugs and failures - categorization, severity assessment, and root cause analysis patterns
---

# Bug Triage

Knowledge for triaging bugs, failures, and issues in the PITCREW project.

## Querying Bugs for Triage

### JQL Query for PITCREW Bugs

```jql
project = PITCREW AND issuetype = Bug 
  AND status not in (Closed, Done, Resolved, Cancelled)
```

### JIRA CLI Commands

```bash
# List all open bugs
jira issue list -q 'project = PITCREW AND issuetype = Bug AND status not in (Closed, Done, Resolved, Cancelled)' --plain --columns key,summary,status,priority,assignee,created,labels

# List untriaged bugs (no triaged label)
jira issue list -q 'project = PITCREW AND issuetype = Bug AND labels != triaged AND status not in (Closed, Done, Resolved, Cancelled)' --plain --columns key,summary,status,priority,assignee,labels

# View specific issue details
jira issue view <ISSUE-KEY>
```

## PITCREW Triage Labels

### Primary Triage Labels

| Label | Purpose | When to Apply |
|-------|---------|---------------|
| `triaged` | Bug has been reviewed and triaged by PITCREW team | After initial review and categorization |
| `in-progress` | Team is actively investigating/working on the issue | When actively debugging or developing fix |
| `blocked` | Bug is blocked waiting on external dependency | When blocked on another team or external factor |
| `needs-info` | Requires additional information from reporter | When details are missing |

### Triage Workflow

1. **New Bug** - Bug issue is created
2. **triaged** - Initial review complete, then one of:
   - **in-progress** - Actively investigating/developing fix
   - **blocked** - Waiting on external dependency
   - **needs-info** - Waiting for more details
3. **Closed/Verified** - Fix delivered and confirmed

### Identifying Untriaged Bugs

Bugs needing triage have:
- Issue type = `Bug`
- Status = `New`, `Open`, or `To Do`
- No `triaged` label
- No `in-progress` label

### Other Common Labels

| Label | Purpose |
|-------|---------|
| `verified` | Fix has been verified |
| `automotive` | Automotive-specific functionality |
| `customer-reported` | Reported by external customer |
| `regression` | Previously working functionality |
| `QE` | QE team involvement |
| `sustaining` | Sustaining engineering issue |
| `blocker` | Blocks critical functionality |
| `documentation` | Documentation related |

## Severity Classification

### JIRA Priority Mapping

| Priority | Criteria | Response Time |
|----------|----------|---------------|
| **Critical** | Customer deployment blocked, critical functionality broken, security issue | Immediate |
| **Major** | Core functionality affected, no workaround | Same day |
| **Normal** | Standard bugs, workarounds may exist | Within sprint |
| **Minor** | Low impact, cosmetic issues, enhancement | Backlog |
| **Undefined** | Needs triage to determine priority | Triage immediately |

## Triage Checklist

When triaging a new bug:

1. **Review the bug description**
   - Understand the reported issue
   - Check for reproducibility information
   - Note affected product versions and environments

2. **Check for duplicates**
   - Search for similar issues: `project = PITCREW AND labels = "CTC bugs" AND summary ~ "keyword"`
   - Link duplicates if found

3. **Identify affected component**
   - Which product/component is affected?
   - Is this a dependency issue?
   - Customer-specific or general?

4. **Determine blocking status**
   - Does this block customer deployments?
   - Does this affect critical functionality?
   - Is this a regression from previous version?

5. **Apply appropriate labels**
   - Add `triaged` after review
   - Add component/product labels
   - Add `blocked` if external dependency
   - Add `customer-reported` if from customer
   - Add `regression` if previously working

6. **Set priority**
   - Critical/Major for blockers or customer-impacting
   - Normal for standard bugs
   - Minor for low impact

## Root Cause Analysis Structure

When analyzing a bug, document:

1. **Evidence**
   - Product version, environment, timestamp
   - Error messages (verbatim, in code blocks)
   - Relevant log snippets
   - Steps to reproduce

2. **Analysis**
   - What changed between working and failing state
   - Recent code/config changes
   - Environmental factors
   - Dependency changes

3. **Conclusion**
   - Identified root cause with confidence level
   - Relevant commits/PRs
   - Whether this is a regression or new issue
   - Impact assessment

4. **Recommendations**
   - Specific fix suggestions
   - Links to relevant PRs/issues
   - Workarounds if available
   - Prevention measures for similar issues
