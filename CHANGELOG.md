# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.0.0] - 2026-09-03

A major version: the plugin is reorganized around two explicit missions, the command
surface is cut from 12 entry points to 5, and the content is corrected and brought up to
the Claude 5 family. Everything since 1.0.1 (February) ships here.

**Breaking.** Seven commands were removed and three renamed:

| Old | New |
|-----|-----|
| `/coach:execute` | `/coach:apply` (now takes `me` \| `repo`) |
| `/coach:next` | `/coach:learn` |
| `/coach:exercise` | `/coach:learn exercise` |
| `/coach:status` | `/coach:progress` |
| `/coach:recap` | `/coach:progress week` |
| `/coach:compare` | `/coach:progress previous` |
| `/coach:help` | `/help` (native — it already lists plugin commands) |
| `/coach:cost` | Just ask about cost; it is off by default |
| `/coach:discover`, `/coach:whats-new` | Gone — knowledge freshness ships with releases |

Existing state in `~/.claude/coaching/state/` still loads; assessments and outcomes carry
over. New assessments also record a `scope` field, so run `/coach:assess` once after
upgrading to get a scoped baseline.

### Added

- **Two explicit missions.** `/coach:assess` and `/coach:apply` take a `me` | `repo`
  scope. `me` is the developer's own `~/.claude/` setup, which travels with them; `repo`
  is what gets committed, so a teammate who has tuned nothing still gets good results.
  Reported separately and never averaged — they fail independently, and one blended number
  hides which to fix.
- **`/coach:apply me`, closing the plugin's biggest capability gap.** The coach already
  scanned `~/.claude/settings.json`, `~/.claude/skills/`, `~/.claude/agents/`, MCP config
  and keybindings — and nothing ever acted on any of it. Mission 1 was measured and then
  only lectured about. There is now a catalogue of real fixes: permission allow rules, a
  global `CLAUDE.md`, a personal skill, a read-only subagent on `model: haiku`,
  model/effort defaults, a statusline, and MCP trimming.
- **`templates/` — working files, exercised by CI.** A `CLAUDE.md`, a `settings.json` with
  permission rules and both hooks wired correctly, a `Stop` verification gate, a
  `PreToolUse` secret guardrail, a read-only reviewer subagent, and a task skill with
  `disable-model-invocation: true`. `/coach:apply repo` starts from these instead of
  composing files from prose.
- **`scripts/test-templates.sh`** — runs the templates for real; called by both
  `.githooks/pre-push` and CI so the two cannot drift. Asserts the nested hook shape,
  hook exit-code semantics in both the blocking and allowing case, no false positives on
  ordinary code, that "nothing to verify" is a pass rather than a failure, and that
  skill/agent frontmatter declares its required fields.
- `knowledge/repo-ready/claude-md.md` — the repo-level `CLAUDE.md` guidance, extracted
  from where it was buried inside a personal context-hygiene file. Mission 2's most
  important artifact had no file of its own.
- `knowledge/knowledge-map.md` — one routing table, organized by mission, replacing a copy
  duplicated verbatim in two places. Carries the rule that matters most: match the mission
  to the complaint.
- `knowledge/repo-ready/plugins.md` — plugin anatomy, validation, install flow, and when
  building a plugin is worth it.
- `SECURITY.md` — the disclosure path `SUPPORT.md` linked to but never had.
- `.github/workflows/templates.yml` — runs the template suite plus `shellcheck`.

### Changed

- Coaching is centered on **outcomes, not feature collection**. The L0–L10 ladder is
  explicitly a feature scaffold, not a score, and each rung is tagged with the mission it
  serves. The cross-cutting practices are the spine, coached and assessed at every level,
  **verification first**: give Claude a check it can run, explore → plan → code, ground the
  prompt, course-correct early, manage context.
- `knowledge/` is organized by mission — `personal-env/` (9 files), `repo-ready/` (5),
  `shared/` (the practices, which outrank both) — replacing a flat `features/` directory
  that mixed "fix your machine" with "fix your repo" advice.
- Curriculum content refreshed to the **Claude 5 family**. Opus 5, Sonnet 5 and Fable 5.1
  were absent entirely; notably **Sonnet 5 is $2/$10, cheaper than the Sonnet 4.6 ($3/$15)
  the files recommended as the daily driver**, so the old cost guidance overstated the bill
  by roughly 50%. Adaptive thinking and `effort` replace the `budget_tokens` model
  throughout.
- Ladder re-ordered by leverage: L2 merges project memory and context; MCP is L3 (external
  context and reach); skills L4, subagents L5, hooks L6; L8 is parallel work (worktrees,
  dual-instance) ahead of agent teams at L9.
