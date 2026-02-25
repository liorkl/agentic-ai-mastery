# Agentic AI Mastery — Claude Code Coaching Plugin

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](.claude-plugin/plugin.json)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Plugin-orange.svg)](https://claude.ai/code)
[![Contributions Welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg)](CONTRIBUTING.md)

A Claude Code plugin that teaches developers to master agentic AI development progressively — from first install to system-level design. The coach lives inside your Claude Code workflow, assesses your skill level by scanning your environment, delivers targeted coaching through real work, and tracks your progress over time.

**Works in both Claude Code and Cowork.**

## What It Does

- Scans your Claude Code environment to detect your current skill level (L0–L10)
- Identifies gaps in your setup and flags anti-patterns
- Delivers level-appropriate lessons grounded in your actual project files
- Provides hands-on exercises with clear success criteria
- Tracks progress across sessions
- Discovers new Claude Code features and updates weekly
- Includes cost awareness in every coaching interaction

## Installation

### From Marketplace (Preferred)

```bash
# Add the marketplace
claude plugin marketplace add liorklibansky/agentic-ai-mastery

# Install the coach plugin
claude plugin install coach@agentic-ai-mastery
```

### Local Install (Development / Testing)

```bash
# Clone the repo
git clone https://github.com/liorklibansky/agentic-ai-mastery ~/dev/agentic-ai-mastery

# In Claude Code, add as local marketplace
/plugin marketplace add ~/dev/agentic-ai-mastery
/plugin install coach@agentic-ai-mastery
```

After installation, the plugin is available in every Claude Code and Cowork session.

### Verify Installation

```bash
/coach:help
```

You should see a list of available coaching commands.

## Commands

| Command | Description |
|---------|-------------|
| `/coach:assess` | Scan your environment and report skill level, gaps, and anti-patterns |
| `/coach:next` | Get your next lesson based on current level and gaps |
| `/coach:status` | Show current level, last assessment date, and discovery staleness |
| `/coach:exercise` | Get a hands-on exercise for your current skill level |
| `/coach:whats-new` | Show recent Claude Code changes that affect your learning |
| `/coach:discover` | Check for new Claude Code features and updates |
| `/coach:cost` | Get cost optimization coaching for your current level |
| `/coach:help` | List all commands and current coaching state |

## Getting Started

1. Install the plugin (see above)
2. Open any project in Claude Code or Cowork
3. Run `/coach:assess` to scan your environment
4. Run `/coach:next` to get your first lesson

The coaching skill also activates automatically when you ask learning-related questions — no command needed.

## Curriculum Levels

| Level | Focus |
|-------|-------|
| L0 | First contact — using Claude Code for the first time |
| L1 | Basic configuration — output styles, model selection |
| L2 | Quality configuration — CLAUDE.md, settings |
| L3 | Context engineering — rules, @imports, multiple CLAUDE.md |
| L4 | Skills framework — creating and using skills |
| L5 | Custom agents — delegation, sub-agents |
| L6 | Hooks system — event-driven automation |
| L7 | MCP servers — external tool integration |
| L8 | Headless mode — CI/CD, SDK, harness pattern |
| L9 | Agent teams — multi-agent orchestration |
| L10 | System design — governance, quality gates, full mastery |

## Auto-Triggered Coaching

The plugin includes a coaching skill that activates automatically when you ask learning questions like:
- "How do I use agents?"
- "What's the best way to structure CLAUDE.md?"
- "Is this costing too much?"

No command needed — just ask naturally.

## State Storage

The coach stores progress data in `~/.claude/coaching/state/`:
- `assessments.jsonl` — environment scan history
- `outcomes.jsonl` — coaching interaction outcomes
- `discoveries.jsonl` — discovered features and updates
- `discovery-state.json` — last scan timestamps
- `strategies.md` — evolved coaching approach

State persists across sessions and projects.

## Privacy

The coach never reads sensitive files (.env, credentials, secrets, keys). It only scans Claude Code configuration files and writes state to `~/.claude/coaching/`.

## Contributing

This is an open-source project. Contributions are welcome:
- Report issues or suggest features via GitHub Issues
- Submit pull requests for bug fixes or enhancements
- Share feedback on the curriculum or coaching approach

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for release history.

## License

MIT — see [LICENSE](LICENSE)
