---
description: "Before/after diff of your environment — concrete proof your repo got more Claude-ready"
---

# /coach:compare — Before/After Comparison

Diffs two assessments of the current project and shows exactly what changed — so improvement is concrete, not vibes. Read-only — it reads assessment history, it doesn't re-scan or write. To capture a fresh "after", run `/coach:assess` first, then `/coach:compare`.

`$ARGUMENTS` selects the baseline: `first` (default — earliest assessment), `previous` (the one before latest), or an ISO date (nearest assessment on/before it).

## Execution Steps

### 1. Load State

```
Read ~/.claude/coaching/state/assessments.jsonl
  → Filter to entries for the current project_path.
  → "after"  = most recent entry.
  → "before" = baseline per $ARGUMENTS (default: earliest).
```

Handle the thin cases:
- **No assessments:** "No assessments yet — run `/coach:assess` to set a baseline."
- **Only one assessment:** "Only one assessment on record (your baseline). Make some changes, run `/coach:assess` again, then `/coach:compare` will show the delta."
- Then exit.

### 2. Diff the Two Assessments

Compare field by field and classify each change as a **gain**, **regression**, or **unchanged**. Lead with the readiness signals, not the level:

| Dimension | Before | After | Read as |
|-----------|--------|-------|---------|
| `verification_ready` | t/f | t/f | false→true is the biggest possible gain |
| `verification_gate` | t/f | t/f | a gate appearing closes the loop unattended |
| `claude_md_score` | X/10 | Y/10 | list which elements were added/lost |
| `anti_patterns` | set | set | resolved (gone) vs new (appeared) |
| `gaps` | set | set | closed vs newly surfaced |
| `practice_gaps` | list | list | which practices were internalized |
| `detected_level` | N | M | last, framed as feature breadth |

### 3. Deliver the Comparison

**Format (150-300 words):**

```markdown
## Before → After  ([before date] → [after date])

### Is the repo more Claude-ready? [Yes, clearly / Somewhat / Not yet / Regressed]
[One-line verdict led by verification readiness.]

### Gains ✅
- Verification: [not runnable → runnable + gated]
- CLAUDE.md: [X/10 → Y/10] (+[elements added])
- Resolved: [anti-pattern / gap]

### Regressions ⚠️ (if any)
- [anything that got worse — a new anti-pattern, a lost score element]

### Net
[detected_level N → M, noted as feature breadth.] [One sentence on what the next-highest-leverage move is.]
→ `/coach:next` to take it, or `/coach:recap` for the learning-activity view.
```

If `before` and `after` are identical, say so plainly: "No change between these two assessments." — don't manufacture a delta.

## Tone

- Concrete deltas only, from the state files. Numbers and named elements, not adjectives.
- Lead with repo-readiness (verification first); level is a footnote.
- No cost or token content — that's the opt-in `/coach:cost`.

## Avoid

- Reporting changes not present in the two assessment records
- Treating a higher level as the proof of improvement (a repo can level up and still regress on verification)
- Hiding regressions to make the diff look good