- Every command declares `disable-model-invocation: true`, `allowed-tools` for its state
  reads, and `argument-hint` where it takes arguments. None did before, so a plugin about
  permission hygiene caused its own prompt storm.
- The `coaching` skill's description was narrowed. It triggered on "learning, best
  practices, configuration, or features" — broad enough to fire on any config question —
  and now names Claude Code subjects with a `when_to_use` that excludes general
  programming questions.
- **Replaced the hand-maintained `plugin.json` key whitelist with `claude plugin validate
  --strict`.** The whitelist allowed 8 keys against a schema of roughly 23, so it would
  have rejected `displayName`, `skills`, `commands`, `agents`, `hooks`, `mcpServers` and
  more. Its premise had also expired: the `permissions` key it existed to block is now
  reported as an ignored unknown field, not an install failure.
- **Lifted the "no scripts, no templates" constraint.** It was the root cause of the
  accuracy bugs below — a rule forbidding testable artifacts guaranteed the guidance could
  only ever be prose. Runtime components still use Claude's native tools; `templates/` and
  `scripts/` are exempt because CI executes them.
- README leads with the two missions, and its privacy section now states how its
  guarantees are actually enforced rather than implying a sandbox that does not exist.
- CI runs on stacked PRs and on `refactor/**`, `chore/**` and `docs/**` branches; it
  previously skipped both.

### Fixed

- **The hooks lesson did not work as written** — and it was the most-repeated lesson in the
  plugin. The hook config used a flat `{matcher, command}` shape, which is valid JSON,
  looks right, and **silently never fires**; the real shape needs a nested
  `hooks: [{type, command}]` array. Exit codes were **inverted** (`1` documented as block,
  `2` as feedback) when exit 2 blocks and exit 1 lets the operation through — so the
  secret-guardrail example did not block. And every example read its input as `$1` when
  command hooks receive **JSON on stdin**, so they all read an empty string.
- **Ten slash commands that do not exist** were documented as built-ins: `/commit`, `/pr`,
  `/test`, `/team`, `/skills`, `/inline`, `/explain`, `/fix`, `/refactor`, `/agent`. Also
  `/undo` (it is `/rewind`) and `/mcp list`. Replaced with the real set, plus a
  "does not exist" table because these get re-invented constantly.
- Settings keys that are not real: `experimental.agentTeams` (agent teams are gated by
  `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS`) and `toolSearch` (`ENABLE_TOOL_SEARCH`).
- CLI flags that are not real: `--timeout-minutes`, and `--allowedTools "Read,Edit"` —
  the flag takes space-separated quoted rules.
- API errors: `client.batches` → `client.messages.batches`; an invented
  `from anthropic import Agent` API replaced with the real Tool Runner and the separate
  Claude Agent SDK; two-generation-stale `_20241022` tool types; an unsourced rate-limit
  table replaced with a pointer to live response headers.
- Three files still *recommended* the previous model generation as current after the
  refresh — eight code examples in `ecosystem/api.md`, a hardcoded price table with the
  old Sonnet 4.6 rates, and the model advice in `repo-ready/agents.md` and
  `personal-env/cli-orientation.md`. All now point at the Claude 5 family; Sonnet 4.6 and
  Opus 4.8 appear only where the comparison is the point.
- `.claude/rules/knowledge-limits.md` used `globs:`, which is not a field — so the rule
  never scoped to `knowledge/`. The field is `paths:`.
- **The agent contradicted the command it backs.** `agents/coach.md` said "NEVER modify
  user's existing configuration files / project files" while `/coach:apply` wrote
  `CLAUDE.md` and `.claude/settings.json`. Resolved toward a real boundary: the agent is
  read-only, because an assessment that changes what it measures is not an assessment, and
  every write belongs to `/coach:apply` — one approved step at a time, diff shown first.
- **Overwrite hazard.** `/coach:apply` merges into existing config rather than writing it
  from scratch. A `~/.claude/settings.json` written wholesale silently discarded the user's
  permissions, hooks, and statusline.
- **Silent data loss.** Every command said "append to `outcomes.jsonl`" while using the
  Write tool, which truncates — doing the obvious thing destroyed the coaching history.
- Hook templates quote `"$CLAUDE_PROJECT_DIR"`; unquoted, a hook breaks on any path
  containing a space.
- Install was broken: `SUPPORT.md`'s six GitHub links, `CODEOWNERS`, and the install
  instructions all pointed at a user that does not exist, so `CODEOWNERS` assigned no
  reviewer and every "open an issue" link was dead.
- `CONTRIBUTING.md` was a third, incompatible spec for knowledge files — a contributor
  following it produced a file that violated the repo's own rule file.
- Dropped the "`commands/` instead of `skills/`" anti-pattern: custom commands were
  **merged into** skills, so the plugin was penalising a non-problem while shipping
  commands itself.

