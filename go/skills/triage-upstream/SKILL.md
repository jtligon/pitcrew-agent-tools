---
name: triage-upstream
description: Triage unreviewed GitHub issues in Jumpstarter and automotive-dev-operator — find matching PITCREW tickets and apply upstream/jira labels
---

# Triage Upstream

Map **unreviewed** open GitHub issues in PITCREW upstream repos to existing **PITCREW** JIRA tickets. When a match exists, label both sides so the issue is not re-triaged.

> **Requires:** `pitcrew-repositories` (repo/component map)  
> **Tools:** `gh` (upstream), `jira` CLI only (PITCREW — not Atlassian MCP)

## Label conventions

| System | Label | Meaning |
|--------|-------|---------|
| **GitHub** (upstream issue) | `jira` | PO has linked this GitHub issue to PITCREW work |
| **JIRA** (PITCREW issue) | `upstream` | This ticket tracks or relates to an upstream GitHub issue |

**Unreviewed** upstream issue = open GitHub issue **without** the `jira` label.

Do not use `already-checked` for this workflow unless the team explicitly standardizes on it elsewhere.

### One-time setup (if labels are missing)

```bash
# GitHub — run per repo if `jira` label does not exist
gh label create jira --repo jumpstarter-dev/jumpstarter --description "Tracked in PITCREW Jira" --color "1D76DB"
gh label create jira --repo centos-automotive-suite/automotive-dev-operator --description "Tracked in PITCREW Jira" --color "1D76DB"
```

JIRA label `upstream` must exist on project **PITCREW** (create in JIRA UI if `jira issue edit` fails with unknown label).

---

## Repos in scope

| Repo | JIRA component |
|------|----------------|
| `jumpstarter-dev/jumpstarter` | `Jumpstarter` |
| `centos-automotive-suite/automotive-dev-operator` | `Automotive-dev-operator` |

**Not in scope:** `Security` component (no product GitHub repo).

---

## Auth

```bash
source ~/.config/jira/auth.sh
unset JIRA_AUTH_TYPE
```

---

## Workflow

### 1. List unreviewed upstream issues

```bash
# Jumpstarter
gh issue list --repo jumpstarter-dev/jumpstarter --state open \
  --search "no:label jira" --limit 50 \
  --json number,title,url,labels

# Automotive Dev Operator
gh issue list --repo centos-automotive-suite/automotive-dev-operator --state open \
  --search "no:label jira" --limit 50 \
  --json number,title,url,labels
```

Process issues oldest-first or by team priority if the user specifies.

### 2. Search PITCREW for an existing ticket

For each GitHub issue `owner/repo#N`, search with the matching **component**.

**Priority order** (stop at first strong match):

| Priority | Signal | JQL / command |
|----------|--------|----------------|
| 1 | Full URL or `issues/N` in description | `project = PITCREW AND component = "<Component>" AND text ~ "issues/<N>"` |
| 2 | `#N` in summary (common pattern) | `project = PITCREW AND component = "<Component>" AND summary ~ "#<N>"` |
| 3 | Distinctive title keywords | `project = PITCREW AND component = "<Component>" AND summary ~ "<phrase>"` |

```bash
# Example: automotive-dev-operator issue #288
jira issue list -q 'project = PITCREW AND component = "Automotive-dev-operator" AND text ~ "issues/288"' \
  --plain --columns key,summary,status,labels

jira issue list -q 'project = PITCREW AND component = "Automotive-dev-operator" AND summary ~ "#288"' \
  --plain --columns key,summary,status,labels
```

```bash
# Example: jumpstarter issue #710
jira issue list -q 'project = PITCREW AND component = Jumpstarter AND text ~ "issues/710"' \
  --plain --columns key,summary,status,labels
```

Review multiple candidates manually (`jira issue view <KEY>`) before labeling.

### 3. On match — apply labels

**JIRA** — add `upstream` to the matched PITCREW issue:

```bash
jira issue edit PITCREW-404 --label upstream --no-input
```

**GitHub** — add `jira` to the upstream issue:

```bash
gh issue edit 288 --repo centos-automotive-suite/automotive-dev-operator --add-label jira
gh issue edit 710 --repo jumpstarter-dev/jumpstarter --add-label jira
```

Optional: add a short JIRA comment with the GitHub URL if comments are permitted:

```bash
jira issue comment add PITCREW-404 "Upstream: https://github.com/centos-automotive-suite/automotive-dev-operator/issues/288" --no-input
```

### 4. No match — report only

Do **not** create a PITCREW issue unless the user asks. Report:

- GitHub `owner/repo#N` + title
- Component inferred
- Suggested next step: create Story/Task, or ignore, or investigate further

---

## Triage report template

```markdown
## Upstream triage — <repo> — <date>

| GitHub | Title | PITCREW match | Action |
|--------|-------|---------------|--------|
| repo#288 | refactor e2e/lanes... | PITCREW-404 | Labeled `upstream` + `jira` |
| repo#711 | ssh-mount: StrictHostKeyChecking... | — | No match; needs new ticket? |

**Applied:** N linked, M unlinked.
```

---

## Permission handling

If `jira issue edit`, `jira issue comment add`, or `gh issue edit` fails:

1. Record the intended labels in the report.
2. Ask the user to apply manually.
3. Do not mark as triaged on only one system (avoid JIRA `upstream` without GitHub `jira`, or the reverse).

---

## Dry run (no labels)

```bash
./scripts/triage-upstream-dry-run.sh
# Optional: scan more issues per repo
LIMIT=50 ./scripts/triage-upstream-dry-run.sh
```

Reports what would get JIRA `upstream` and GitHub `jira` without calling `jira issue edit` or `gh issue edit`.

---

## Batch run (both repos)

```bash
source ~/.config/jira/auth.sh
unset JIRA_AUTH_TYPE

for repo in jumpstarter-dev/jumpstarter centos-automotive-suite/automotive-dev-operator; do
  echo "=== $repo ==="
  gh issue list --repo "$repo" --state open --search "no:label jira" --limit 20 \
    --json number,title
done
```

Then triage each issue with section 2–4.

---

## Related skills

- **`pitcrew-repositories`** — component ↔ repo routing
- **`bug-triage`** / **`feature-triage`** — JIRA-side triage after link exists
- **`bug-investigation`** — technical deep dive once `PITCREW-NNN` is confirmed
