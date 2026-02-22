---
description: Get cost optimization coaching for your current level
---

# /coach:cost — Cost Optimization Coaching

Delivers level-appropriate cost coaching based on the user's environment and detected anti-patterns.

## Execution Steps

### 1. Load State

```
Read ~/.claude/coaching/state/assessments.jsonl
  → Get the LAST entry (most recent assessment)
  → Extract: detected_level, anti_patterns, features_detected

Read knowledge/pricing/pricing-current.md
  → Current pricing data and cost strategies
```

### 2. Handle Missing Assessment

If assessments.jsonl doesn't exist or is empty:
- Provide general cost overview
- Recommend `/coach:assess` for personalized coaching
- Continue with Level 0-1 cost basics

### 3. Identify Cost Issues

From latest assessment, extract:

**Anti-patterns with cost impact:**
- `claude_md_too_long`: Context overhead
- `mcp_server_unused`: Token waste per server
- `never_clearing_context`: Accumulated overhead
- `opus_for_everything`: Model mismatch
- `no_batch_api`: CI/CD cost doubling

**Level-specific cost considerations:**

| Level | Key Cost Topics |
|-------|-----------------|
| 0-1 | Model selection, effort levels, basic pricing |
| 2-3 | CLAUDE.md overhead, /clear vs /compact |
| 4-5 | Agent context windows, model: haiku for simple agents |
| 6 | Hooks are free (outside agentic loop) |
| 7 | MCP server token overhead, Tool Search |
| 8 | Batch API (50% savings), headless guardrails |
| 9 | Team multiplication (N agents × full context) |

### 4. Load Level-Appropriate Content

From `knowledge/pricing/pricing-current.md`, extract sections relevant to their level.

### 5. Deliver Cost Coaching

**Format:**

```markdown
## Cost Coaching — Level [N]

### Your Current Cost Profile

[Summary based on assessment]
- Detected level: [N]
- Active cost anti-patterns: [list or "None detected"]
- Estimated overhead: [if calculable]

### Priority Cost Actions

[Based on anti-patterns and level]

#### 1. [Highest Priority]
[Specific action with expected savings]

#### 2. [Second Priority]
[Specific action with expected savings]

### Cost Awareness for Your Level

[Level-appropriate cost concepts]

### February 2026 Quick Reference

| Model | Input/1M | Output/1M | Best For |
|-------|----------|-----------|----------|
| Haiku | $1 | $5 | Simple tasks, agents |
| Sonnet 4 | $3 | $15 | Daily development |
| Opus 4.5 | $15 | $75 | Complex reasoning |

### Try This

[One concrete cost-saving action]

### Track Your Costs

```bash
/context    # See current session breakdown
```
```

### 6. Log Outcome

Append to `~/.claude/coaching/state/outcomes.jsonl`:

```json
{
  "timestamp": "[ISO timestamp]",
  "session_id": "cost-[YYYYMMDD]",
  "user_level_at_time": [detected_level],
  "topic": "cost-optimization",
  "subtopic": "[specific focus]",
  "coaching_action": "taught",
  "exercise_given": false,
  "applied": null,
  "evidence_type": null,
  "notes": "[anti-patterns addressed]"
}
```

## Level-Specific Cost Coaching

### Levels 0-1: Cost Foundations

**Key concepts:**
- Model selection saves the most money
- Haiku: $1/$5 per million tokens (simple tasks)
- Sonnet: $3/$15 per million tokens (most work)
- Opus: $15/$75 per million tokens (complex only)

**Typical savings:** 50-80% by matching model to task

**Action:** "Try Haiku for your next documentation task. Compare the result."

### Levels 2-3: Context Efficiency

**Key concepts:**
- CLAUDE.md loads every message
- Each line ≈ 1 token of permanent overhead
- /clear between unrelated tasks
- /compact when context fills

**Typical savings:** 20-40% on long sessions

**Actions:**
- "Your CLAUDE.md is [N] lines. Target: <150."
- "Use /clear when switching tasks."

### Levels 4-5: Agent Economics

**Key concepts:**
- Each agent gets own context window
- Agent initialization has fixed cost
- Use `model: haiku` for simple agents
- Design agents for sustained work, not one-shot

**Typical savings:** 67% using Haiku agents

**Action:** "Add `model: haiku` to your reviewer agent."

### Level 6: Hooks Are Free

**Key concepts:**
- Hooks run outside agentic loop
- Zero token cost for hook execution
- Verbose hook output still adds to context
- Quality hooks prevent expensive rework

**ROI example:** "$0 lint hook saves $0.50 per caught error"

### Level 7: MCP Overhead

**Key concepts:**
- Each server adds 200-1000 tokens to every message
- 10 servers = 5-10% context budget gone
- Tool Search (late 2025) dynamically loads tools
- Most users use only 3-4 servers regularly

**Action:** "Run /context. If MCP tools >5%, remove unused servers."

### Level 8: Batch API

**Key concepts:**
- 50% discount on batch operations
- Use for: automated reviews, test generation, docs
- Requires async handling
- Critical guardrails: --max-turns, --timeout-minutes

**Action:** "Enable Batch API for CI/CD pipelines."

### Level 9: Team Multiplication

**Key concepts:**
- N agents × full context each
- Broadcasts scale with team size
- Use direct messages when possible
- ROI calculation: time savings vs 3-5x cost

**Question to ask:** "Does time savings justify 3-5x token cost?"

## Cost Anti-Patterns Quick Reference

| Anti-Pattern | Cost Impact | Fix |
|--------------|-------------|-----|
| CLAUDE.md >150 lines | +tokens/message | Split into rules/ |
| Unused MCP servers | +500 tokens/server | Remove inactive |
| Never clearing | Context fills | /clear between tasks |
| Opus everywhere | 5x Sonnet cost | Match model to task |
| No Batch API | 2x CI costs | Enable for automation |
| Giant agent prompts | +tokens/invocation | Keep agents focused |
