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

1. **Getting the best out of Claude here?** — the headline: a 1-2 line verdict on the cross-cutting practices, led by verification (can Claude verify its own work here — a test/build/lint command, and ideally a gate that runs it?). This goes **above** the level number.
2. **Detected Level** (L0-L10) with a one-line explanation — and an explicit note that level = feature breadth, not output quality
3. **CLAUDE.md Score** (X/10) with element breakdown
4. **Features Found** — what's configured and working well
5. **Gaps** — missing foundations below detected level (these are HIGH priority)
6. **Anti-Patterns** — issues found with severity and specific fix recommendations
7. **Top 3 Next Steps** — prioritized actions. Order by leverage, not by level: a missing practice (especially verification) outranks the next feature

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

### 5. Call to Action

**If gaps or anti-patterns were found:**

```
---
**What to do now:**
Run `/coach:execute` to work your plan step by step — practices (verification first) then gaps, each with the why and exact code.
*Or run `/coach:next` if you'd rather learn the next concept first.*
```

**If the environment is clean (no gaps, no anti-patterns):**

```
---
**What to do now:**
Your environment is clean. Run `/coach:next` to get your next level-appropriate lesson.
```

### 6. Scan Receipt

### Scan Receipt

**Project scope scanned:**

- `.claude/` — settings, rules, hooks
- `CLAUDE.md` — project instructions
- `.mcp.json` — MCP server configuration (if present)
- `.claude-plugin/` — plugin manifest (if present)
- Project root files: `package.json`, `pyproject.toml`, `go.mod`, `Makefile`, etc.

**Global scope scanned:**

- `~/.claude/settings.json` — global Claude Code settings
- `~/.claude/CLAUDE.md` — global user instructions
- `~/.claude/keybindings.json` — custom keybindings (if present)

**State written:**

- `~/.claude/coaching/state/assessments.jsonl` — new assessment appended

Nothing else was read or written.
