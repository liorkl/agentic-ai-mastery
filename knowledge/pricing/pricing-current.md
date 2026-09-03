<!-- file: knowledge/pricing/pricing-current.md -->
<!-- last-updated: 2026-09-03 -->
<!-- source: https://www.anthropic.com/api#pricing -->

# Pricing & Cost Management

> Cost/token coaching is **off by default** in this plugin. This file loads only on an explicit cost question — don't pull it into normal lessons.

## Current State

Claude Code billing follows Anthropic API rates. Match the model to the task and you rarely need to think harder about cost than that.

### Model Rates (per million tokens)

| Model | Input | Output | Notes |
|-------|-------|--------|-------|
| **Fable 5.1** | $10 | $50 | Most capable; reserve for the hardest work |
| **Opus 5** | $5 | $25 | Only ~2.5x Sonnet input — escalate freely |
| **Sonnet 5** | $2 | $10 | The daily-driver tier, and cheaper than Sonnet 4.6 was |
| **Haiku 4.5** | $1 | $5 | Simple tasks and subagents |

Batch API is 50% cheaper for non-interactive work. Prompt caching cuts cached input to ~0.1x. All current models offer a 1M context window (Haiku 4.5 is 200K) at flat rates — no long-context surcharge.

### What changed vs older guidance

- **Opus is no longer 5x.** Opus 5 is $5/$25 — a little over 2x Sonnet input. The old "never use Opus, you're wasting 60-80%" advice is obsolete. Use Opus whenever a task is genuinely hard.
- **The daily driver got cheaper.** Sonnet 5 is $2/$10, down from Sonnet 4.6's $3/$15. If your cost notes still assume $3/$15, they overstate your bill by ~50%.
- **`budget_tokens` extended thinking is gone.** There's no separate "thinking tokens" line to budget — depth is controlled by the `effort` level, and thinking is billed as ordinary output.
- **Effort is the first quality-trading lever**, after the free wins. Caching and context hygiene cost nothing; dropping effort trades thoroughness for spend within one model, which is usually better than switching to a weaker model.

## Cost Levers (in rough order of impact)

1. **Free wins first** — prompt caching, `/clear` between unrelated tasks, `/compact` when a session fills, `/context` to see where the budget goes.
2. **Match the model to the task** — Haiku for trivial work, Sonnet for most, Opus/Fable for the hard parts.
3. **Tune `effort`** — `low` for subagents and simple tasks, `high` as the default, `max` only when measurement shows headroom at the level below.
4. **Batch API** — 50% off for automated/CI work that doesn't need to be interactive.
5. **Right-size subagents** — give simple subagents `model: haiku`; keep agent prompts focused.

Judge cost per *completed task*, not per request — a cheaper request that needs more turns to finish the job isn't cheaper.

## Monitoring

```bash
/context   # Current session breakdown
/usage     # Token usage (alias: /cost)
```

The Anthropic Console shows daily/monthly usage and supports billing alerts.

## Mastery Checks

- [ ] Do you default to Sonnet and escalate to Opus/Fable only when warranted?
- [ ] Do you use `/clear` and `/compact` to keep sessions lean?
- [ ] Have you checked `/context` for MCP-server or CLAUDE.md bloat?
- [ ] Do you reach for `effort` before reaching for a weaker model?
- [ ] Is Batch API enabled for any CI/automation you run?

## Official Resources

- [Anthropic pricing](https://www.anthropic.com/api#pricing)
- [Reduce token usage](https://code.claude.com/docs/en/costs)
- [Usage dashboard](https://console.anthropic.com/usage)
