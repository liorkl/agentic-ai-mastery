# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added — the two missions are now explicit

- `/coach:assess` and `/coach:apply` take a **`me` | `repo` scope**. `me` is the
  developer's own `~/.claude/` setup, which travels with them; `repo` is what gets
  committed, so a teammate who has tuned nothing still gets good results. The two are
  reported separately and never averaged — they fail independently, and averaging hides
  which one to fix.
- **`/coach:apply me` closes the plugin's biggest capability gap.** The coach already
  scanned `~/.claude/settings.json`, `~/.claude/skills/`, `~/.claude/agents/`, MCP
  configuration and keybindings — and nothing ever acted on any of it. Mission 1 was
  measured and then only lectured about. There is now a catalogue of real personal-setup
  fixes: permission allow rules, a global `CLAUDE.md`, a personal skill, a read-only
  subagent on `model: haiku`, model/effort defaults, a statusline, and MCP trimming.
- `knowledge/repo-ready/claude-md.md` — extracted the repo-level `CLAUDE.md` guidance that
  was buried inside a personal context-hygiene file. Covers what belongs in the file and
  what does not, the ~200-line target, path-scoped rules with the `paths` field, imports,
  and the `AGENTS.md` import pattern.
- `knowledge/knowledge-map.md` — one routing table, organized by mission, replacing the
  copy that was duplicated verbatim in `SKILL.md` and the lesson command. Carries the
  routing rules, including "match the mission to the complaint": "Claude keeps forgetting
  our conventions" is a repo problem, "Claude keeps asking permission" is a personal-setup
  problem, and answering in the wrong mission gives advice the developer cannot act on.

### Changed

- Reorganized `knowledge/` by mission: `personal-env/` (9 files), `repo-ready/` (5),
  `shared/` (the cross-cutting practices, outranking both), plus `pricing/` and
  `ecosystem/` as conditional. Replaces the single flat `features/` directory, which mixed
  "fix your machine" and "fix your repo" advice with no way to tell them apart.
- README leads with the two missions, and the L0–L10 ladder is now tagged per rung with
  the mission it serves.
- README's privacy section now states how its guarantees are actually enforced. The old
  claim rested on model instructions plus a `trust` block in `marketplace.json` that
  Claude Code ignores at load time. It now says so plainly and shows the `permissions.deny`
  rules that provide real enforcement.

### Fixed

- **The agent contradicted the command it backs.** `agents/coach.md` rule 9 said "**NEVER**
  modify user's existing configuration files / project files", while `/coach:apply` wrote
  `CLAUDE.md` and `.claude/settings.json` on apply. One of them had to be wrong. Resolved
  in favour of a clear boundary: the agent is read-only because an assessment that changes
  what it measures is not an assessment, and all writes belong to `/coach:apply` — one
  approved step at a time, diff shown first.
- **Overwrite hazard.** `/coach:apply` now merges into existing config rather than writing
  it from scratch. A `~/.claude/settings.json` written wholesale silently discards the
  user's permissions, hooks, and statusline.
- Dropped the "`commands/` instead of `skills/`" anti-pattern and the "legacy indicator"
  label on `.claude/commands/`. Custom commands were **merged into** skills — both create
  `/name` and both are current — so the plugin was penalising a non-problem while shipping
  commands itself.
- Restored the `# Changelog` header and Keep-a-Changelog preamble, dropped by an earlier
  edit in this branch.

### Removed

- `docs/requirements.md`, `docs/curriculum-v1.1.md`, `docs/diagnostic-v1.1.md` (~2,300
  lines), replaced by a 79-line `docs/DESIGN.md`. These were a parallel prose copy of the
  engine that had to be hand-synced, and the sync had already failed:
  `requirements.md` carried two stacked re-order banners that **contradicted each other**
  (one asserted skills were Level 3, the next asserted skills moved from Level 3 to Level
  4), and `diagnostic-v1.1.md` carried the line "Verify against the engine before relying
  on any level number here." A document that tells you not to trust it has already failed.
  `DESIGN.md` records the two missions and the design principles, and points at the
  runtime for everything else.

### Removed — leaner surface (12 entry points -> 5)

