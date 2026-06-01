---
name: bug-investigation
description: Investigate PITCREW bugs — trace upstream GitHub issues/PRs, code paths in Jumpstarter and automotive-dev-operator, and CI failures
---

# Bug Investigation (PITCREW)

Root-cause investigation for bugs tracked in **PITCREW**, grounded in upstream GitHub repos (Jumpstarter, Automotive Dev Operator).

> **Requires:** `pitcrew-repositories` (repo map), `triage-upstream` (GitHub `jira` / JIRA `upstream` labels)  
> **Tools:** `jira` CLI (PITCREW), `gh` (upstream). Do not use Atlassian MCP.

```bash
source ~/.config/jira/auth.sh
unset JIRA_AUTH_TYPE
```

---

## Investigation flow

1. **`jira issue view PITCREW-NNN`** — summary, description, component, labels (`upstream`?), links, comments.
2. **Route to repo** via component or URLs in description (`pitcrew-repositories`).
3. **Upstream** — GitHub issue/PR, commits, Actions logs (`gh`).
4. **Document** — findings in JIRA comment or investigation note; link upstream URLs.

---

## JIRA CLI

```bash
jira issue view PITCREW-NNN
jira issue view PITCREW-NNN --comments 20

# Related open work (same component)
jira issue list -q 'project = PITCREW AND component = Jumpstarter AND status != Closed' \
  --plain --columns key,summary,status
```

---

## Upstream GitHub

### Issue and PR context

```bash
# From PITCREW description or summary (e.g. issues/288, PR 693)
gh issue view 288 --repo centos-automotive-suite/automotive-dev-operator
gh pr view 693 --repo jumpstarter-dev/jumpstarter

gh issue view 288 --repo centos-automotive-suite/automotive-dev-operator --comments
gh pr checks 693 --repo jumpstarter-dev/jumpstarter
```

### Code search

```bash
gh search code "error string or symbol" --repo jumpstarter-dev/jumpstarter
gh search code "ImageBuild" --repo centos-automotive-suite/automotive-dev-operator

# List tree for orientation
gh api repos/jumpstarter-dev/jumpstarter/git/trees/main?recursive=1 \
  --jq '.tree[].path' | grep -E '^python/|^controller/' | head -30
```

### Commits and diffs

```bash
gh api repos/jumpstarter-dev/jumpstarter/commits/<sha> \
  --jq '{sha: .sha, message: .commit.message, files: [.files[].filename]}'

gh pr diff 693 --repo jumpstarter-dev/jumpstarter
```

### Actions / CI

```bash
gh run list --repo jumpstarter-dev/jumpstarter --limit 10
gh run view <run-id> --repo jumpstarter-dev/jumpstarter --log-failed

gh run list --repo centos-automotive-suite/automotive-dev-operator --limit 10
```

---

## Where to look by product

Use **`pitcrew-repositories`** for full path tables. Short guide:

### Jumpstarter (`component = Jumpstarter`)

| Area | Paths | Typical failures |
|------|-------|------------------|
| Client / CLI / tests | `python/` | Driver errors, pytest, `jmp` |
| Operator | `controller/` | Reconcile, CRD status |
| API / RPC | `protocol/` | gRPC, protobuf mismatches |
| Integration | `e2e/` | HiL, exporter, lease lifecycle |

### Automotive Dev Operator (`component = Automotive-dev-operator`)

| Area | Paths | Typical failures |
|------|-------|------------------|
| CLI | `cmd/caib/` | ImageBuild create/monitor |
| CRD / API | `api/` | ImageBuild spec/status |
| Controller | `internal/controller/` | Reconcile, Tekton triggers |
| Build API | `internal/buildapi/`, `cmd/build-api/` | Pipeline integration |
| E2E | (repo e2e workflows) | Builder tiers, lanes — see issue title/`#NNN` |

### Security component

Embargoed CVEs — **no public upstream investigation** unless the ticket explicitly references a public repo/issue. Do not post embargo details to GitHub.

---

## Linking upstream ↔ PITCREW

If investigation confirms the GitHub issue is tracked in JIRA:

| Action | Command |
|--------|---------|
| Mark JIRA | `jira issue edit PITCREW-NNN --label upstream --no-input` |
| Mark GitHub | `gh issue edit <N> --repo <owner/repo> --add-label jira` |

See **`triage-upstream`** for batch mapping of unreviewed GitHub issues.

Optional JIRA comment template:

```markdown
## Investigation
- **Upstream:** https://github.com/<org>/<repo>/issues/<N>
- **Area:** <path or subsystem>
- **Finding:** <1–3 sentences>
- **Next:** <PR / fix owner / waiting on CI>
```

---

## Evidence checklist

| Evidence | Source |
|----------|--------|
| Reproducer steps | JIRA description, GitHub issue |
| Error text / stack | GitHub comments, Actions logs, local logs |
| Introduced in | `gh pr list` / `git log` / bisect on upstream |
| Fix in flight | Linked PR state, review comments |
| Regression scope | Other open `PITCREW` + same component |

---

## Investigation note template

```markdown
## PITCREW-NNN — Investigation

**Component:** Jumpstarter | Automotive-dev-operator
**Upstream:** <owner/repo>#<N> or PR #<N>

### Summary
<what is broken, user impact>

### Root cause (hypothesis or confirmed)
<technical explanation>

### Evidence
- <log excerpt, commit, PR link>

### Recommendation
- [ ] Fix in upstream PR #...
- [ ] Track only in PITCREW
- [ ] Needs more info from reporter
```

---

## Related skills

- **`bug-triage`** — priority, labels (`triaged`, `blocked`, …)
- **`pitcrew-repositories`** — repo and path routing
- **`triage-upstream`** — find PITCREW key for a new GitHub issue