- **This repo now has the verification gate its own rubric demands.** The plugin
  classifies "no verification gate" as a HIGH-severity anti-pattern and shipped without
  one for itself. `.claude/hooks/verify.sh` is built from the template the plugin hands to
  users — JSON validity, the repo's own line limits, and the template suite — wired as a
  `Stop` hook in the correct nested shape. It deliberately skips
  `claude plugin validate`, which would spawn a nested claude process; pre-push and CI own
  that check.
- `BACKLOG.md` reconciled with reality. Several open items shipped in this release, and
  one carried a note that had expired: it claimed a `permissions` key in `plugin.json`
  "causes install to fail", which is now reported as an ignored unknown field.

### Removed

- **12 user-facing entry points reduced to 5** — four commands (`assess` → `apply` →
  `learn` → `progress`) plus the `coaching` skill. `/coach:help` had shipped a six-row
  decision matrix explaining when to use `/coach:next` versus `/coach:execute`; a split
  that needs a matrix is the wrong split.
- `/coach:cost` — 886 lines across a command, knowledge file and design doc, serving a
  topic every other surface tells the plugin not to raise. The pricing facts remain and
  load only on an explicit cost question.
- `/coach:discover` and `/coach:whats-new`, and the discovery protocol behind them. The
  premise failed on its own terms: a plugin shipping a staleness-prevention command was
  itself 74 days and three model generations stale. Freshness now ships with releases.
- `skills/coaching/evals/coaching-evals.md` — three of its five cases asserted the
  **opposite** of shipped behaviour, and nothing executed it.
- Roughly **3,000 lines of design documents** (`requirements.md`, `curriculum-v1.1.md`,
  `diagnostic-v1.1.md`, `cost-guide-v1.0.md`, `self-learning-discovery-v1.0.md`,
  `parallel-impl-phase-2.md`, `claude-code-kickoff-instructions.md`, `project-CLAUDE.md`)
  replaced by a 79-line `docs/DESIGN.md`. They were a hand-synced prose copy of the engine
  and the sync had failed: `requirements.md` carried two stacked banners contradicting each
  other about whether skills are L3 or L4, and `diagnostic-v1.1.md` read "Verify against
  the engine before relying on any level number here." All of it shipped to every
  installer.

## [1.0.1] - 2026-02-26

### Added

- Explicit `permissions` block in `plugin.json` — declares all allowed tools and denies access to `.env`, credentials, and unrestricted write/bash
- Scan receipt at end of `/coach:assess` output — lists every file pattern scanned, grouped by scope, with explicit "Nothing else was read or written." statement
- Token usage estimate footer on all commands — hardcoded per-command input/output estimates to validate the ≤3,000 token target

### Changed

- `/coach:next` lesson output now leads with a copy-pasteable `### Do This Now` code block instead of prose `### Try This`; word count target reduced from 200–400 to 150–350 words

## [1.0.0] - 2026-02-22

### Added

- Plugin manifest (`.claude-plugin/plugin.json`) and marketplace manifest
- MIT License
- `/coach:assess` command — environment scanning with level detection, gap analysis, anti-pattern flagging
- `/coach:next` command — level-appropriate lessons based on gaps
- `/coach:status` command — current level and discovery staleness
- `/coach:exercise` command — hands-on exercises with success criteria
- `/coach:cost` command — cost optimization coaching per level
- `/coach:discover` command — discovery protocol for new features
- `/coach:whats-new` command — discovery digest view
- `/coach:help` command — command listing
- Coach sub-agent with deep environment scanner using native tools (Read, LS, Glob, Grep)
- Level detection algorithm (L0–L10)
- CLAUDE.md quality scoring (10-point rubric)
- Anti-pattern detection with severity levels
- Privacy-safe scanning (never reads `.env`, credentials, secrets)
- First-run state initialization
- Coaching skill with auto-trigger on learning questions
- Level awareness from latest assessment
- Behavior rules (never skip levels, ground in real work, cost awareness)
- Context hygiene (loads only relevant knowledge files)
- Outcome logging to `outcomes.jsonl`
- Knowledge base: 13 files covering L0–L9 curriculum (`knowledge/features/`, `knowledge/commands/`, `knowledge/pricing/`, `knowledge/ecosystem/`)
- JSONL-based progress tracking in `~/.claude/coaching/state/`
- Assessments, outcomes, and discoveries persisted across sessions
- Plugin validated with `claude plugin validate .` (2,106 lines total, all files under 500 lines)
- Works in both Claude Code and Cowork with no external dependencies

[Unreleased]: https://github.com/liorkl/agentic-ai-mastery/compare/v1.0.1...HEAD
[1.0.1]: https://github.com/liorkl/agentic-ai-mastery/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/liorkl/agentic-ai-mastery/releases/tag/v1.0.0