- Consolidated 11 slash commands into **four**, each with one job: `/coach:assess`
  (measure) -> `/coach:apply` (change) -> `/coach:learn` (teach) -> `/coach:progress`
  (report). Every merge shared state and logic, not just theme:
  - `/coach:next` + `/coach:exercise` -> **`/coach:learn`**. Both read the same
    assessments, applied the same leverage ladder, routed to the same knowledge table,
    and logged the same outcome; only the output shape differed. Now one command with a
    lesson mode and an `exercise` mode.
  - `/coach:status` + `/coach:recap` + `/coach:compare` -> **`/coach:progress`**. Three
    commands over the same two state files, differing only by time window. Now one
    command: no argument for a snapshot, `week`/`month`/`all` for a recap,
    `previous`/`first`/`since <date>` for a diff.
  - `/coach:execute` -> **`/coach:apply`**, named for what it does.
- Removed `/coach:cost`. 886 lines across a command, a knowledge file, and a design doc
  served a topic every other surface tells the plugin not to raise. The pricing *facts*
  stay in `knowledge/pricing/pricing-current.md` and load only on an explicit cost
  question; `docs/cost-guide-v1.0.md` is deleted.
- Removed `/coach:help`. Native `/help` lists plugin commands, and with four commands
  there is nothing left to disambiguate. A hand-written index — including its
  `next`-vs-`execute` decision matrix — was itself the signal that the split was wrong.
- Removed `/coach:discover` and `/coach:whats-new`, and the discovery protocol in
  `agents/coach.md` that backed them. They were one feature split across two commands,
  and the premise did not hold: a plugin shipping a staleness-prevention command was
  itself 74 days and three model generations stale. Knowledge freshness moves to the
  release pipeline instead of charging every user to re-discover it.
- Removed `skills/coaching/evals/coaching-evals.md`. Three of its five cases asserted the
  **opposite** of shipped behaviour — they failed a response for having "no cost or token
  mention" while `SKILL.md` Rule 3 forbids volunteering cost — and nothing executed it.
- Removed four dead design docs: `parallel-impl-phase-2.md` and
  `claude-code-kickoff-instructions.md` (self-declared SUPERSEDED/HISTORICAL),
  `project-CLAUDE.md` (a non-authoritative duplicate of the root `CLAUDE.md`), and
  `self-learning-discovery-v1.0.md` (the design for the removed discovery protocol).
  These shipped to every installer.

### Changed

- Narrowed the `coaching` skill description. It triggered on "learning, best practices,
  configuration, or features" — broad enough to fire on any config question. It now names
  Claude Code subjects explicitly and adds a `when_to_use` field with an exclusion for
  general programming questions.
- Every surviving command declares `disable-model-invocation: true` (these have side
  effects and controlled timing), plus `allowed-tools` for its state reads and
  `argument-hint` where it takes arguments. Previously no command declared any of them,
  so a plugin about permission hygiene caused its own prompt storm.

### Fixed

- **Silent data loss in state logging.** Every command specified "append to
  `outcomes.jsonl`" while using the Write tool, which *truncates*. Doing the obvious
  thing destroyed the coaching history. Now spelled out: read, append, write the whole
  file back.

### Added

- **`/coach:progress week`** — progress recap from assessment + outcome history. Leads with how the repo got more Claude-ready (verification readiness, CLAUDE.md score, resolved anti-patterns) and what was practiced — makes the "team gradually gets better" loop visible. Read-only.
- **`/coach:progress previous`** — before/after diff of two assessments for the current project, classifying each change as a gain or regression, led by verification readiness rather than the level number. Read-only.
- **`knowledge/repo-ready/plugins.md`** — closes a content gap: plugin anatomy, validation, marketplace/install flow, when to build a plugin, and the permissions model (including the `plugin.json` permissions install-breaker caveat). Wired into the `/coach:learn` and skill knowledge tables.
- `/help` now explains the passive coaching skill (auto-trigger, not a command) to remove a common point of confusion.

### Changed — re-centered on outcomes (get the best out of Claude)

