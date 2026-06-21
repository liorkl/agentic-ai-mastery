# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- **`/coach:recap`** — progress recap from assessment + outcome history. Leads with how the repo got more Claude-ready (verification readiness, CLAUDE.md score, resolved anti-patterns) and what was practiced — makes the "team gradually gets better" loop visible. Read-only.
- **`/coach:compare`** — before/after diff of two assessments for the current project, classifying each change as a gain or regression, led by verification readiness rather than the level number. Read-only.
- **`knowledge/features/plugins.md`** — closes a content gap: plugin anatomy, validation, marketplace/install flow, when to build a plugin, and the permissions model (including the `plugin.json` permissions install-breaker caveat). Wired into the `/coach:next` and skill knowledge tables.
- `/coach:help` now explains the passive coaching skill (auto-trigger, not a command) to remove a common point of confusion.

### Changed — re-centered on outcomes (get the best out of Claude)

- Reframed the coaching spine from "which features do you have (L0–L10)" to "are you getting the best out of Claude, and is your repo built for it?" The L0–L10 ladder is now explicitly a feature scaffold, not a score
- Made the high-leverage **cross-cutting practices the spine**, coached and assessed at every level, **verification first**: give Claude a check it can run, explore→plan→code, ground the prompt, course-correct early, manage context
- `/coach:assess` now leads with a "getting the best out of Claude here?" verdict (verification readiness) above the level number; anti-patterns are led by "no test/build/lint command Claude can run" (now critical) and "no verification gate"; assessment state records `verification_ready` / `verification_gate` / `practice_gaps`
- `/coach:next` orders lessons by leverage, not level — a missing practice (especially verification) outranks the next feature
- `/coach:execute` now builds its step plan from `practice_gaps` + `verification_ready`/`verification_gate`, not just feature gaps and anti-patterns — so the cross-cutting practices get coached hands-on. Verification leads the plan (CRITICAL); behavioral habits (plan-mode, grounding, course-correction, context hygiene) are handled as `got it`/`skip` practice steps with no file to apply, while config-backed practices (a test command, a Stop-hook gate, a CLAUDE.md trim) keep the apply + file-verify flow
- CLAUDE.md scoring keeps verification commands weighted highest and now rewards pointing at an example pattern to follow; rewrote `productivity-tips.md` into a verification-first practices guide
- README now explains what "mastery" means here (the five practices) so teams don't mistake the level number for skill

### Fixed

- README install instructions pointed at a non-existent owner (`liorklibansky`) — corrected the marketplace-add and clone commands to `liorkl`, so installation actually works
- Version badge in README (`1.0.0`) now matches `plugin.json` (`1.0.1`)
- Malformed `never_reads` array in `marketplace.json` (one comma-joined string → a proper list)
- `/coach:execute` was missing from the README command table (it was already in `/coach:help`, the curriculum, and the assess/status CTAs) — added the row so the documented command set is complete
- `agents/coach.md` tool frontmatter used scoped `Bash(...)` entries that don't grant the tool at the agent level — replaced with plain tool names (permission scoping stays in `.claude/settings.json`)

### Changed

- **Cost/token coaching is now off by default.** It is no longer woven into every lesson, assessment, or auto-triggered response — it lives only in the opt-in `/coach:cost` command. Removed the per-command "Estimated tokens" footers (kept on `/coach:cost`) and reframed every knowledge-file "Cost Implications" section to "Why It Matters" (capability/correctness first)
- Refreshed all model/pricing facts to June 2026: Fable 5, Opus 4.8 ($5/$25), Sonnet 4.6, Haiku 4.5. Removed the obsolete "Opus is 5x, default to Sonnet to save 60-80%" framing
- Replaced dead `budget_tokens` / "extended thinking" guidance with adaptive thinking + the `effort` parameter; removed `opusplan` in favor of the explore→plan→code workflow
- Corrected the `@import` CLAUDE.md syntax to the actual `@path/to/file` form, and aligned CLAUDE.md guidance with current best practice (keep it short; push domain knowledge to skills)
- Updated knowledge-file metadata headers to the current format and date

### Docs

- Synced the `docs/` design/dev-reference set to the shipped runtime so contributors aren't misled by stale specs (these files are not loaded at runtime). Each doc now carries a `Sync status (2026-06-19)` note. Reconciled: `curriculum-v1.1.md` (levels reframed as a feature scaffold, five-practices spine, verification first), `cost-guide-v1.0.md` (reframed as the opt-in `/coach:cost` reference data — cost off by default), `diagnostic-v1.1.md` (output leads with the readiness verdict; schema gains `verification_ready` / `verification_gate` / `practice_gaps`; anti-patterns led by missing verification), `requirements.md` (cost-at-every-level + token-footer mandates reverted; `/coach:recap`, `/coach:compare`, `plugins.md` added; `plugin.json` permissions/agent-`tools:` gotchas), and `self-learning-discovery-v1.0.md` (current models/effort facts, cost demoted in discovery classification)
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
