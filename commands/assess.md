---
description: "Scan your Claude Code environment and report your skill level, gaps, and anti-patterns"
---

# Coach Assess

Run a full environment assessment to determine the developer's agentic AI skill level.

## Instructions

### 1. First-Run Check

Check if `~/.claude/coaching/state/` exists. If not, delegate to the coach agent to run first-run initialization before proceeding.

### 2. Delegate to Coach Agent

Delegate the full assessment to the **coach** agent with this task:

> Run a full deep scan of the current project environment. Scan project-level (.claude/ directory, CLAUDE.md, .mcp.json), project root files, and global configuration (~/.claude/). Apply the level detection algorithm, CLAUDE.md quality scoring, anti-pattern detection, and gap detection. Produce the full structured assessment report and append results to ~/.claude/coaching/state/assessments.jsonl.

### 3. Display Results

The coach agent will return a structured report. Display it to the user in this order:

1. **Detected Level** (L0-L10) with a one-line explanation of what that level means
2. **CLAUDE.md Score** (X/10) with element breakdown
3. **Features Found** — what's configured and working well
4. **Gaps** — missing foundations below detected level (these are HIGH priority)
5. **Anti-Patterns** — issues found with severity and specific fix recommendations
6. **Top 3 Next Steps** — prioritized actions to improve

### 4. Outcome Logging

After displaying results, append to `~/.claude/coaching/state/outcomes.jsonl`:

```json
{
  "timestamp": "<ISO 8601>",
  "session_id": "coach-<YYYYMMDD>",
  "user_level_at_time": <detected_level>,
  "topic": "assessment",
  "subtopic": "full-environment-scan",
  "coaching_action": "assessed",
  "exercise_given": false,
  "applied": null,
  "evidence_type": "env_change",
  "notes": "Detected level <N>, CLAUDE.md score <N>/10, <N> gaps, <N> anti-patterns"
}
```

### 5. Privacy Reminder

End the assessment with a brief note listing what was scanned (scan scope) so the developer knows exactly what the coach examined.

### Token Estimate

End every response with this footer:

---
**Estimated tokens this interaction:** ~1.5k input / ~0.8k output
*Input includes: coach agent prompt (~600 tokens), environment scan results (~600 tokens), this command (~300 tokens)*
