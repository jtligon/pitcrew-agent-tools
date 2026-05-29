---
name: pipeline-jira
description: PITCREW JIRA linking conventions — upstream GitHub issues, labels, comments, and issue relationships
---

# PITCREW JIRA Linking

JIRA CLI patterns for linking PITCREW work to upstream GitHub and related tickets. **Not** for CoreOS/Jenkins pipeline monitoring (out of scope).

> Related: `triage-upstream`, `pitcrew-repositories`, `bug-investigation`

```bash
source ~/.config/jira/auth.sh
unset JIRA_AUTH_TYPE
```

---

## Labels

| Label | Use on | Meaning |
|-------|--------|---------|
| `upstream` | PITCREW issue | Tracks work tied to an upstream GitHub issue/PR |
| `triaged` | PITCREW Bug | PO reviewed (`bug-triage`) |
| `in-progress`, `blocked`, `needs-info` | PITCREW Bug | Workflow (`bug-triage`) |

**GitHub (upstream):** label `jira` = linked to PITCREW. See **`triage-upstream`**.

```bash
jira issue edit PITCREW-404 --label upstream --no-input
```

---

## Common CLI operations

```bash
# View
jira issue view PITCREW-NNN
jira issue view PITCREW-NNN --comments 20

# Comment (positional text, not --body)
jira issue comment add PITCREW-NNN "Upstream: https://github.com/centos-automotive-suite/automotive-dev-operator/issues/288"

# List by component
jira issue list -q 'project = PITCREW AND component = Jumpstarter AND labels = upstream' \
  --plain --columns key,summary,status,labels

# Open bugs without upstream label (may still have GitHub link in text)
jira issue list -q 'project = PITCREW AND issuetype = Bug AND labels != upstream AND status != Closed' \
  --plain --columns key,summary,labels
```

---

## Linking upstream GitHub in descriptions

Preferred patterns (aids search and `triage-upstream` matching):

| Pattern | Example |
|---------|---------|
| Full URL in description | `https://github.com/jumpstarter-dev/jumpstarter/issues/710` |
| Issue ref in summary | `jumpstarter: fix lease transfer #712` |
| Hash suffix | `refactor e2e/lanes workflow #288` |

Search before creating a duplicate:

```bash
jira issue list -q 'project = PITCREW AND text ~ "issues/288"' --plain --columns key,summary
```

---

## Issue links (relates / blocks / clones)

Use project-allowed link types when connecting PITCREW issues:

```bash
# Inspect existing links on a ticket
jira issue view PITCREW-NNN --plain
```

If the CLI or API for creating links is unavailable, document the intended link in a comment:

```markdown
Relates to PITCREW-383 (parent e2e effort).
Clones upstream scope from automotive-dev-operator#288.
```

**Permission note:** If link or comment commands fail with 400/403, report the intended links for manual update in JIRA UI.

---

## Creating PITCREW work from upstream (manual)

When **`triage-upstream`** finds no match and the user wants a new ticket:

```bash
# Story for feature-sized upstream issue
jira issue create --project PITCREW --type Story \
  --summary "jumpstarter: <short title> #<github-n>" \
  --no-input

# Bug for defect
jira issue create --project PITCREW --type Bug \
  --summary "builder: <short title> #<github-n>" \
  --no-input
```

Set **component** in JIRA UI (`Jumpstarter` or `Automotive-dev-operator`) if the CLI cannot set it. Add description with full GitHub URL, then:

```bash
jira issue edit PITCREW-NEW --label upstream --no-input
gh issue edit <N> --repo <owner/repo> --add-label jira
```

---

## Comment body template (upstream sync)

```markdown
## Upstream
- **Issue:** https://github.com/<org>/<repo>/issues/<N>
- **PR:** https://github.com/<org>/<repo>/pull/<N> (if any)

## Status
- **Upstream state:** open | merged | closed
- **PITCREW:** In Progress | Review | …

## Next steps
- <owner action>
```

---

## What this skill does not cover

- Jenkins / Tekton pipeline monitoring parent tasks (was COS `Pipeline monitoring - Sprint` — **deferred**)
- `pipeline-dedup`, `pipeline-failures` (CoreOS CI — skip unless PITCREW gains CI scope)
- OCPBUG / Brew / `oc adm release` (use automotive upstream investigation instead)
