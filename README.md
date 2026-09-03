# Agentic AI Mastery — Claude Code Coaching Plugin

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-2.0.0-blue.svg)](.claude-plugin/plugin.json)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Plugin-orange.svg)](https://claude.ai/code)
[![Contributions Welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg)](CONTRIBUTING.md)

A Claude Code plugin that coaches a developer — or a whole team — on two separate
missions:

| | Mission | Lives in | Who benefits |
|---|---------|----------|--------------|
| **1** | **Your personal environment is highly effective** | `~/.claude/` — permissions, model and effort defaults, your own skills and subagents, MCP servers, statusline, global `CLAUDE.md` | You, in every project you open |
| **2** | **Your repo is Claude-ready** | `CLAUDE.md`, `.claude/rules/`, hooks, project skills and agents, a test command Claude can run | Everyone on the team, including people who have tuned nothing |

**They fail independently, so the plugin keeps them apart.** An excellent personal setup
does nothing for a repo where Claude has no way to verify its work. A well-prepared repo
does nothing for a developer whose permissions prompt on every edit. `/coach:assess` and
`/coach:apply` take a `me` or `repo` scope, and the two are never averaged into one score.

The coach lives inside your Claude Code workflow and teaches through your real files.

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

- **Measures both missions separately** — verification readiness first, then feature level (L0–L10), reported per scope
- **Changes things, in both missions** — `/coach:apply me` edits your `~/.claude/` setup; `/coach:apply repo` edits what gets committed. Always after showing the diff, always merging rather than overwriting
- Flags anti-patterns, led by "Claude can't verify its own work here"
- Teaches through your actual files — practice gaps before feature gaps
- Hands-on exercises with a verification command you can actually run
- Tracks progress across sessions, per mission

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

The ladder is a **feature scaffold, not a score** — a repo can sit at L9 and still produce
mediocre output if it skips the practices above. Each rung is tagged with the mission it
serves:

| Level | Mission | Focus |
|-------|---------|-------|
| L0 | 1 | Foundations & setup — first session, model selection, permission modes, checkpoints/rewind |
| L1 | 1 | Prompting & the core loop — grounded prompts, plan mode, output styles, thinking effort |
| L2 | **2** | Project memory & context — CLAUDE.md, rules, @path, scoping |
| L3 | 1 | MCP — external context & reach (git, Slack, Jira, docs, logs, AWS; plus actions like Playwright) |
| L4 | **2** | Skills — reusable workflows (the cure for CLAUDE.md bloat) |
| L5 | **2** | Subagents — delegation and context isolation |
| L6 | **2** | Hooks — deterministic quality gates (incl. the verification gate) |
| L7 | 1 | Headless, SDK & CI — non-interactive runs, the Agent SDK, automation |
| L8 | 1 | Parallel work — git worktrees, dual-instance (writer + reviewer) |
| L9 | 1 | Agent teams — multi-agent orchestration (start simple first) |
| L10 | **2** | Distribution & mastery — plugins, governance, operating at scale |

Mission 1 rungs change your machine; mission 2 rungs change files you commit.

## Auto-Triggered Coaching

The plugin includes a coaching skill that activates automatically when you ask learning questions like:
- "How do I use agents?"
- "What's the best way to structure CLAUDE.md?"
- "When should I use a skill vs a subagent?"

No command needed — just ask naturally.

## State Storage

The coach stores progress data in `~/.claude/coaching/state/`:
- `assessments.jsonl` — scan history, one record per scope (`me` or `repo`)
- `outcomes.jsonl` — coaching interaction outcomes
- `strategies.md` — evolved coaching approach

State persists across sessions and projects, and is local to your machine — nothing is
sent anywhere.

## Privacy

**What it reads.** Claude Code configuration only — `~/.claude/` and the project's
`.claude/`, `CLAUDE.md`, `.mcp.json`, and build manifests. It is instructed never to read
`.env` files, credentials, secrets, keys, or certificates.

**What it changes.** Only `/coach:apply`, only the step you are on, and only after showing
you the exact content first. It merges into existing files rather than overwriting them.
The `coach` agent itself is read-only outside `~/.claude/coaching/`.

**How that is enforced — read this part.** These are instructions to a model, not a
sandbox. They are followed reliably in practice but they are not a hard guarantee, and the
`trust` block in `marketplace.json` is metadata that Claude Code ignores at load time. If
you want enforcement rather than instruction, add `deny` rules to your own
`permissions` settings — which is exactly what this plugin will coach you to do:

```json
{
  "permissions": {
    "deny": ["Read(./.env)", "Read(./.env.*)", "Read(./**/*.pem)"]
  }
}
```

The same caution applies to any plugin you install, including this one: review a plugin's
`allowed-tools` and hooks before enabling it.

## Contributing

This is an open-source project. Contributions are welcome:
- Report issues or suggest features via GitHub Issues
- Submit pull requests for bug fixes or enhancements
- Share feedback on the curriculum or coaching approach

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for release history.

## License

MIT — see [LICENSE](LICENSE)
