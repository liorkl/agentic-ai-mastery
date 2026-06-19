# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed

- README install instructions pointed at a non-existent owner (`liorklibansky`) — corrected the marketplace-add and clone commands to `liorkl`, so installation actually works
- Version badge in README (`1.0.0`) now matches `plugin.json` (`1.0.1`)
- Malformed `never_reads` array in `marketplace.json` (one comma-joined string → a proper list)
- `agents/coach.md` tool frontmatter used scoped `Bash(...)` entries that don't grant the tool at the agent level — replaced with plain tool names (permission scoping stays in `.claude/settings.json`)

### Changed

- **Cost/token coaching is now off by default.** It is no longer woven into every lesson, assessment, or auto-triggered response — it lives only in the opt-in `/coach:cost` command. Removed the per-command "Estimated tokens" footers (kept on `/coach:cost`) and reframed every knowledge-file "Cost Implications" section to "Why It Matters" (capability/correctness first)
- Refreshed all model/pricing facts to June 2026: Fable 5, Opus 4.8 ($5/$25), Sonnet 4.6, Haiku 4.5. Removed the obsolete "Opus is 5x, default to Sonnet to save 60-80%" framing
- Replaced dead `budget_tokens` / "extended thinking" guidance with adaptive thinking + the `effort` parameter; removed `opusplan` in favor of the explore→plan→code workflow
- Corrected the `@import` CLAUDE.md syntax to the actual `@path/to/file` form, and aligned CLAUDE.md guidance with current best practice (keep it short; push domain knowledge to skills)
- Updated knowledge-file metadata headers to the current format and date

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
