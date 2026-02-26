---
description: Show recent Claude Code changes that affect your learning
---

# /coach:whats-new — Discovery Digest

Shows recent Claude Code changes from the discovery system, filtered for curriculum relevance and your current level.

## Execution Steps

### 1. Load Discovery State

```
Read ~/.claude/coaching/state/discovery-state.json
  → Get last_discovery_run, last_known_claude_code_version

Read ~/.claude/coaching/state/discoveries.jsonl
  → Get all discoveries (or last 30 if file is large)

Read ~/.claude/coaching/state/assessments.jsonl
  → Get latest assessment for user's current level
```

### 2. Handle Missing State

If discovery-state.json doesn't exist or is empty:
- Tell user: "No discovery data yet."
- Suggest: "Run `/coach:discover` to check for updates."
- Exit

If discoveries.jsonl doesn't exist or is empty:
- Tell user: "No discoveries recorded yet."
- Suggest: "Run `/coach:discover` to scan for changes."
- Exit

### 3. Calculate Staleness

```
staleness_days = (now - last_discovery_run) in days
```

Display warning if stale:
- 3-7 days: "Discovery data is [N] days old."
- 7+ days: "Discovery data is stale ([N] days). Run `/coach:discover` to refresh."

### 4. Filter Discoveries

**Filter for recency:**
- Default: Last 14 days
- Show date headers for grouping

**Filter for relevance:**
- Prioritize: curriculum-relevant, diagnostic-relevant
- De-prioritize: informational
- Hide: noise

**Filter for level:**
If user has assessment, highlight discoveries affecting their level:
```
affected_levels includes user.detected_level
```

### 5. Format Digest

**Output format:**

```markdown
## What's New in Claude Code

**Last checked**: [date] | **Version**: [version] | **Staleness**: [N days]

---

### 🟢 New Capabilities

**[Title]** — [date]
[Brief description]
→ Affects: Level [N] | [Relevance to user]

**[Title]** — [date]
[Brief description]
→ Affects: Level [N] | [Relevance to user]

---

### 💰 Cost-Relevant Changes

**[Title]** — [date]
[Brief description]
→ Impact: [cost implication]

---

### 🔧 Configuration Changes

**[Title]** — [date]
[Brief description]
→ Diagnostic: [what to check]

---

### 📚 Affects Your Level ([N])

[List of discoveries specifically relevant to user's current level]

---

### ℹ️ Other Updates

[Informational items, collapsed or brief]

---

*Run `/coach:discover` to refresh • [N] total discoveries in history*
```

### 6. Log Outcome

Append to `~/.claude/coaching/state/outcomes.jsonl`:

```json
{
  "timestamp": "[ISO timestamp]",
  "session_id": "whats-new-[YYYYMMDD]",
  "user_level_at_time": [detected_level or null],
  "topic": "discovery",
  "subtopic": "digest-view",
  "coaching_action": "informed",
  "exercise_given": false,
  "applied": null,
  "evidence_type": null,
  "notes": "Viewed discovery digest"
}
```

### Token Estimate

End every response with this footer:

---
**Estimated tokens this interaction:** ~1.8k input / ~0.5k output
*Input includes: web search results (~1.5k tokens), this command (~300 tokens)*

## Discovery Entry Format

Each entry in discoveries.jsonl:

```json
{
  "timestamp": "2026-02-20T10:30:00Z",
  "source": "github_changelog",
  "source_version": "2.1.9",
  "classification": "curriculum-relevant",
  "title": "Nested skills auto-discovery",
  "description": "Skills in nested directories now auto-discovered",
  "affected_levels": [4],
  "cost_impact": null,
  "status": "pending"
}
```

## Grouping Logic

Group discoveries by:

1. **Classification** (primary grouping)
   - curriculum-relevant → "New Capabilities"
   - cost_impact not null → "Cost-Relevant"
   - diagnostic-relevant → "Configuration Changes"
   - informational → "Other Updates"

2. **Recency** (within groups)
   - Most recent first
   - Show date for each

3. **User relevance** (highlight)
   - Entries matching user's level get ⭐ or special callout

## Examples

**Full digest:**

```markdown
## What's New in Claude Code

**Last checked**: Feb 20, 2026 | **Version**: 2.1.9 | **Fresh** ✓

---

### 🟢 New Capabilities

**Nested skills auto-discovery** — Feb 19
Skills in nested `.claude/skills` directories now auto-discovered.
→ Affects: Level 4 | Useful for monorepos

**Context window percentage in status** — Feb 18
New status line shows context usage percentage.
→ Affects: Level 3 | Helps with context monitoring

---

### 💰 Cost-Relevant Changes

**Sonnet 4.6 launched** — Feb 17
Same pricing as Sonnet 4.5, improved agentic performance.
→ Impact: Consider switching default model

---

### 📚 Affects Your Level (4)

- **Nested skills auto-discovery** — directly relevant to your skills work

---

*Run `/coach:discover` to refresh • 12 total discoveries*
```

**Empty state:**

```markdown
## What's New in Claude Code

No discoveries recorded yet.

Run `/coach:discover` to check for updates.
```

**Stale state:**

```markdown
## What's New in Claude Code

⚠️ Discovery data is 8 days stale. Run `/coach:discover` to refresh.

**Last checked**: Feb 12, 2026 | **Version**: 2.1.7

[... existing discoveries ...]
```
