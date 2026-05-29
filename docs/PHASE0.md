# Phase 0: Scope & Inventory

Decisions and reference data for customizing pitcrew-agent-tools from coreos-agent-tools.

**Status:** complete (2026-05-29) — verified with `jira` CLI. Re-run [scripts/verify-phase0-jira.sh](../scripts/verify-phase0-jira.sh) after token or project changes.

---

## Tooling

| Tool | Use for JIRA? |
|------|----------------|
| **`jira` CLI** | **Yes** — sole integration for agents and humans |
| Atlassian MCP | **No** — do not use; keep tokens in `~/.config/jira/auth.sh` only |

Load auth before commands: `source ~/.config/jira/auth.sh` and **do not** set `JIRA_AUTH_TYPE=bearer` for standard Atlassian API tokens on `redhat.atlassian.net` (causes 403).

---

## Primary use case

| Layer | In scope? | Notes |
|-------|-----------|-------|
| JIRA PO workflows | Yes | bug/feature triage, estimation, sprint planning — skills exist |
| Upstream code investigation | Yes | Jumpstarter + automotive-dev-operator repos |
| CI pipeline monitoring | No (for now) | coreos Jenkins/kola agents deferred; revisit if PO wants automated CI triage |
| Container / OpenCode agent | Later | port from coreos-agent-tools when PO workflows stabilize (Phase 3+) |

---

## Runtime

| Option | Decision |
|--------|----------|
| Claude Code skills | **Current** — `go/skills/` loaded from repo |
| OpenCode container | **Deferred** — port from coreos-agent-tools when PO workflows stabilize |
| Go CLI (`pitcrew-tools`) | **Deferred** — only needed for Jenkins/CI layer |

---

## PITCREW board and components

All work is tracked on one JIRA project and scrum board:

| Item | Value |
|------|-------|
| Project | `PITCREW` |
| Board | `PitCrew` |

**JIRA components** partition work on that board. Two components map to upstream codebases; the third is for Product Security only:

