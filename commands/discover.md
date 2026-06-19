---
description: Check for new Claude Code features and updates
---

# /coach:discover — Discovery Protocol

Delegates to the coach agent for the full discovery protocol: version check, changelog fetch, classification, and knowledge base update.

## Execution Steps

### 1. Delegate to Coach Agent

This command delegates to the `coach` agent in `agents/coach.md` for the full discovery flow. The agent has access to:
- WebSearch
- WebFetch
- Bash (for `claude --version`)
- Write (to `~/.claude/coaching/state/`)

### 2. Discovery Protocol (Executed by Agent)

The coach agent performs these steps:

#### Phase 1: Version Check

```bash
claude --version
```

Compare against `last_known_claude_code_version` in `~/.claude/coaching/state/discovery-state.json`.

#### Phase 2: Changelog Scan (if version changed OR >7 days stale)

```
1. WebFetch: https://raw.githubusercontent.com/anthropics/claude-code/main/CHANGELOG.md
2. Extract entries between last_known_version and current
3. Classify each entry:
   - curriculum-relevant: new feature, command, deprecation, pricing
   - diagnostic-relevant: new config, setting, env var
   - informational: bug fix, performance
   - noise: internal, CI/CD
4. Append curriculum-relevant + diagnostic-relevant to discoveries.jsonl
```

#### Phase 3: Web Search (if >3 days stale)

```
1. WebSearch: "Anthropic Claude Code new features [current month] 2026"
2. WebSearch: "Anthropic engineering blog Claude [current month] 2026"
3. WebFetch relevant results
4. Classify and append discoveries
```

#### Phase 4: Update State

```
1. Update ~/.claude/coaching/state/discovery-state.json:
   - last_discovery_run: [now]
   - last_known_claude_code_version: [current]
   - last_known_changelog_entry: [latest]

2. If curriculum-relevant discoveries found:
   - Update relevant knowledge file's "Recent Changes" section
   - Rewrite ~/.claude/coaching/state/discovery-digest.md
```

### 3. Handle First Run

If `~/.claude/coaching/state/` doesn't exist:
1. Create the directory
2. Create discovery-state.json with defaults:
   ```json
   {
     "last_discovery_run": null,
     "last_known_claude_code_version": null,
     "last_known_changelog_entry": null,
     "curriculum_version": "1.1",
     "knowledge_base_seeded": true
   }
   ```
3. Run full discovery to establish baseline

### 4. Report Results

After discovery completes, display:

```markdown
## Discovery Complete

**Version**: [current version]
**Changes since last check**: [N entries]

### Curriculum-Relevant
- [title 1] — [brief description]
- [title 2] — [brief description]

### Diagnostic-Relevant
- [title 1] — [brief description]

### Affects Your Level
[List any discoveries that affect user's current level]

---
Run `/coach:whats-new` anytime to see the full digest.
```

### 5. Log Outcome

Append to `~/.claude/coaching/state/outcomes.jsonl`:

```json
{
  "timestamp": "[ISO timestamp]",
  "session_id": "discover-[YYYYMMDD]",
  "user_level_at_time": [detected_level or null],
  "topic": "discovery",
  "subtopic": "manual-discovery",
  "coaching_action": "discovery",
  "exercise_given": false,
  "applied": null,
  "evidence_type": null,
  "notes": "[N discoveries found, M curriculum-relevant]"
}
```

## Graceful Degradation

| Failure | Behavior |
|---------|----------|
| Network unavailable | "Discovery requires network access. Coaching continues from existing knowledge." |
| Changelog fetch fails | Try WebSearch as fallback. If both fail, skip with message. |
| Version check fails | Use date-based staleness instead. Continue with web search. |
| State file corrupted | Recreate with defaults. Log warning. |

## Trigger Conditions

Discovery runs automatically (via agent) when:
- Coach is invoked AND discovery-state.json shows >7 days since last run
- User explicitly runs `/coach:discover`

Discovery does NOT run:
- On every session (too expensive)
- In the background (no scheduler)
- When network is unavailable

## Discovery Classification Reference

| Classification | Examples | Action |
|----------------|----------|--------|
| **Curriculum-relevant** | New feature, new command, deprecation, pricing change | Add to discoveries.jsonl, update knowledge files |
| **Diagnostic-relevant** | New config file, new setting, new env var | Add to discoveries.jsonl, update scan targets |
| **Informational** | Bug fix, performance improvement | Log only |
| **Noise** | Internal refactoring, CI changes | Skip |
