# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-02-22

### Added

#### Plugin Structure
- Plugin manifest (`.claude-plugin/plugin.json`)
- Marketplace manifest for distribution
- MIT License

#### Commands
- `/coach:assess` — Environment scanning with level detection, gap analysis, anti-pattern flagging
- `/coach:next` — Level-appropriate lessons based on gaps
- `/coach:status` — Current level and discovery staleness
- `/coach:exercise` — Hands-on exercises with success criteria
- `/coach:cost` — Cost optimization coaching per level
- `/coach:discover` — Discovery protocol for new features
- `/coach:whats-new` — Discovery digest view
- `/coach:help` — Command listing

#### Coach Agent
- Deep environment scanner using native tools (Read, LS, Glob, Grep)
- Level detection algorithm (L0-L10)
- CLAUDE.md quality scoring (10-point rubric)
- Anti-pattern detection with severity levels
- Privacy-safe (never reads .env, credentials, secrets)
- First-run state initialization

#### Coaching Skill
- Auto-triggers on learning questions
- Level awareness from latest assessment
- Behavior rules (never skip levels, ground in real work, cost awareness)
- Context hygiene (loads only relevant knowledge files)
- Outcome logging to outcomes.jsonl

#### Knowledge Base (13 files)
- `knowledge/features/models.md` — L0-L1 model selection
- `knowledge/features/output-styles.md` — L1 output customization
- `knowledge/features/context.md` — L3 CLAUDE.md, rules, imports
- `knowledge/features/skills.md` — L4 skills framework
- `knowledge/features/agents.md` — L5 custom agents
- `knowledge/features/hooks.md` — L6 hooks system
- `knowledge/features/mcp.md` — L7 MCP servers
- `knowledge/features/headless.md` — L8 headless mode, SDK
- `knowledge/features/teams.md` — L9 agent teams
- `knowledge/commands/commands-ref.md` — Slash commands reference
- `knowledge/pricing/pricing-current.md` — February 2026 pricing
- `knowledge/ecosystem/cowork.md` — Cowork overview
- `knowledge/ecosystem/api.md` — API capabilities

#### State Management
- JSONL-based progress tracking
- State directory: `~/.claude/coaching/state/`
- Assessments, outcomes, discoveries persistence
- Cross-session continuity

### Technical Details

- Plugin validated with `claude plugin validate .`
- Knowledge base: 2,106 lines total (under 5,000 limit)
- Each knowledge file under 500 lines
- Works in both Claude Code and Cowork
- No external dependencies — uses Claude's native tools only
