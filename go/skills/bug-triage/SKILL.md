---
name: bug-triage
description: Triage bugs and failures - categorization, severity assessment, and root cause analysis patterns
---

# Bug Triage

Knowledge for triaging bugs, failures, and issues in the PITCREW project.

## Querying Bugs for Triage

### JQL Query for PITCREW Bugs

Use this JQL to get bugs needing triage in the PITCREW project:

```jql
project = PITCREW AND issuetype = Bug AND status not in (Closed, Done, Resolved, Cancelled)
```

### JIRA CLI Commands

```bash
# List bugs with key columns
jira issue list -q '<JQL>' --plain --columns key,summary,status,priority,assignee,created

# List bugs with labels for triage status
jira issue list -q '<JQL>' --plain --columns key,summary,status,labels

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

1. **New Bug** (no labels) - Bug is filed
2. **triaged** - Initial review complete, then one of:
   - **in-progress** - Actively investigating/developing fix
   - **blocked** - Waiting on external dependency
   - **needs-info** - Waiting for more details
3. **Closed/Verified** - Fix delivered and confirmed

### Identifying Untriaged Bugs

Bugs needing triage have:
- Status = `New` or `Open`
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
| **Critical** | Pipeline blocked, cluster install broken, upgrade blocker | Immediate |
| **Major** | Core functionality affected, no workaround | Same day |
| **Normal** | Standard bugs, workarounds may exist | Within sprint |
| **Minor** | Low impact, cosmetic issues | Backlog |
| **Undefined** | Needs triage to determine priority | Triage immediately |

## Triage Checklist

When triaging a new bug:

1. **Review the bug description**
   - Understand the reported issue
   - Check for reproducibility information
   - Note affected OCP/RHCOS versions

2. **Check for duplicates**
   - Search for similar issues
   - Link duplicates if found

3. **Identify affected component**
   - Is this RHCOS, MCO, rpm-ostree, ignition, etc.?
   - Is this a kernel/RHEL package issue?

4. **Determine blocking status**
   - Does this block installs?
   - Does this block upgrades?
   - Is this a regression?

5. **Apply appropriate labels**
   - Add `rhcos-triaged` after review
   - Add component labels (`RHCOS10`, `sno`, etc.)
   - Add `rhcos-waitingonrhel` if RHEL dependency
   - Add `rhcos-bootimage-needed` if bootimage required

6. **Set priority**
   - Critical/Major for blockers
   - Normal for standard bugs
   - Minor for low impact

## Root Cause Analysis Structure

When analyzing a failure, document:

1. **Evidence**
   - Build number, job, stream, timestamp
   - Error messages (verbatim, in code blocks)
   - Relevant log snippets

2. **Analysis**
   - What changed between last good and failed build
   - Package changes (use `builds diff`)
   - coreos-assembler changes
   - Infrastructure changes

3. **Conclusion**
   - Identified root cause with confidence level
   - Relevant commits/PRs
   - Whether this is a regression or new issue

4. **Recommendations**
   - Specific fix suggestions
   - Links to relevant PRs/issues
   - Workarounds if available
   - Whether retry is appropriate
