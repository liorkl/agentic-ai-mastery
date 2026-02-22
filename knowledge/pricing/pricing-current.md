<!--
topic: Pricing & Cost Management
last_updated: February 2026
source_docs: cost-guide-v1.0.md
curriculum_level: All
-->

# Pricing & Cost Management

## Current State

Claude Code pricing follows Anthropic API rates. Understanding costs is essential for sustainable agentic development.

## February 2026 Pricing

### Model Rates (per million tokens)

| Model | Input | Output | Cache Read | Cache Write |
|-------|-------|--------|------------|-------------|
| **Opus 4.5** | $15 | $75 | $1.50 | $18.75 |
| **Opus 4.6 Fast** | $37.50 | $187.50 | $3.75 | $46.88 |
| **Sonnet 4** | $3 | $15 | $0.30 | $3.75 |
| **Haiku** | $1 | $5 | $0.10 | $1.25 |

### API Plans

| Plan | Monthly | Per-Seat |
|------|---------|----------|
| **Max (Individual)** | $200 | — |
| **Team 5** | $2,000/seat or $8,000/team | $400/seat |
| **Enterprise** | Volume-based | Custom |

### Cost Multipliers

| Feature | Multiplier |
|---------|------------|
| **Fast Mode (Opus 4.6)** | 2.5x speed, 6x standard rates |
| **Agent Teams** | N agents × full context each |
| **Extended Thinking** | Output tokens × thinking multiplier |
| **Batch API** | 0.5x (50% discount, async) |

## Context Overhead Per Session

Every session starts with fixed costs:

```
System prompt:     ~2,000 tokens
Tool definitions:  ~3,000 tokens
CLAUDE.md:         ~500-2,000 tokens
MCP servers:       ~500/server
------------------------
Minimum overhead:  ~5,000-10,000 tokens
```

**At Sonnet 4 rates**: $0.015-$0.03 before you even start.

## Cost Control Strategies

### Model Selection

**Haiku for**:
- Code review (read-only)
- Simple refactoring
- Test generation
- Documentation

**Sonnet for**:
- Standard development
- Bug fixing
- Feature implementation
- Most daily work

**Opus for**:
- Architecture decisions
- Complex debugging
- Novel problem solving
- When Sonnet fails

### Context Management

**Use `/clear` aggressively**:
- Between unrelated tasks
- After completing features
- Before starting fresh work

**Use `/compact` strategically**:
- When context fills but you need continuity
- Preserves ~20-40% of context summary

**Check `/context` regularly**:
- Identify context waste
- Remove unused MCP servers
- Trim CLAUDE.md if needed

### Batch Operations

**Batch API** (50% cheaper):
- Automated PR reviews
- Nightly test generation
- Documentation updates
- Any non-interactive work

### Caching

**Prompt caching** (90% cheaper reads):
- CLAUDE.md cached automatically
- System prompts cached
- Benefits compound in long sessions

## Cost Estimation

### Per-Task Estimates (Sonnet 4)

| Task | Typical Cost |
|------|-------------|
| Simple bug fix | $0.05-$0.20 |
| New feature | $0.50-$2.00 |
| Code review | $0.10-$0.50 |
| Test generation | $0.20-$1.00 |
| Complex refactor | $2.00-$10.00 |

### Monthly Projections

| Usage Level | Daily | Monthly |
|-------------|-------|---------|
| Light | $2-5 | $40-100 |
| Moderate | $10-20 | $200-400 |
| Heavy | $30-50 | $600-1,000 |
| Team (5 devs) | $100-200 | $2,000-4,000 |

## Cost Monitoring

### Built-in Tools

```bash
/context  # See current session costs
```

### API Dashboard

- Console shows daily/monthly usage
- Set billing alerts
- Track per-project costs

### Hooks for Cost Control

```bash
# PostToolUse hook — alert on threshold
if [ "$CUMULATIVE_TOKENS" -gt 100000 ]; then
  echo "Warning: High token usage"
  exit 2
fi
```

## Anti-Patterns (Expensive Mistakes)

| Anti-Pattern | Cost Impact | Fix |
|--------------|-------------|-----|
| Never clearing context | 10x overhead | `/clear` between tasks |
| Opus for everything | 5x unnecessary | Match model to task |
| Unused MCP servers | +500 tokens/server | Remove inactive servers |
| Giant CLAUDE.md | +2,000 tokens | Keep under 1,000 lines |
| Verbose conversation | Context fills fast | Be concise |
| No Batch API for automation | 2x CI costs | Enable Batch for CI |

## Team Cost Allocation

### Per-Developer Budgets

```
Monthly budget: $200/developer
Alert at: 80% ($160)
Hard cap: 120% ($240)
```

### Project-Based Tracking

Tag API calls by project for allocation.

## Mastery Checks

- [ ] Do you know your typical daily spend?
- [ ] Do you select appropriate models for tasks?
- [ ] Do you use `/clear` and `/compact` effectively?
- [ ] Have you checked MCP server overhead?
- [ ] Is Batch API enabled for automation?

## Official Resources

- [Anthropic Pricing](https://www.anthropic.com/api#pricing)
- [Usage Dashboard](https://console.anthropic.com/usage)
- [Cost Optimization Guide](https://docs.anthropic.com/en/docs/build-with-claude/optimize-costs)