| Component | Upstream repo? | Role |
|-----------|----------------|------|
| `Jumpstarter` | Yes — [jumpstarter](https://github.com/jumpstarter-dev/jumpstarter) | HiL testing product area |
| `Automotive-dev-operator` | Yes — [automotive-dev-operator](https://github.com/centos-automotive-suite/automotive-dev-operator) | CAIB / automotive OS image builds |
| `Security` | **No** | Product Security assigns **embargoed CVEs** to PITCREW; not a third product codebase |

Jumpstarter and Automotive-dev-operator are separate engineering streams under the same PITCREW team. They do not share a monorepo, but both use the same board and PO workflows.

---

## Upstream repositories

Codebases tied to JIRA components (maps to future `pitcrew-repositories` skill). **Security is not listed here** — it has no upstream project.

### Jumpstarter

| | |
|---|---|
| **URL** | https://github.com/jumpstarter-dev/jumpstarter |
| **JIRA component** | `Jumpstarter` |
| **Purpose** | Open-source HiL (hardware-in-the-loop) testing framework; Python client, K8s controller, gRPC protocol |
| **Docs** | https://jumpstarter.dev |
| **Labels reference** | https://github.com/jumpstarter-dev/jumpstarter/labels |

**Key paths (monorepo):**

| Path | Purpose |
|------|---------|
| `python/` | Python client, `jmp` CLI, drivers, test framework |
| `controller/` | Kubernetes operator (Jumpstarter Service) |
| `protocol/` | gRPC / protobuf definitions |
| `e2e/` | End-to-end test infrastructure |

**Related org repos** (secondary — add to skill if agents need them):

- `jumpstarter-dev/jumpstarter-python` — legacy/split client (check if still active vs monorepo)
- `jumpstarter-dev/jumpstarter-controller`
- `jumpstarter-dev/jumpstarter-tekton-tasks` — CI integration
- `jumpstarter-dev/dutlink-board`, `dutlink-firmware` — open hardware test harness

### Automotive Dev Operator (CAIB)

| | |
|---|---|
| **URL** | https://github.com/centos-automotive-suite/automotive-dev-operator |
| **JIRA component** | `Automotive-dev-operator` (product area often called CAIB) |
| **Purpose** | OpenShift operator for building automotive OS images via Automotive Image Builder (AIB); includes `caib` CLI |
| **Docs** | https://sigs.centos.org/automotive/latest/ (AutoSD / AIB) |

**Key paths:**

| Path | Purpose |
|------|---------|
| `cmd/caib/` | `caib` CLI — create and monitor ImageBuild CRs |
| `api/` | ImageBuild CRD definitions |
| `config/` | Operator deployment manifests |
| `internal/` | Controller reconciliation, Tekton integration |

**Build modes:**

- Traditional AIB manifest builds (disk images)
- bootc container builds (production-style immutable images)

### Repository relationship

```
                    PitCrew board (PITCREW project)
                              │
        ┌─────────────────────┼─────────────────────┐
        │                     │                     │
   Jumpstarter      Automotive-dev-operator    Security
   (upstream repo)   (upstream repo)            (embargoed CVEs;
        │                     │                  no upstream repo)
        └────────── separate product areas ─────┘
              same team, shared PO/triage workflows
```

No direct code dependency between the two upstream repos today.

---

## CI systems

| System | Relevant to | In agent scope? |
|--------|-------------|-----------------|
| GitHub Actions | Both repos | Yes — PR/issue activity via `gh` |
| Tekton / OpenShift Pipelines | automotive-dev-operator | Maybe — investigate build failures manually for now |
| Jumpstarter Tekton tasks | jumpstarter-dev org | Maybe — link when debugging CI |
| Jenkins | — | **Out of scope** (coreos-specific; no PITCREW Jenkins URL defined) |

---

## JIRA configuration

Verified via `jira` CLI (2026-05-29).

| Field | Value |
|-------|-------|
| Project key | `PITCREW` |
| Host | `https://redhat.atlassian.net` |
| Project type | business |
| Default board | **`PitCrew`** (scrum, board ID `4323`) |
| Components | `Jumpstarter`, `Automotive-dev-operator`, `Security` (CVE embargoes only — not an upstream product) |
| Sprint naming | **`PitCrew Sprint N`** (e.g. `PitCrew Sprint 11`) |
| Story points field | `customfield_10028` |
| Sprint field | `customfield_10020` |
| Epic link field | `customfield_10014` |

### Issue types

- Bug
- Feature (feature requests / RFEs)
- Story
- Task
- Epic

### Statuses in use

`New`, `Refinement`, `In Progress`, `Review`, `Closed`

**Terminal status for JQL:** use `Closed` (this project does not use `Done`, `Resolved`, or `Cancelled`).

Skills still list `Done`/`Resolved`/`Cancelled` in some queries for portability; tighten in Phase 2.

### Label taxonomy (from `bug-triage` skill)

**Triage workflow:** `triaged`, `in-progress`, `blocked`, `needs-info`

**Other:** `verified`, `automotive`, `customer-reported`, `regression`, `QE`, `sustaining`, `blocker`, `documentation`, `CTC bugs`

### `jira init` reference

```bash
source ~/.config/jira/auth.sh
unset JIRA_AUTH_TYPE
jira init
# Server: https://redhat.atlassian.net
# Project: PITCREW
# Board: PitCrew
```

### Audit checklist

- [x] Board name — `PitCrew`
- [x] Components — Jumpstarter, Automotive-dev-operator, Security
- [x] Custom field IDs — `customfield_10028`, `10020`, `10014`
- [x] Terminal status — `Closed`

---

## Related JIRA projects

No cross-project issue links observed in spot checks. Fill this table when linking patterns emerge:

| Project | Relationship | Example use |
|---------|--------------|-------------|
| TBD | Customer escalations | |
| TBD | Upstream engineering | |
| (n/a) | Embargoed CVEs use component `Security` on PITCREW — not a separate JIRA project | |

---

## Phase 0 decisions (closed)

| # | Decision |
|---|----------|
| 1 | CI pipeline monitoring **out of scope** until a Jenkins/CI target is defined |
| 2 | OpenCode container **deferred** until PO skills/workflows are stable |
| 3 | Related JIRA projects — **document as discovered** (table above) |
| 4 | Board name — **`PitCrew`** |
| 5 | **Security component** — embargoed CVE intake only; **no upstream repo** |

---

## Notes

| Date | Note |
|------|------|
| 2026-05-29 | Phase 0 doc created |
| 2026-05-29 | Upstream repos confirmed: jumpstarter, automotive-dev-operator |
| 2026-05-29 | JIRA audit via CLI; fixed auth (`unset JIRA_AUTH_TYPE`); sprint/board names corrected |
| 2026-05-29 | Phase 0 closed — agents use `jira` CLI only, not Atlassian MCP |
| 2026-05-29 | Clarified components: two upstream products on PitCrew board; Security = embargoed CVEs only |
