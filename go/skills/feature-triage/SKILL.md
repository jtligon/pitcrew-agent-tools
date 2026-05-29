---
name: feature-triage
description: Triage Features in JIRA project PITCREW - closed duplicates and team-review recommendation
---

# Feature Triage

Knowledge for triaging **Features** (the issue type used for feature requests in PITCREW) in the **PITCREW** JIRA project. Surface likely duplicates against **already closed** Features, then decide if the request still needs a **human team review**.

## Querying Features for Triage

### JQL for open Features (project PITCREW)

```jql
project = PITCREW AND issuetype = Feature
  AND status != Closed
```

### JIRA CLI commands

**Note:** The `jira` CLI defaults to the PITCREW project, so explicit project specification is optional.

```bash
# List open Features
jira issue list -q 'project = PITCREW AND issuetype = Feature AND status != Closed' --plain --columns key,summary,status,priority,assignee,created

# Richer view for triage (resolution and fix versions help when comparing to closed work)
jira issue view <ISSUE-KEY>

# Search closed Feature history by keyword (repeat with distinctive phrases from the request)
# Note: Stories may also contain feature requests - cast a wider net if needed
jira issue list -q 'project = PITCREW AND issuetype IN (Feature, Story) AND status = Closed AND (summary ~ "keyword1" OR summary ~ "keyword2")' --plain --no-truncate

# If keyword search returns nothing, fall back to listing ALL closed Features and scanning manually
jira issue list -q 'project = PITCREW AND issuetype = Feature AND status = Closed' --plain --columns key,summary,status,priority --no-truncate
```

## Finding previously closed RFEs that duplicate the request

Goal: before spending team time, determine whether the capability was **already delivered**, **already declined**, or **already tracked** under another key.

### 1. Build search terms from the request

From the open RFE, extract:

- **Product nouns** (e.g. specific products, components, systems)
- **Verbs / outcomes** (e.g. install, configure, integrate, deploy)
- **Constraints** (version, platform, customer requirements)

Prefer **2–4 distinctive phrases** over a single generic word.

### 2. Query closed RFEs in the same scope

Always scope to **project PITCREW**. Restrict to **closed** terminal states and **issuetype = Feature** (though Stories may also contain feature requests—widen the type filter if needed):

```jql
project = PITCREW AND issuetype = Feature
  AND status = Closed
  AND (
    summary ~ "phrase-one" OR summary ~ "phrase-two" OR text ~ "distinctive phrase"
  )
```

Run several narrow queries rather than one huge `OR` blob. If the CLI supports it, use `text ~` / description searches for longer phrases.

### 3. Compare candidates, not just titles

For each candidate closed RFE, check:

| Signal | What it means |
|--------|----------------|
| **Resolution** (Done vs Won't Do vs Duplicate) | Done → capability may already exist; Won't Do → policy/product decision may already exist |
| **Fix version / target release** | Shows where it landed; compare to the requester's version |
| **Linked epics / children** | Implementation may span multiple keys; parent may be the better duplicate target |
| **Comments** | Often explain scope cuts or "superseded by X" |

If the closed RFE is clearly the **same intent and scope** as the new request, treat it as a **duplicate for triage purposes** even if wording differs.

### 4. Record links in JIRA

When you find a match:

- Link the new Feature to the closed Feature (e.g. **duplicates** / **is duplicated by** / **relates to**, per project convention).
- In a short comment, cite the closed key and **one sentence** on why it matches (scope + resolution).

**Permission note:** The Jira account used by this agent may not have comment or link permissions on the PITCREW project. If `jira issue comment add` returns a 400 error, report the triage findings to the user so they can post manually.

## Should a team member review this Feature?

After duplicate research, choose one of the outcomes below and state it explicitly in the triage note or comment.

### Likely **no dedicated review needed** (agent or reporter can proceed)

- **Strong duplicate** of a **Closed/Done** Feature that delivered the requested capability, and the new request does not add a new constraint or version gap that reopens scope.
- **Strong duplicate** of a closed **Duplicate** Feature where the canonical Feature is already identified and still valid.
- **Pure documentation / support** request that is answered by linking to the closed feature or release note (optional: single comment, no meeting).

### **Team review recommended**

- **Partial overlap** only: closed work delivered a subset; the new ask expands platform, version, UX, or support matrix.
- Closed as **Won't Do / Declined** (or similar): the new request may be asking for a **revisit**; only a teammate should confirm product stance.
- **Conflicting** closed Features (one delivered, one declined related scope): needs human reconciliation.
- **Strategic, contractual, or security-sensitive** language in the request (even if duplicates exist): default to review.
- **No credible closed match** after reasonable search: treat as **novel**; someone should slot/prioritize/estimate.

### **Team review urgent**

- Release train, customer commitment, or blocker language that does not match any closed delivery in the searched window.
- Duplicates an in-flight epic but **reopens scope** in a way that affects sprint commitments.

## Lightweight triage checklist

When triaging a new Feature:

1. **Read for intent** — outcome desired, user persona, environment (product versions, platforms, deployment constraints).
2. **Search closed duplicates** — follow the section above; document top 1–3 candidates with keys and resolutions.
3. **Decide review** — apply the table in the previous section; one clear sentence: "Team review: yes/no because …".
4. **Labels / fields** — follow team process for priority, epics, and labels; this skill’s scope is **project = PITCREW**.
5. **Handoff** — if review is needed, `@mention` or assign per team norms and paste the duplicate-search summary so the reviewer starts informed.

## Recognizing cross-team scope

Some Features touch areas beyond PITCREW’s direct scope (e.g., dependencies on other engineering teams, infrastructure, external systems). These are almost always **team review recommended** because:

- No single team owns the full scope
- There may be parallel in-flight work in other projects not visible in `project = PITCREW`
- Product decisions may already exist but not be recorded in PITCREW

Signals that a Feature crosses team boundaries:
- Mentions multiple products or teams as separate surfaces
- Involves infrastructure or platform changes beyond team control
- Has escalation labels or customer commitment tags

## What not to do here

- Do not apply **bug-only** triage patterns unless the issue is actually a defect; use `bug-triage` instead.
- Do not close as duplicate without **reading** the closed Feature’s resolution and scope.
- Do not assume `issuetype = Feature` catches all relevant issues — miscategorized Stories may be valid duplicates.
