# Agentic AI Mastery — Claude Code Coaching Plugin

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-1.0.1-blue.svg)](.claude-plugin/plugin.json)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Plugin-orange.svg)](https://claude.ai/code)
[![Contributions Welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg)](CONTRIBUTING.md)

A Claude Code plugin that coaches a developer (or a whole team) toward two outcomes: **getting the best possible work out of Claude**, and **building repos where Claude does its best work** — so anyone gets great results without hand-holding. The coach lives inside your Claude Code workflow, assesses your environment, and teaches through your real project files.

**Works in both Claude Code and Cowork.**

## What "mastery" means here

It's not collecting features. It's internalizing the handful of cross-cutting practices that actually move output quality — coached at every level, **verification first**:

1. **Verify** — give Claude a check it can run (tests, build, lint, a screenshot). The single biggest lever.
2. **Explore → plan → code** — separate planning from execution so Claude solves the right problem.
3. **Ground the prompt** — point at specific files, example patterns, and the symptom.
4. **Course-correct early** — redirect the moment Claude drifts; `/clear` and re-prompt rather than fight a polluted context.
5. **Manage context** — short CLAUDE.md, `/clear` between tasks, subagents for investigation.

The L0–L10 levels below are a feature-progression scaffold layered on top — **not** a score. A repo can be "L9" and still get mediocre output if it skips the practices above.

## What It Does

- Assesses whether you're getting the best out of Claude and whether your repo is set up for it (verification readiness first), then reports your feature level (L0–L10)
- Flags anti-patterns, led by "Claude can't verify its own work here"
- Delivers lessons grounded in your actual project files — practice gaps before feature gaps
- Provides hands-on exercises with clear success criteria
- Tracks progress across sessions
- Discovers new Claude Code features and updates weekly

Cost/token coaching is **off by default** — just ask if you want it.

## Installation

### From Marketplace (Preferred)

```bash
# Add the marketplace
claude plugin marketplace add liorkl/agentic-ai-mastery

# Install the coach plugin
claude plugin install coach@agentic-ai-mastery
```

### Local Development

```bash
git clone https://github.com/liorkl/agentic-ai-mastery
```

Load the plugin for a session without installing — changes are picked up on each launch:

```bash
claude --plugin-dir /path/to/agentic-ai-mastery
```

To reload mid-session after editing files:

```bash
/reload-plugins
```

**To test the install/update UX** (register as a local marketplace):

```bash
claude plugin marketplace add /path/to/agentic-ai-mastery
claude plugin install coach@agentic-ai-mastery

# After changes:
claude plugin update coach@agentic-ai-mastery
```

### Verify Installation

```bash
/help
```

You should see a list of available coaching commands.

## Commands

Four commands. Each has one job, and they run in that order.

| Command | Job | Arguments |
|---------|-----|-----------|
| `/coach:assess` | **Measure** — scan your environment, report readiness, gaps, and anti-patterns | |
| `/coach:apply` | **Change** — work the assessment plan step by step, verification first, with the why inline | |
| `/coach:learn` | **Teach** — the next highest-leverage thing, as a lesson or a hands-on exercise | `[topic \| exercise]` |
| `/coach:progress` | **Report** — snapshot, narrative recap, or before/after diff | `[week \| month \| all \| previous \| since <date>]` |

Plus one skill, `coaching`, which Claude invokes on its own when you ask a Claude Code
question — you don't run it.

Cost/token coaching is off by default across all of them; ask explicitly if you want it.

## Getting Started

1. Install the plugin (see above)
2. Open any project in Claude Code or Cowork
3. Run `/coach:assess` to scan your environment
4. Run `/coach:learn` to get your first lesson

The coaching skill also activates automatically when you ask learning-related questions — no command needed.

## Curriculum Levels

| Level | Focus |
|-------|-------|
| L0 | Foundations & setup — first session, model selection, permission modes, checkpoints/rewind |
| L1 | Prompting & the core loop — grounded prompts, plan mode, output styles, thinking effort |
| L2 | Project memory & context — CLAUDE.md, rules, @path, scoping, context hygiene |
| L3 | MCP — external context & reach (git, Slack, Jira, docs, logs, AWS; plus actions like Playwright) |
| L4 | Skills — reusable workflows (the cure for CLAUDE.md bloat) |
| L5 | Subagents — delegation and context isolation |
| L6 | Hooks — deterministic quality gates (incl. the verification gate) |
| L7 | Headless, SDK & CI — non-interactive runs, the Agent SDK, automation |
| L8 | Parallel work — git worktrees, dual-instance (writer + reviewer) |
| L9 | Agent teams — multi-agent orchestration (start simple first) |
| L10 | Distribution & mastery — plugins, governance, operating at scale |

## Auto-Triggered Coaching

The plugin includes a coaching skill that activates automatically when you ask learning questions like:
- "How do I use agents?"
- "What's the best way to structure CLAUDE.md?"
- "When should I use a skill vs a subagent?"

No command needed — just ask naturally.

## State Storage

The coach stores progress data in `~/.claude/coaching/state/`:
- `assessments.jsonl` — environment scan history
- `outcomes.jsonl` — coaching interaction outcomes
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
