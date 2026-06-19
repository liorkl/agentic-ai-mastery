<!-- file: knowledge/pricing/pricing-current.md -->
<!-- last-updated: 2026-06-19 -->
<!-- source: https://www.anthropic.com/api#pricing -->

# Pricing & Cost Management

> Cost/token coaching is **off by default** in this plugin. This file is loaded only by the opt-in `/coach:cost` command — don't pull it into normal lessons.

## Current State (June 2026)

Claude Code billing follows Anthropic API rates. Match the model to the task and you rarely need to think harder about cost than that.

### Model Rates (per million tokens)

| Model | Input | Output | Notes |
|-------|-------|--------|-------|
| **Fable 5** | $10 | $50 | Most capable; reserve for the hardest work |
| **Opus 4.8** | $5 | $25 | Only ~1.7x Sonnet input — escalate freely |
| **Sonnet 4.6** | $3 | $15 | The daily-driver tier |
| **Haiku 4.5** | $1 | $5 | Simple tasks and subagents |

Batch API is 50% cheaper for non-interactive work. Prompt caching cuts cached input to ~0.1x. All current models offer a 1M context window (Haiku 4.5 is 200K) at flat rates — no long-context surcharge.

### What changed vs older guidance

- **Opus is no longer 5x.** Opus 4.8 is $5/$25 — close to Sonnet. The old "never use Opus, you're wasting 60-80%" advice is obsolete. Use Opus whenever a task is genuinely hard.
- **`budget_tokens` extended thinking is gone.** There's no separate "thinking tokens" line to budget — depth is controlled by the `effort` parameter, and thinking is billed as ordinary output.
- **"Fast mode" multipliers** referenced in older docs no longer apply on the 4.6+ family.

## Cost Levers (in rough order of impact)

1. **Match the model to the task** — Haiku for trivial work, Sonnet for most, Opus/Fable for the hard parts.
2. **Manage context** — `/clear` between unrelated tasks; `/compact` when a long session fills up; `/context` to see where the budget is going.
3. **Prompt caching** — large stable prefixes (CLAUDE.md, system prompts) cache automatically and cost ~0.1x on reads.
4. **Batch API** — 50% off for automated/CI work that doesn't need to be interactive.
5. **Right-size subagents** — give simple subagents `model: haiku`; keep agent prompts focused.

## Monitoring

```bash
/context   # Current session breakdown
```

The Anthropic Console shows daily/monthly usage and supports billing alerts.

## Mastery Checks

- [ ] Do you default to Sonnet and escalate to Opus/Fable only when warranted?
- [ ] Do you use `/clear` and `/compact` to keep sessions lean?
- [ ] Have you checked `/context` for MCP-server or CLAUDE.md bloat?
- [ ] Is Batch API enabled for any CI/automation you run?

## Official Resources

- [Anthropic pricing](https://www.anthropic.com/api#pricing)
- [Reduce token usage](https://code.claude.com/docs/en/costs)
- [Usage dashboard](https://console.anthropic.com/usage)
