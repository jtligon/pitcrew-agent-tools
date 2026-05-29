# PITCREW Skills

Claude Code skills for product owner workflows in the PITCREW project.

## What are Skills?

Skills are markdown files that provide Claude Code with domain-specific knowledge, workflows, and patterns. When Claude Code has access to a skill, it can use that knowledge to help with specific tasks.

## Available Skills

### Bug Management

#### bug-triage
Systematic bug triage workflow including:
- JQL queries for finding untriaged bugs
- Label workflow (`triaged`, `in-progress`, `blocked`, `needs-info`)
- Severity classification guidelines
- Triage checklist

**Use when:** You need to categorize and prioritize new bugs

#### bug-investigation
Upstream investigation for PITCREW bugs (Jumpstarter, automotive-dev-operator):
- `gh` for issues, PRs, Actions logs, code search
- JIRA comment templates; links to `pitcrew-repositories` paths

**Use when:** Investigating the cause of a bug or failure

### Feature Management

#### feature-triage
RFE duplicate detection and review recommendations:
- Finding closed RFEs that duplicate new requests
- Keyword search strategies
- Team review decision criteria

**Use when:** Triaging new feature requests

### Planning & Estimation

#### jira-estimation
Story point estimation guidelines:
- Point scale (1-8+)
- Finding comparable stories
- Splitting large stories
- Estimation factors

**Use when:** Estimating work effort for stories

#### sprint-planning
Sprint review and planning workflows:
- Sprint statistics and velocity analysis
- Carryover management
- Sprint composition templates
- Risk assessment

**Use when:** Planning or reviewing sprints

### Upstream / repositories

#### pitcrew-repositories
Upstream GitHub repo map for PITCREW components (Jumpstarter, Automotive-dev-operator):
- JIRA component → repo routing
- Key paths and investigation entry points
- `gh` and `jira` CLI examples

**Use when:** Routing a PITCREW ticket to the right codebase, starting upstream investigation, or answering "which repo is this?"

#### triage-upstream
Link unreviewed GitHub issues to existing PITCREW tickets:
- Unreviewed = open issue without GitHub label `jira`
- On match: JIRA label `upstream`, GitHub label `jira`

**Use when:** Triaging new upstream GitHub issues against the PITCREW backlog

### JIRA Patterns

#### pipeline-jira
PITCREW JIRA linking: `upstream` label, GitHub URLs, comments, related issues (not COS pipeline monitoring)

**Use when:** Linking PITCREW tickets to upstream GitHub or documenting cross-issue relationships

## How to Use Skills

### In Conversation

Skills are automatically available when Claude Code runs in this directory. Reference them naturally:

```
"Using bug-triage, categorize PITCREW-1234"
"Check if PITCREW-5678 is a duplicate using feature-triage"
"Estimate PITCREW-9012"
"Help me plan Sprint 42 using sprint-planning"
```

### Skill File Format

Each skill is a directory containing `SKILL.md`:

```
go/skills/
├── bug-triage/
│   └── SKILL.md
├── feature-triage/
│   └── SKILL.md
└── ...
```

The SKILL.md file has frontmatter and markdown content:

```markdown
---
name: skill-name
description: What this skill provides
---

# Skill Content

Knowledge and patterns...
```

## Customizing Skills

Skills can be edited to match your team's specific workflows.

### Common Customizations

1. **Update JQL Queries**
   - Match your JIRA project structure
   - Update issue type names
   - Adjust field names

2. **Add Team-Specific Labels**
   - Add your label taxonomy
   - Document label meanings and usage

3. **Customize Workflows**
   - Update triage checklists
   - Add team conventions
   - Include links to team docs

4. **Add Domain Knowledge**
   - Automotive-specific terminology
   - Product architecture
   - Common patterns in your codebase

### Example: Updating Issue Types

If your JIRA project uses `Enhancement` instead of `RFE`, edit `feature-triage/SKILL.md`:

```diff
- project = PITCREW AND issuetype = RFE
+ project = PITCREW AND issuetype = Enhancement
```

## Creating New Skills

To add a new skill:

1. Create a directory: `go/skills/my-new-skill/`
2. Add `SKILL.md` with frontmatter:

```markdown
---
name: my-new-skill
description: Brief description
---

# My New Skill

Content here...
```

3. Commit and push to share with the team

### Skill Ideas

- **release-planning** - Release tracking and coordination
- **customer-escalations** - Handling customer issues
- **technical-debt** - Tracking and prioritizing tech debt
- **oncall-handoff** - Oncall handoff procedures
- **metrics-reporting** - Team metrics and reporting

## Tips

- **Be specific** - The more specific the skill, the more helpful it is
- **Include examples** - Show JQL queries, commands, and templates
- **Keep updated** - Update skills as workflows evolve
- **Link related skills** - Reference related skills in content
- **Use tables** - Tables make reference information scannable

## Questions?

See the main [INSTALL.md](../../INSTALL.md) for setup instructions.
