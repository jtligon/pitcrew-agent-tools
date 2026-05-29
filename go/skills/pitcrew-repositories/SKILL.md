---
name: pitcrew-repositories
description: PITCREW upstream GitHub repositories, JIRA component mapping, key paths, and investigation entry points for Jumpstarter and Automotive Dev Operator
---

# PITCREW Repositories

Upstream GitHub repositories, JIRA component mapping, and where to look when investigating bugs or linking work.

> Related: `bug-investigation`, `bug-triage`, `triage-upstream` (planned), [docs/PHASE0.md](../../../docs/PHASE0.md)

## PITCREW ↔ upstream map

All engineering work shares one JIRA project (`PITCREW`) and **PitCrew** scrum board. **Components** route work to the right codebase:

| JIRA component | GitHub repo | Org | Product name |
|----------------|-------------|-----|--------------|
| `Jumpstarter` | [jumpstarter-dev/jumpstarter](https://github.com/jumpstarter-dev/jumpstarter) | jumpstarter-dev | Jumpstarter (HiL testing) |
| `Automotive-dev-operator` | [centos-automotive-suite/automotive-dev-operator](https://github.com/centos-automotive-suite/automotive-dev-operator) | centos-automotive-suite | CAIB / Automotive Dev Operator |
| `Security` | *(none)* | — | Embargoed CVEs from Product Security — not an upstream product repo |

When a PITCREW issue has a **component**, start investigation in the matching repo below. For **Security** issues, do not clone or search a product upstream repo unless the ticket explicitly references one.

### JIRA CLI: filter by component

```bash
source ~/.config/jira/auth.sh
unset JIRA_AUTH_TYPE

# Jumpstarter backlog
jira issue list -q 'project = PITCREW AND component = Jumpstarter AND status != Closed' --plain --columns key,summary,status

# CAIB / automotive-dev-operator backlog
jira issue list -q 'project = PITCREW AND component = "Automotive-dev-operator" AND status != Closed' --plain --columns key,summary,status
```

---

## Jumpstarter

| | |
|---|---|
| **Repo** | https://github.com/jumpstarter-dev/jumpstarter |
| **Docs** | https://jumpstarter.dev |
| **GitHub labels** | https://github.com/jumpstarter-dev/jumpstarter/labels |
| **CI** | GitHub Actions (`.github/workflows/`) |

Open-source HiL (hardware-in-the-loop) framework: Python client, Kubernetes controller, gRPC protocol, e2e infrastructure.

### Key paths (monorepo)

| Path | Purpose |
|------|---------|
| `python/` | Python client, `jmp` CLI, drivers, test framework |
| `controller/` | Kubernetes operator (Jumpstarter Service) |
| `protocol/` | gRPC / protobuf definitions |
| `e2e/` | End-to-end test infrastructure |
| `Makefile` | Build and dev targets |
| `.github/` | CI workflows, issue templates |

### Investigation entry points

| Symptom / topic | Where to look first |
|-----------------|---------------------|
| Client CLI / drivers / pytest | `python/` |
| CRD, operator reconcile, K8s | `controller/` |
| RPC errors, API contracts | `protocol/` |
| Full stack / integration failures | `e2e/` |
| CI failure on PR | `.github/workflows/`, PR checks via `gh` |

### GitHub CLI examples

```bash
# Open issues
gh issue list --repo jumpstarter-dev/jumpstarter --state open --limit 30

# Issue detail
gh issue view <number> --repo jumpstarter-dev/jumpstarter

# Recent PRs
gh pr list --repo jumpstarter-dev/jumpstarter --state open

# Search code (example)
gh search code "error message fragment" --repo jumpstarter-dev/jumpstarter
```

### Related org repos (secondary)

Use when the main monorepo does not explain the failure:

| Repo | Notes |
|------|-------|
| [jumpstarter-dev/jumpstarter-tekton-tasks](https://github.com/jumpstarter-dev/jumpstarter-tekton-tasks) | Tekton CI integration |
| [jumpstarter-dev/jumpstarter-controller](https://github.com/jumpstarter-dev/jumpstarter-controller) | Split controller (confirm vs monorepo `controller/`) |
| [jumpstarter-dev/jumpstarter-python](https://github.com/jumpstarter-dev/jumpstarter-python) | Legacy/split client (confirm vs monorepo `python/`) |
| [jumpstarter-dev/dutlink-board](https://github.com/jumpstarter-dev/dutlink-board), [dutlink-firmware](https://github.com/jumpstarter-dev/dutlink-firmware) | Open hardware test harness |

---

## Automotive Dev Operator (CAIB)

| | |
|---|---|
| **Repo** | https://github.com/centos-automotive-suite/automotive-dev-operator |
| **Docs** | https://sigs.centos.org/automotive/latest/ (AutoSD / AIB) |
| **CI** | GitHub Actions (`.github/workflows/`), Tekton on OpenShift for builds |

OpenShift operator for automotive OS image builds via **Automotive Image Builder (AIB)**. Ships the **`caib` CLI** and **ImageBuild** CRD.

### Key paths

| Path | Purpose |
|------|---------|
| `cmd/caib/` | `caib` CLI — create and monitor ImageBuild CRs |
| `cmd/build-api/` | Build API entrypoints |
| `cmd/export-tasks/` | Export task utilities |
| `api/` | ImageBuild CRD and API types |
| `internal/controller/` | Operator reconciliation |
| `internal/buildapi/` | Build API implementation |
| `config/` | Deployment manifests, RBAC, samples |
| `bundle.Dockerfile`, `catalog.Dockerfile` | OLM bundle/catalog images |
| `.github/` | CI workflows |

### Build modes (product context)

- **Traditional AIB manifest builds** — disk images from manifests
- **bootc container builds** — immutable production-style images

### Investigation entry points

| Symptom / topic | Where to look first |
|-----------------|---------------------|
| CLI / user-facing `caib` behavior | `cmd/caib/` |
| ImageBuild CR status, reconcile loops | `api/`, `internal/controller/` |
| Build API / pipeline integration | `internal/buildapi/`, `cmd/build-api/` |
| Deploy / RBAC / operator install | `config/` |
| CI on PR | `.github/workflows/` |
| Tekton / cluster build failures | Operator logs + Tekton run; repo may reference tasks in cluster |

### GitHub CLI examples

```bash
gh issue list --repo centos-automotive-suite/automotive-dev-operator --state open --limit 30
gh issue view <number> --repo centos-automotive-suite/automotive-dev-operator
gh pr list --repo centos-automotive-suite/automotive-dev-operator --state open
```

---

## Repository relationship

```
PITCREW (Jira) / PitCrew (board)
        │
        ├── component Jumpstarter ──────► jumpstarter-dev/jumpstarter
        │
        ├── component Automotive-dev-operator ──► centos-automotive-suite/automotive-dev-operator
        │
        └── component Security ──► embargoed CVEs (no GitHub product repo)
```

There is **no shared monorepo** between Jumpstarter and automotive-dev-operator. Cross-product bugs are coordinated in JIRA, not via a single codebase.

---

## Choosing a repo from a PITCREW ticket

1. Read **component** on the JIRA issue — primary routing signal.
2. If component is empty, infer from **summary**, **description**, or links (`github.com/jumpstarter-dev/...` vs `github.com/centos-automotive-suite/...`).
3. If the ticket references a **GitHub issue/PR URL**, use that repo even if component is wrong (note mismatch for PO).
4. **Security** component: follow embargo handling; do not post CVE details to public GitHub issues.

### Linking pattern (for humans / agents)

When documenting findings on PITCREW, include:

- Upstream issue/PR: `owner/repo#number` or full URL
- Repo path or commit if known: `path/to/file.go:line`
- JIRA key: `PITCREW-NNN`

---

## Agent workflow

1. `jira issue view PITCREW-NNN` — note component, summary, links, labels.
2. Map component → repo using the table above.
3. Use `gh` to inspect upstream issues, PRs, and code; use local clone if the user has one.
4. Apply domain skills: `bug-investigation` for root cause, `bug-triage` / `feature-triage` for JIRA-side decisions.

**JIRA access:** `jira` CLI only (`source ~/.config/jira/auth.sh`; `unset JIRA_AUTH_TYPE`). Do not use Atlassian MCP.

**GitHub access:** `gh` with `GH_TOKEN` or `gh auth login` for private forks if applicable; both listed repos are public.

---

## Quick reference: clone URLs

```bash
git clone https://github.com/jumpstarter-dev/jumpstarter.git
git clone https://github.com/centos-automotive-suite/automotive-dev-operator.git
```
