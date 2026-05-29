# Upstream triage run — 2026-05-29

Shareable summary of the first **triage-upstream** dry run and label application for the PITCREW team.

## What we are doing

PITCREW tracks work in Jira (`PITCREW` project, **PitCrew** board) while engineering happens in two upstream GitHub repos:

| JIRA component | GitHub repo |
|----------------|-------------|
| Jumpstarter | [jumpstarter-dev/jumpstarter](https://github.com/jumpstarter-dev/jumpstarter) |
| Automotive-dev-operator | [centos-automotive-suite/automotive-dev-operator](https://github.com/centos-automotive-suite/automotive-dev-operator) |

**triage-upstream** links open GitHub issues that PO has not yet reviewed to existing Jira tickets, using a pair of labels:

| System | Label | Meaning |
|--------|-------|---------|
| **Jira** (PITCREW issue) | `upstream` | This ticket tracks an upstream GitHub issue |
| **GitHub** (upstream issue) | `jira` | This GitHub issue is linked to PITCREW |

**Unreviewed** on GitHub = open issue **without** the `jira` label.

Workflow docs and automation live in this repo: `go/skills/triage-upstream/`, dry-run script `scripts/triage-upstream-dry-run.sh`.

---

## Dry run (no labels)

We scanned the first **20 open GitHub issues per repo** that did not already have the `jira` label, and searched Jira for:

1. `text ~ "issues/<number>"` in the matching component  
2. `summary ~ "#<number>"` in the matching component  

### Jumpstarter

- **20** issues without GitHub `jira` label  
- **0** automatic matches to an existing PITCREW ticket  
- **Action:** PO still needs to triage these manually (or improve search/linking in Jira descriptions)

### Automotive-dev-operator

- **20** issues without GitHub `jira` label  
- **1** match  
- **19** no Jira hit with current rules  

| GitHub | Jira match |
|--------|------------|
| [#288](https://github.com/centos-automotive-suite/automotive-dev-operator/issues/288) — refactor e2e/lanes workflow | [**PITCREW-404**](https://redhat.atlassian.net/browse/PITCREW-404) (summary already references `#288`; description contains the GitHub URL) |

---

## Labels applied (2026-05-29)

Per dry-run agreement, we applied labels for the **one confirmed match**:

| Item | Result |
|------|--------|
| **PITCREW-404** | Jira label **`upstream`** added (via Jira REST API) |
| **automotive-dev-operator#288** | GitHub label **`jira`** — **not applied** (see below) |

### GitHub label blocker

Creating or adding the `jira` label on `centos-automotive-suite/automotive-dev-operator` returned **HTTP 404** with the current GitHub token (`jtligon`). That usually means the account lacks permission to manage labels in that org/repo.

**Ask a repo admin to:**

1. Create label **`jira`** (description e.g. “Tracked in PITCREW Jira”, color blue), or  
2. Add **`jira`** to issue [#288](https://github.com/centos-automotive-suite/automotive-dev-operator/issues/288) manually  

```bash
# Once the label exists and you have permission:
gh issue edit 288 --repo centos-automotive-suite/automotive-dev-operator --add-label jira
```

Jira side is complete; GitHub side is pending org permissions.

---

## Suggested team conventions

1. When creating a PITCREW ticket for upstream work, put the **full GitHub issue URL** in the description and **`#N`** in the summary when possible — this makes triage-upstream matching reliable.  
2. After linking, apply **`upstream`** (Jira) and **`jira`** (GitHub).  
3. Run a dry run before bulk labeling: `./scripts/triage-upstream-dry-run.sh`  
4. Jumpstarter backlog: many open issues are not yet referenced in PITCREW — expect low match rate until summaries/descriptions include issue numbers or URLs.

---

## References

- Skill: `go/skills/triage-upstream/SKILL.md`  
- Repo map: `go/skills/pitcrew-repositories/SKILL.md`  
- Phase 0 / board: `docs/PHASE0.md`
