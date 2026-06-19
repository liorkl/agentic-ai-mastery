<!-- file: knowledge/features/models.md -->
<!-- last-updated: 2026-06-19 -->
<!-- source: https://code.claude.com/docs/en/best-practices -->

# Model Selection

## Current State

As of June 2026, Claude Code runs on the Claude 4.x / Fable family. Use the alias — never append date suffixes.

| Model | Alias | Context | Best For |
|-------|-------|---------|----------|
| **Claude Fable 5** | `claude-fable-5` | 1M | The hardest reasoning and long, autonomous agentic runs |
| **Claude Opus 4.8** | `claude-opus-4-8` | 1M | Architecture, complex debugging, long-horizon agentic work |
| **Claude Sonnet 4.6** | `claude-sonnet-4-6` | 1M | Daily coding and feature work — handles most tasks well |
| **Claude Haiku 4.5** | `claude-haiku-4-5` | 200K | Quick questions, simple edits, subagents |

> Opus is no longer the "5x expensive" tier it used to be — Opus 4.8 sits much closer to Sonnet now (see `knowledge/pricing/pricing-current.md`). Escalate to it whenever a task is genuinely hard; don't ration it on cost grounds.

## Key Concepts

### Switching Models

```bash
# Command-line flag
claude --model sonnet

# During a session
/model haiku
/model sonnet
/model opus
```

### Adaptive Thinking + Effort

The old `budget_tokens` "extended thinking" knob is gone on the 4.6+ family. Thinking is now **adaptive** — Claude decides when and how deeply to think — and you tune the overall depth/spend with the **effort** parameter:

- **low** — short, scoped, latency-sensitive tasks
- **medium** — balanced default for most work
- **high** — intelligence-sensitive work (recommended minimum for hard tasks)
- **xhigh** — best for most coding and agentic use cases (Claude Code's default)
- **max** — when correctness matters more than anything; can overthink

Higher effort means more thorough reasoning and more tool use; lower effort means terser, faster responses. On Opus 4.8 the intelligence ceiling is high enough that `high` is a sensible default — don't reach for `xhigh`/`max` reflexively.

### Per-Agent Model Routing

Set a model in a subagent's frontmatter so simple delegated work runs on a cheaper, faster model:

```yaml
# .claude/agents/reviewer.md frontmatter
model: haiku
```

A read-only reviewer or a file-search subagent doesn't need Opus — Haiku is fast and capable for focused, well-scoped jobs.

### Plan Mode (replaces the old "opusplan" idea)

The current best-practice workflow is **explore → plan → code**: enter plan mode, let Claude read the relevant code and produce a plan, then switch out of plan mode to implement. This separates research from execution so Claude doesn't solve the wrong problem — no special model alias required. Skip planning for one-sentence changes; use it when the approach is uncertain or the change spans multiple files.

### Model Selection by Task

| Task | Recommended |
|------|-------------|
| Quick syntax question | Haiku |
| Single-file edit | Haiku or Sonnet |
| Feature implementation | Sonnet |
| Multi-file refactor | Sonnet, escalate to Opus if hard |
| Architecture / planning | Opus (plan mode) |
| Code review (fresh-context subagent) | Haiku or Sonnet |
| Complex debugging | Opus |
| Long autonomous / overnight runs | Opus 4.8 or Fable 5 at high/xhigh effort |

## Mastery Checks

- [ ] Can you explain when to reach for each model tier?
- [ ] Do you default to Sonnet for daily work and escalate to Opus for hard problems?
- [ ] Do you use plan mode (explore → plan → code) for uncertain or multi-file work?
- [ ] Do your custom subagents specify an appropriate model?
- [ ] Do you tune `effort` instead of looking for a thinking-token budget?

## Official Resources

- [Best practices for Claude Code](https://code.claude.com/docs/en/best-practices)
- [Claude Code documentation](https://code.claude.com/docs/en/overview)