- Reframed the coaching spine from "which features do you have (L0–L10)" to "are you getting the best out of Claude, and is your repo built for it?" The L0–L10 ladder is now explicitly a feature scaffold, not a score
- Made the high-leverage **cross-cutting practices the spine**, coached and assessed at every level, **verification first**: give Claude a check it can run, explore→plan→code, ground the prompt, course-correct early, manage context
- `/coach:assess` now leads with a "getting the best out of Claude here?" verdict (verification readiness) above the level number; anti-patterns are led by "no test/build/lint command Claude can run" (now critical) and "no verification gate"; assessment state records `verification_ready` / `verification_gate` / `practice_gaps`
- `/coach:learn` orders lessons by leverage, not level — a missing practice (especially verification) outranks the next feature
- `/coach:apply` now builds its step plan from `practice_gaps` + `verification_ready`/`verification_gate`, not just feature gaps and anti-patterns — so the cross-cutting practices get coached hands-on. Verification leads the plan (CRITICAL); behavioral habits (plan-mode, grounding, course-correction, context hygiene) are handled as `got it`/`skip` practice steps with no file to apply, while config-backed practices (a test command, a Stop-hook gate, a CLAUDE.md trim) keep the apply + file-verify flow
- CLAUDE.md scoring keeps verification commands weighted highest and now rewards pointing at an example pattern to follow; rewrote `productivity-tips.md` into a verification-first practices guide
- README now explains what "mastery" means here (the five practices) so teams don't mistake the level number for skill

### Fixed

- README install instructions pointed at a non-existent owner (`liorklibansky`) — corrected the marketplace-add and clone commands to `liorkl`, so installation actually works
- Version badge in README (`1.0.0`) now matches `plugin.json` (`1.0.1`)
- Malformed `never_reads` array in `marketplace.json` (one comma-joined string → a proper list)
- `/coach:apply` was missing from the README command table (it was already in `/help`, the curriculum, and the assess/status CTAs) — added the row so the documented command set is complete
- `agents/coach.md` tool frontmatter used scoped `Bash(...)` entries that don't grant the tool at the agent level — replaced with plain tool names (permission scoping stays in `.claude/settings.json`)

### Changed

- **Cost/token coaching is now off by default.** It is no longer woven into every lesson, assessment, or auto-triggered response — it lives only in the opt-in `/coach:cost` command. Removed the per-command "Estimated tokens" footers (kept on `/coach:cost`) and reframed every knowledge-file "Cost Implications" section to "Why It Matters" (capability/correctness first)
- Refreshed all model/pricing facts to June 2026: Fable 5, Opus 4.8 ($5/$25), Sonnet 4.6, Haiku 4.5. Removed the obsolete "Opus is 5x, default to Sonnet to save 60-80%" framing
- Replaced dead `budget_tokens` / "extended thinking" guidance with adaptive thinking + the `effort` parameter; removed `opusplan` in favor of the explore→plan→code workflow
- Corrected the `@import` CLAUDE.md syntax to the actual `@path/to/file` form, and aligned CLAUDE.md guidance with current best practice (keep it short; push domain knowledge to skills)
- Updated knowledge-file metadata headers to the current format and date

### Added — curriculum content refresh (Phase 1, mid-2026)

