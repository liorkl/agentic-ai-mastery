<!-- file: knowledge/knowledge-map.md -->
<!-- last-updated: 2026-09-03 -->
<!-- source: internal -->

# Knowledge Map

The single routing table for the knowledge base. `/coach:learn`, `/coach:apply`, and the
`coaching` skill all pick files from here — don't duplicate this table elsewhere.

Load **one** file per interaction. Loading three costs context and teaches nothing extra.

## Mission 1 — Your Personal Environment (`personal-env/`)

Things that travel with the developer, not the repo. Fixed once, they pay off in every
project.

| Level | Topic | File |
|-------|-------|------|
| 0 | CLI orientation, the agentic loop, first session | `personal-env/cli-orientation.md` |
| 0 | Permission modes, plan mode, sandboxing, protected paths | `personal-env/permissions.md` |
| 0-1 | Model selection and effort levels | `personal-env/models.md` |
| any | Which slash commands actually exist | `personal-env/commands-ref.md` |
| 1 | Output styles | `personal-env/output-styles.md` |
| 2 | Context hygiene: `/clear` vs `/compact`, checkpoints, rewind | `personal-env/context.md` |
| 3 | MCP — external context and reach | `personal-env/mcp.md` |
| 7 | Headless, SDK, and CI automation | `personal-env/headless.md` |
| 8-9 | Parallel work: worktrees, dual-instance, agent teams | `personal-env/teams.md` |

## Mission 2 — A Claude-Ready Repo (`repo-ready/`)

Things committed to the repository, so anyone on the team gets good results without
tuning their own setup.

| Level | Topic | File |
|-------|-------|------|
| 2 | `CLAUDE.md`, path-scoped rules, imports | `repo-ready/claude-md.md` |
| 4 | Project skills | `repo-ready/skills.md` |
| 5 | Project subagents | `repo-ready/agents.md` |
| 6 | Hooks — deterministic gates, verification | `repo-ready/hooks.md` |
| 10 | Packaging and sharing a Claude-ready setup as a plugin | `repo-ready/plugins.md` |

## Shared

| Topic | File |
|-------|------|
| The cross-cutting practices — verification first, plan-first, grounding prompts, course-correction, context hygiene | `shared/productivity-tips.md` |

`shared/productivity-tips.md` outranks every table above. It applies at every level and to
both missions, and it is the right answer more often than any feature file.

## Conditional

| Topic | File | When |
|-------|------|------|
| Pricing and cost levers | `pricing/pricing-current.md` | **Only** on an explicit cost question. Never in a normal lesson |
| Claude API primer | `ecosystem/api.md` | Only when the developer is building *on* the API, not using Claude Code |
| Cowork | `ecosystem/cowork.md` | Only when the developer asks about Cowork specifically |

## Routing Rules

1. **Practice before feature.** If `verification_ready` is false, the answer is
   `shared/productivity-tips.md` (or `repo-ready/hooks.md` to make the gate
   deterministic) — whatever the developer's level. A Level 7 repo with no test command
   Claude can run does not need an MCP lesson.
2. **Match the mission to the complaint.** "Claude keeps forgetting our conventions" is
   mission 2 (`repo-ready/claude-md.md`). "Claude keeps asking me for permission" is
   mission 1 (`personal-env/permissions.md`). Answering in the wrong mission produces
   advice the developer cannot act on.
3. **One file.** Pick the single best match.
4. **Never preload `pricing/`.** Cost coaching is off by default.
