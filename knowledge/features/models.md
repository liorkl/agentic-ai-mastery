<!-- file: knowledge/features/models.md -->
<!-- last-updated: 2026-09-03 -->
<!-- source: https://www.anthropic.com/api#pricing -->

# Model Selection

## Current State

Claude Code runs on the **Claude 5 family**. Use the exact model ID — never append date suffixes.

| Model | Model ID | Context | Best For |
|-------|----------|---------|----------|
| **Claude Fable 5.1** | `claude-fable-5-1` | 1M | The hardest reasoning and long, autonomous agentic runs |
| **Claude Opus 5** | `claude-opus-5` | 1M | Architecture, complex debugging, long-horizon agentic work |
| **Claude Sonnet 5** | `claude-sonnet-5` | 1M | Daily coding and feature work — handles most tasks well |
| **Claude Haiku 4.5** | `claude-haiku-4-5` | 200K | Quick questions, simple edits, subagents |

> Two things changed that invalidate older cost instincts. **Opus is no longer the "5x expensive" tier** — Opus 5 is $5/$25, close to Sonnet. And **Sonnet 5 is cheaper than the Sonnet it replaced** ($2/$10 vs Sonnet 4.6's $3/$15), so the daily driver got both better and less expensive. Escalate when a task is genuinely hard; don't ration on cost grounds. See `knowledge/pricing/pricing-current.md`.

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

The old `budget_tokens` "extended thinking" knob is gone on the current family — it returns a 400 on Opus 5, Sonnet 5, and Fable 5.1. Thinking is now **adaptive** (Claude decides when and how deeply to think), and you tune overall depth/spend with the **effort** level:

- **low** — short, scoped, latency-sensitive tasks; good for subagents
- **medium** — the cost-saving step-down where quality holds
- **high** — the default; recommended minimum for intelligence-sensitive work
- **xhigh** — best for most coding and agentic use cases
- **max** — when correctness matters more than cost; can overthink

Higher effort means more thorough reasoning and more tool use; lower effort means fewer, more-consolidated tool calls and terser responses. Tune it per task rather than globally — and note that lower effort on a newer model often beats high effort on the previous generation.

Set it with `/effort`, or per-skill with the `effort` frontmatter field.

### Per-Agent Model Routing

Set a model in a subagent's frontmatter so simple delegated work runs on a cheaper, faster model:

```yaml
# .claude/agents/reviewer.md frontmatter
model: haiku
```

A read-only reviewer or a file-search subagent doesn't need Opus — Haiku is fast and capable for focused, well-scoped jobs. A skill can do the same with its own `model` and `effort` fields.

### Plan Mode (replaces the old "opusplan" idea)

The current best-practice workflow is **explore → plan → code**: enter plan mode, let Claude read the relevant code and produce a plan, then switch out of plan mode to implement. This separates research from execution so Claude doesn't solve the wrong problem — no special model alias required. Enter it with `/plan` or Shift+Tab. Skip planning for one-sentence changes; use it when the approach is uncertain or the change spans multiple files.

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
| Long autonomous / overnight runs | Opus 5 or Fable 5.1 at high/xhigh effort |

## Mastery Checks

- [ ] Can you explain when to reach for each model tier?
- [ ] Do you default to Sonnet for daily work and escalate to Opus for hard problems?
- [ ] Do you use plan mode (explore → plan → code) for uncertain or multi-file work?
- [ ] Do your custom subagents specify an appropriate model?
- [ ] Do you tune `effort` instead of looking for a thinking-token budget?

## Official Resources

- [Anthropic pricing](https://www.anthropic.com/api#pricing)
- [Claude Code model configuration](https://code.claude.com/docs/en/model-config)