- After a live review against Anthropic's current docs/best-practices/Academy and popular community resources, refreshed the knowledge base to mid-2026 reality **without renumbering the L0–L10 ladder** (a structural re-order is a planned Phase 2):
  - **`knowledge/personal-env/permissions.md`** (new) — permission modes (default/acceptEdits/plan/auto/dontAsk/bypassPermissions), plan mode, the `auto` safety classifier, sandboxing, protected paths, and security/trust basics. Wired into the `/coach:learn` and skill knowledge tables at L0
  - **Checkpoints & rewind** added to `context.md` (safe exploration + course-correction); context reframed as the fundamental constraint (context rot / attention budget)
  - **MCP context cost & progressive disclosure** added to `mcp.md` (the code-execution-with-MCP ~150k→~2k token result; connect only needed servers) plus an MCP vetting/trust note
  - **`headless.md`**: corrected "Claude Code SDK" → **Claude Agent SDK**, fixed the `--output-format` values (`text`/`json`/`stream-json`), added scheduled runs and the fan-out pattern
  - **`teams.md`** → "Parallelism & Agent Teams": added git worktrees / dual-instance as the simpler first rung and a "start simple — don't reach for a team until simpler approaches fail" gate; teams reframed as the last resort
  - **`hooks.md`**: a Stop hook framed as the verification gate (the #1 practice made deterministic) + guardrail (security) hooks
  - **`productivity-tips.md`**: plan mode introduced early, "let Claude interview you into a spec" grounding technique, course-correction mechanics; **`output-styles.md`** updated to the current four styles (Default/Proactive/Explanatory/Learning); **`commands-ref.md`**: added `/rewind`, `/permissions`, `/mcp`, plan-mode entry

### Changed — curriculum re-ordered for impact (Phase 2, mid-2026)

- Re-ordered the L0–L10 ladder so structure follows **leverage, not feature-dependency** (the framing Anthropic foregrounds: everything serves context, verification closes the loop). Applied consistently across the runtime (level detection in `agents/coach.md`, the `/coach:learn` level→file map, `/coach:learn exercise` groups, `/coach:cost` sections, `/coach:apply` bridge hints, `/coach:progress` examples), the knowledge-file `curriculum_level` metadata, the README level table, and the design docs (`curriculum`, `diagnostic`, `requirements`, `self-learning-discovery`, `cost-guide`):
  - **Merged** old L2 (Project Configuration) + old L3 (Context Engineering) into **L2 — Project Memory & Context** (context is pervasive, not a standalone rung)
  - Old L4–L8 each shift down one: **L3 Skills · L4 Subagents · L5 Hooks · L6 MCP · L7 Headless/SDK/CI**
  - **New L8 — Parallel Work** (git worktrees / dual-instance) inserted before **L9 Agent Teams**, which is now gated by a "start simple — earn the team" criterion (Building Effective Agents); **L10 — Distribution & Mastery**
  - **L0 — Foundations & Setup** absorbs permission modes + checkpoints; **L1 — Prompting & the Core Loop**
  - Level detection gained a `worktrees`=L8 signal; skills/agents/hooks/MCP/headless detection renumbered to match the engine
  - **MCP moved to L3** (right after Project Memory & Context), reframed as *external context & reach* — it gathers context from git/Slack/Jira/docs/logs/AWS and acts on them (Playwright, Chrome DevTools). Skills→L4, Subagents→L5, Hooks→L6. Rationale: MCP is fundamentally a context mechanism, so it belongs adjacent to the context level (also matches Anthropic's extension-priority ordering, which puts MCP before skills and hooks); placing it right after L2 means it's learned cost-aware (progressive disclosure + vetting)

### Docs

- Synced the `docs/` design/dev-reference set to the shipped runtime so contributors aren't misled by stale specs (these files are not loaded at runtime). Each doc now carries a `Sync status (2026-06-19)` note. Reconciled: `curriculum-v1.1.md` (levels reframed as a feature scaffold, five-practices spine, verification first), `cost-guide-v1.0.md` (reframed as the opt-in `/coach:cost` reference data — cost off by default), `diagnostic-v1.1.md` (output leads with the readiness verdict; schema gains `verification_ready` / `verification_gate` / `practice_gaps`; anti-patterns led by missing verification), `requirements.md` (cost-at-every-level + token-footer mandates reverted; `/coach:progress week`, `/coach:progress previous`, `plugins.md` added; `plugin.json` permissions/agent-`tools:` gotchas), and `self-learning-discovery-v1.0.md` (current models/effort facts, cost demoted in discovery classification)
- Marked `docs/parallel-impl-phase-2.md` **superseded** (token footers and the `plugin.json` permissions block it proposed were reverted) and flagged `docs/claude-code-kickoff-instructions.md` as a **historical** build log
- Refreshed all `docs/` model/pricing/effort/syntax facts to June 2026 (`budget_tokens` → adaptive thinking + `effort`; `opusplan` → explore→plan→code; `@import` → `@path`); aligned the knowledge-file structure note in `CLAUDE.md` (`Cost Implications` → `Why It Matters`)

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
