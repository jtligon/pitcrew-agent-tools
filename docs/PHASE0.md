# Phase 0: Scope & Inventory

Decisions and reference data for customizing pitcrew-agent-tools from coreos-agent-tools.

**Status:** in progress — upstream repos confirmed; JIRA audit and scope decisions still need confirmation.

---

## Primary use case

**Proposed (confirm):**

| Layer | In scope? | Notes |
|-------|-----------|-------|
| JIRA PO workflows | Yes | bug/feature triage, estimation, sprint planning — skills exist |
| Upstream code investigation | Yes | Jumpstarter + automotive-dev-operator repos |
| CI pipeline monitoring | No (for now) | coreos Jenkins/kola agents deferred unless needed later |
| Container / OpenCode agent | Later | skills-only + Claude Code is sufficient for Phase 1–2 |

---

## Runtime

| Option | Decision |
|--------|----------|
| Claude Code skills | **Current** — `go/skills/` loaded from repo |
| OpenCode container | **Deferred** — port from coreos-agent-tools when PO workflows stabilize |
| Go CLI (`pitcrew-tools`) | **Deferred** — only needed for Jenkins/CI layer |

---

## Upstream repositories

Primary repos the agent should know about (maps to future `pitcrew-repositories` skill).

### Jumpstarter

| | |
|---|---|
| **URL** | https://github.com/jumpstarter-dev/jumpstarter |
| **JIRA component** | Jumpstarter |
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
| **JIRA component** | CAIB |
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
Jumpstarter                          Automotive Dev Operator
(HiL testing, device automation)     (automotive OS image builds on OpenShift)
        │                                        │
        └──────── PITCREW product scope ─────────┘
              (bugs/features tracked in JIRA)
```

No direct code dependency between the two repos today; PITCREW owns PO/triage across both product areas.

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

### Confirmed from skills / CLAUDE.md

| Field | Value |
|-------|-------|
| Project key | `PITCREW` |
| Host | `redhat.atlassian.net` (from local jira CLI config) |
| Components | Jumpstarter, CAIB, Security |
| Sprint naming | `PITCREW - Sprint NNN` |
| Story points field | `customfield_10028` |
| Sprint field | `customfield_10020` |
| Epic link field | `customfield_10014` |

### Issue types (from README / skills)

- Bug
- Feature (feature requests / RFEs)
- Story
- Task
- Epic

### Label taxonomy (from `bug-triage` skill)

**Triage workflow:** `triaged`, `in-progress`, `blocked`, `needs-info`

**Other:** `verified`, `automotive`, `customer-reported`, `regression`, `QE`, `sustaining`, `blocker`, `documentation`, `CTC bugs`

### Still to verify (run locally)

```bash
source ~/.config/jira/auth.sh
jira issue list --project PITCREW --plain --columns key,issuetype,status | head
jira board list --project PITCREW
jira sprint list --project PITCREW --state active
```

- [ ] Board name for `jira init`
- [ ] Full component list matches JIRA (Jumpstarter, CAIB, Security)
- [ ] Custom field IDs still correct (`customfield_10028`, etc.)
- [ ] Terminal status names (`Closed` vs `Done` vs `Resolved`)

---

## Related JIRA projects

**TBD — fill in cross-project links PITCREW issues reference:**

| Project | Relationship | Example use |
|---------|--------------|-------------|
| | Customer escalations | |
| | Upstream engineering | |
| | Security | |

---

## Open decisions

Answer these to close Phase 0:

1. **Use case confirm** — Is CI pipeline monitoring permanently out of scope, or wanted later?
2. **Container timeline** — When (if ever) to port the OpenCode container from coreos-agent-tools?
3. **Related JIRA projects** — Which projects do PITCREW bugs/features link to?
4. **Board name** — Exact scrum board name for `jira init`
5. **Security component** — What upstream repo(s) map to the Security JIRA component?

---

## Notes

| Date | Note |
|------|------|
| 2026-05-29 | Phase 0 doc created |
| 2026-05-29 | Upstream repos confirmed: jumpstarter, automotive-dev-operator |
