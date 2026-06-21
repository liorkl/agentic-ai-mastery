---
description: Opt-in cost/token coaching for your current level (off by default elsewhere)
---

# /coach:cost — Cost Optimization Coaching

Delivers level-appropriate cost coaching based on the user's environment and detected anti-patterns. This is the **only** place cost/token coaching surfaces — the rest of the plugin keeps it off by default, so users opt in here when they want it.

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
| 2 | CLAUDE.md overhead, /clear vs /compact |
| 3-4 | Agent context windows, model: haiku for simple agents |
| 5 | Hooks are free (outside agentic loop) |
| 6 | MCP server token overhead, progressive disclosure |
| 7 | Batch API (50% savings), headless guardrails |
| 8 | Parallel sessions (worktrees/dual-instance — each its own context) |
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

### Pricing Quick Reference (June 2026)

| Model | Input/1M | Output/1M | Best For |
|-------|----------|-----------|----------|
| Haiku 4.5 | $1 | $5 | Simple tasks, subagents |
| Sonnet 4.6 | $3 | $15 | Daily development |
| Opus 4.8 | $5 | $25 | Complex reasoning, long-horizon agentic work |
| Fable 5 | $10 | $50 | The hardest reasoning / long autonomous runs |

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

### Token Estimate

End every response with this footer:

---
**Estimated tokens this interaction:** ~1.1k input / ~0.5k output
*Input includes: pricing knowledge file (~800 tokens), state files (~300 tokens)*

## Level-Specific Cost Coaching

### Levels 0-1: Cost Foundations

**Key concepts:**
- Model selection saves the most money
- Haiku 4.5: $1/$5 per million tokens (simple tasks)
- Sonnet 4.6: $3/$15 per million tokens (most work)
- Opus 4.8: $5/$25 per million tokens (complex / long-horizon work)
- Fable 5: $10/$50 per million tokens (the hardest reasoning only)

**Typical savings:** 40-70% by matching model to task. Note Opus 4.8 is now only ~1.7x Sonnet's input price (not 5x) — escalate to it freely when a task is hard.

**Action:** "Try Haiku for your next documentation task. Compare the result."

### Level 2: Context Efficiency

**Key concepts:**
- CLAUDE.md loads every message
- Each line ≈ 1 token of permanent overhead
- /clear between unrelated tasks
- /compact when context fills

**Typical savings:** 20-40% on long sessions

**Actions:**
- "Your CLAUDE.md is [N] lines. Target: <150."
- "Use /clear when switching tasks."

### Levels 3-4: Agent Economics

**Key concepts:**
- Each agent gets own context window
- Agent initialization has fixed cost
- Use `model: haiku` for simple agents
- Design agents for sustained work, not one-shot

**Typical savings:** 67% using Haiku agents

**Action:** "Add `model: haiku` to your reviewer agent."

### Level 5: Hooks Are Free

**Key concepts:**
- Hooks run outside agentic loop
- Zero token cost for hook execution
- Verbose hook output still adds to context
- Quality hooks prevent expensive rework

**ROI example:** "$0 lint hook saves $0.50 per caught error"

### Level 6: MCP Overhead

**Key concepts:**
- Each server adds 200-1000 tokens to every message
- 10 servers = 5-10% context budget gone
- Tool Search (late 2025) dynamically loads tools
- Most users use only 3-4 servers regularly

**Action:** "Run /context. If MCP tools >5%, remove unused servers."

### Level 7: Batch API

**Key concepts:**
- 50% discount on batch operations
- Use for: automated reviews, test generation, docs
- Requires async handling
- Critical guardrails: --max-turns, --timeout-minutes

**Action:** "Enable Batch API for CI/CD pipelines."

### Level 8: Parallel Sessions

**Key concepts:**
- Worktrees / dual-instance run multiple concurrent sessions — each carries its own full context
- Cheaper than an agent team (no broadcast overhead), but still N× the per-session context
- Use for independent tracks (e.g. one writes, one reviews); converge before merging

**Action:** "Run a worktree session per independent task; close them when merged."

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
| Opus everywhere | ~1.7x Sonnet cost | Match model to task (the gap is much smaller now) |
| No Batch API | 2x CI costs | Enable for automation |
| Giant agent prompts | +tokens/invocation | Keep agents focused |
