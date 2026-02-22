---
description: "Show current coaching level, last assessment date, and discovery staleness"
---

# Coach Status

Show a quick summary of the developer's current coaching state.

## Instructions

### 1. First-Run Check

Check if `~/.claude/coaching/state/` exists. If not, inform the user:

> No coaching data found. Run `/coach:assess` first to scan your environment and establish your baseline.

Then stop.

### 2. Read Latest Assessment

Read `~/.claude/coaching/state/assessments.jsonl` and extract the LAST line (most recent assessment).

Parse the JSON to extract:
- `detected_level`
- `claude_md_score`
- `timestamp`
- `project_path`
- `gaps` (count)
- `anti_patterns` (count)

### 3. Read Discovery State

Read `~/.claude/coaching/state/discovery-state.json` to extract:
- `last_discovery_run`
- `last_known_claude_code_version`

Calculate staleness: days since `last_discovery_run`. If >7 days or null, mark as STALE.

### 4. Read Recent Outcomes

Read `~/.claude/coaching/state/outcomes.jsonl` and count the last 5 entries to show coaching activity.

### 5. Display Summary

Present a concise status dashboard:

```
Coaching Status
───────────────
Level:        L<N> — <level name>
CLAUDE.md:    <score>/10
Last Scan:    <date> (<project path>)
Gaps:         <N> found
Anti-patterns: <N> found
Discovery:    <last run date> (<FRESH|STALE — N days ago>)
Version:      Claude Code <version>
Sessions:     <N> coaching interactions logged
```

### 6. Recommendations

If discovery is stale (>7 days), suggest: "Run `/coach:discover` to check for new Claude Code features."

If gaps exist, suggest: "Run `/coach:next` to work on your highest-priority gap."

If no assessment exists for the current project, suggest: "Run `/coach:assess` to scan this project."
