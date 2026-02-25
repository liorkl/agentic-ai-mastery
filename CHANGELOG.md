# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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

[Unreleased]: https://github.com/liorklibansky/agentic-ai-mastery/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/liorklibansky/agentic-ai-mastery/releases/tag/v1.0.0
