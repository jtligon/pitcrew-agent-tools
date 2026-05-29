# PITCREW Agent Tools — Customization Roadmap

Track progress porting and customizing tools/skills from [coreos-agent-tools](https://github.com/cverna/coreos-agent-tools).

**Legend:** `[ ]` todo · `[x]` done · `[~]` in progress · `[-]` skipped / not needed

Update checkboxes as you work. Add notes inline or link PRs/commits next to items.

---

## Phase 0: Scope & inventory — complete

See **[docs/PHASE0.md](docs/PHASE0.md)** for full details.

- [x] Document primary use case — JIRA PO + upstream investigation; CI/container deferred
- [x] Choose runtime — Claude Code skills now; OpenCode container later
- [x] Inventory upstream repos — [jumpstarter](https://github.com/jumpstarter-dev/jumpstarter), [automotive-dev-operator](https://github.com/centos-automotive-suite/automotive-dev-operator)
- [x] Audit JIRA project structure (via `jira` CLI — see `scripts/verify-phase0-jira.sh`):
  - [x] Host URL — `redhat.atlassian.net`
  - [x] Issue types — Bug, Feature, Story, Task, Epic
  - [x] Components — Jumpstarter + Automotive-dev-operator (upstream); Security (embargoed CVEs, no repo)
  - [x] Label taxonomy — documented in `bug-triage` skill
  - [x] Story points custom field ID — `customfield_10028`
  - [x] Sprint naming — `PitCrew Sprint N`
  - [x] Board name — `PitCrew` (ID 4323)
  - [x] Terminal status — `Closed`
  - [x] JIRA tooling — `jira` CLI only (not Atlassian MCP)
- [~] List related JIRA projects — none linked in spot check; fill table in PHASE0.md as needed
- [x] CI pipeline monitoring — **out of scope** for now (no Jenkins URL)

---

## Phase 1: Docs & repo branding

- [x] Initial README (skills-only quick start)
- [x] Initial INSTALL.md (jira CLI setup)
- [x] CLAUDE.md — board/components; two upstream repos; Security = embargoed CVEs only
- [x] LICENSE
- [ ] `.env.example` — `JIRA_*`, `GH_TOKEN`, optional CI tokens
- [ ] Verify `.gitignore` covers `.env` and local secrets
- [ ] Expand README when container/CLI layers are added
- [ ] Expand INSTALL.md with podman run, volumes, shell alias (if using container)

**Rename map** (when porting from coreos-agent-tools):

| coreos | pitcrew |
|--------|---------|
| `coreos-agent-tools` | `pitcrew-agent-tools` |
| `coreos-agent` | `pitcrew-agent` |
| `coreos-tools` | `pitcrew-tools` |
| `coreos-agent-config` (volume) | `pitcrew-agent-config` |
| JIRA project `COS` | `PITCREW` |

---

## Phase 2: Skills

### Done or mostly done

- [x] `bug-triage` — PITCREW JQL and labels
- [x] `feature-triage` — duplicate detection for Features
- [x] `jira-estimation` — story point guidance
- [x] `sprint-planning` — sprint review/planning
- [x] `go/skills/README.md` — skills index

### Needs rewrite (still has CoreOS content)

- [ ] `pipeline-jira` — replace COS/RHCOS pipeline monitoring conventions with PITCREW (or delete if out of scope)
- [ ] `bug-investigation` — replace RHCOS/OCP/`oc adm release` content with Automotive upstream investigation

### Planned (upstream ↔ JIRA)

- [x] `triage-upstream` (new) — Unreviewed GitHub issues (`no:label jira`) → match PITCREW → label JIRA `upstream` + GitHub `jira`

### Port and adapt from coreos-agent-tools

- [x] `pitcrew-repositories` (new) — upstream repo map, key files, JIRA component routing (modeled on `rhcos-repositories`)
- [ ] `pitcrew-activity` (new) — GitHub/GitLab activity summaries for relevant orgs (modeled on `coreos-activity`)
- [ ] `pipeline-triage-workflow` — generic triage stages; update job/CI terminology
- [ ] `pipeline-failures` — failure patterns for *your* CI (not kola/build-arch)
- [ ] `pipeline-dedup` — Jira dedup against PITCREW parent tasks

### Optional new skills

- [ ] `customer-escalations` — customer issue tracking workflow
- [ ] `release-tracking` — release coordination across teams
- [ ] `cross-project-links` — JQL for related issues outside PITCREW
- [ ] `automotive-domain` — terminology, architecture, common failure modes

### Explicitly skip (CoreOS-only unless requirements change)

- [-] `rhcos-build-pipeline`, `rhcos-versions`, `rhcos-brew`, `rhcos-artifacts`, `rhcos-ocp-release`
- [-] `fcos-overrides`, `initramfs-investigation`

---

## Phase 3: OpenCode agents & commands

Only if adopting the container agent workflow from coreos-agent-tools.

- [ ] `go/agents/pipeline-monitor.md` — discovery agent; your Jenkins jobs and dedup rules
- [ ] `go/agents/pipeline-investigator.md` — deep triage; your CI job hierarchy
- [ ] `go/agents/pipeline-handoff.md` — Jira drafts and team routing
- [ ] `go/pipeline-triage.md` — slash command for single-build triage
- [ ] `go/pipeline-status.md` — adapt or skip
- [ ] `go/ci-check.md` — automated pipeline health check workflow
- [ ] `go/analyze-failures.md` — adapt or skip
- [ ] `go/AGENTS.container.md` — container tool list and usage rules
- [ ] `go/opencode.json` — model and permission config

**Decisions needed before starting:**

- [ ] Jenkins URL and job names to monitor
- [ ] Weekly parent task pattern in PITCREW (or alternative tracking)
- [ ] Escalation targets (which teams get routed failures)

---

## Phase 4: Go CLI (`pitcrew-tools`)

- [ ] Port `go/cmd/coreos-tools/` → `go/cmd/pitcrew-tools/`
- [ ] Rename binary and update `root.go` descriptions
- [ ] Update `go/go.mod` module path
- [ ] `pkg/config/config.go` — config dir `~/.config/pitcrew-tools/`
- [ ] `pkg/jira/` — keep generic Jira client
- [ ] `jenkins*.go` — keep if monitoring CI; configure default profile URL
- [ ] Skip `cve.go`, `image.go`, `pkg/ocp/releases.go` unless needed
- [ ] `justfile` — build/push targets
- [ ] Document Jenkins profile setup in INSTALL.md

---

## Phase 5: Container image

- [ ] Port `go/Dockerfile.agent` → pitcrew image
- [ ] Image registry path and labels
- [ ] Build `pitcrew-tools` binary into image
- [ ] Entrypoint config sync (skills, agents, commands)
- [ ] Volume docs: `pitcrew-agent-config`, `pitcrew-agent-data`
- [ ] Tool audit — include only what PITCREW needs:
  - [ ] `jira`, `gh`, `glab` — likely yes
  - [ ] `oc` / `kubectl` — likely no
  - [ ] `brew` / koji — only if investigating RPM builds
  - [ ] `bodhi` — only if Fedora updates in scope
  - [ ] `podman-remote` — only if agent runs containers
- [ ] CI/CD to publish image (e.g. ghcr.io)
- [ ] Shell alias example in INSTALL.md

---

## Phase 6: Legacy Python scripts

Port only if needed; coreos versions are RHCOS-specific.

- [ ] `jenkins.py` — skip if using Go CLI
- [-] `process_rhcos_cves.py`
- [-] `get_rhcos_image.py`
- [-] `coreos_pipeline_messages.py` — unless PITCREW has a Slack pipeline channel
- [-] `coreos_pipeline_status.md`

---

## Phase 7: Secrets & environment

- [x] Document `JIRA_API_TOKEN` (basic auth; do not use `JIRA_AUTH_TYPE=bearer` on redhat.atlassian.net)
- [ ] Document `JIRA_EMAIL` (required for Go Jira client)
- [ ] Document `GH_TOKEN` for upstream repo investigation
- [ ] Document Jenkins creds if CI layer is added
- [ ] Document Vertex/GCP vars if using OpenCode container
- [ ] Add `.env.example` to repo
- [ ] Document `~/.config/jira/auth.sh` pattern (already in INSTALL.md)

---

## Phase 8: Verification

Run after each major milestone.

### JIRA CLI

```bash
jira issue list --project PITCREW
jira issue view PITCREW-XXXX
```

- [ ] Default project and board work after `jira init`
- [ ] Skill JQL queries return expected results

### Skills (Claude Code)

- [ ] "List untriaged bugs in PITCREW"
- [ ] "Using feature-triage, check PITCREW-XXXX for duplicates"
- [ ] No COS/RHCOS/kola terminology in skill outputs

### Go CLI (when ported)

```bash
pitcrew-tools jenkins jobs list
pitcrew-tools jenkins builds list <job> --last 5
```

- [ ] Jenkins profile configured and working

### Container (when ported)

```bash
podman run -it --rm \
  -v pitcrew-agent-config:/home/agent/.config \
  -e JIRA_API_TOKEN="$JIRA_API_TOKEN" \
  -e JIRA_AUTH_TYPE=bearer \
  -e GH_TOKEN="$GH_TOKEN" \
  ghcr.io/<org>/pitcrew-agent:latest
```

- [ ] Config sync copies latest skills on startup
- [ ] OpenCode starts and loads agents/skills

---

## Suggested order of work

1. ~~Phase 0~~ — done
2. Create `pitcrew-repositories`
3. ~~Create `triage-upstream`~~ — done (`upstream` / `jira` labels)
4. Rewrite `bug-investigation` and `pipeline-jira` (or drop pipeline-jira if out of scope)
5. Align triage JQL in existing skills (`Closed` terminal status)
6. CI pipeline layer (Phase 3) — only if in scope
7. Go CLI + container (Phases 4–5) — only if OpenCode agent is wanted

---

## Notes

<!-- Add decisions, blockers, and links here -->

| Date | Note |
|------|------|
| 2026-05-29 | Roadmap created from coreos-agent-tools customization checklist |
| 2026-05-29 | Phase 0: upstream repos confirmed (jumpstarter, automotive-dev-operator) |
| 2026-05-29 | Planned `triage-upstream` skill — map unreviewed GitHub issues to PITCREW tickets + label |
