# PITCREW Agent Tools

Claude Code skills and tools for PITCREW - Automotive Engineering team.

## Overview

This repository contains Claude Code skills to help with product owner workflows for the PITCREW team in Automotive Engineering.

## Skills

Skills are located in `go/skills/` and provide specialized knowledge for:

- **JIRA Triage** - Bug and RFE triage workflows
- **JIRA Estimation** - Effort estimation and planning
- **Feature Management** - RFE and feature request handling

See individual skill SKILL.md files for detailed usage.

## Claude Code Integration

### Using Skills

Skills in this repository can be used with Claude Code by:

1. Referencing them in conversation when working on related tasks
2. Copying to `~/.claude/skills/` for global access
3. Using project-level `.claude/` configuration

### Project Context

This repository includes CLAUDE.md files that provide Claude Code with context about:
- PITCREW team workflows
- JIRA project structure
- Automotive domain knowledge

## Getting Started

1. Clone this repository
2. Open with Claude Code
3. Skills will be automatically available when working in this directory

## Contributing

When adding new skills:
- Create a new directory under `go/skills/`
- Include a `SKILL.md` file with frontmatter
- Document JIRA queries, workflows, and decision criteria
- Update this README

## License

See LICENSE file for details.
