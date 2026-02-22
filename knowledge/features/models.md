<!--
topic: Model Selection
last_updated: February 2026
source_docs: curriculum-v1.1.md, cost-guide-v1.0.md
curriculum_level: L0-L1
-->

# Model Selection

## Current State

Claude Code supports three model tiers as of February 2026:

| Model | Strengths | Best For | Relative Cost |
|-------|-----------|----------|---------------|
| **Opus 4.6** | Most advanced reasoning, 1M context, agent teams | Architecture, complex debugging, multi-agent orchestration | 5x baseline |
| **Sonnet 4.5/4.6** | Best coding model, preferred 70% over previous versions | Daily coding, feature implementation, 80-90% of tasks | 3x baseline |
| **Haiku 4.5** | 90% of Sonnet's agentic performance, 2x speed | Quick questions, simple edits, code review, subagents | 1x baseline |

## Key Concepts

### Switching Models

```bash
# Command-line flag
claude --model sonnet

# During session
/model haiku
/model sonnet
/model opus

# Opus plans, Sonnet executes (recommended default for experienced users)
/model opusplan
```

### Effort Levels (Opus 4.6 Only)

Control adaptive thinking depth:
- **Low**: Routine tasks, minimal reasoning tokens
- **Medium**: Standard tasks, balanced
- **High**: Complex reasoning, maximum thinking tokens

Lower effort = fewer thinking tokens = cheaper.

### Model Selection by Task

| Task | Recommended Model |
|------|------------------|
| Quick syntax question | Haiku |
| Single-file edit | Haiku or Sonnet |
| Feature implementation | Sonnet |
| Multi-file refactor | Sonnet or opusplan |
| Architecture decision | Opus (plan mode) |
| Code review | Haiku |
| Complex debugging | opusplan |
| Writing tests | Sonnet |
| Documentation | Haiku |

### Agent-Level Model Routing

Specify cheaper models for agents doing simple work:

```yaml
# .claude/agents/reviewer.md frontmatter
model: haiku
```

A review agent reading code doesn't need Opus. Haiku costs 1/5th as much.

### The opusplan Strategy

Uses Opus for planning (read-only, high-reasoning) and automatically switches to Sonnet for execution (file writes, code generation). You get Opus-quality architectural thinking at Sonnet execution prices.

## Mastery Checks

- [ ] Can you explain when to use each model tier?
- [ ] Do you default to Sonnet and escalate selectively to Opus?
- [ ] Have you tried the opusplan strategy for complex tasks?
- [ ] Do your custom agents specify appropriate models?

## Cost Implications

Most developers default to Opus for everything, paying 5x unnecessarily.

**The 80/20 rule**: Sonnet handles 80-90% of coding tasks. Haiku handles simple tasks at 1/3 Sonnet's cost.

**Savings potential**: Switching from Opus-default to Sonnet-default saves 60-80% on token costs.

## Official Resources

- [Claude Code Documentation](https://code.claude.com/docs/en/overview)
- [Model Selection Best Practices](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/claude-4-best-practices)
