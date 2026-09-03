---
description: "How your environment and repo have changed — snapshot, narrative recap, or before/after diff"
argument-hint: "[ | week | month | all | previous | since <ISO date>]"
disable-model-invocation: true
allowed-tools: Read(~/.claude/coaching/state/**)
---

# /coach:progress — Progress Report

One report over the coaching state, in three depths. Read-only: it reads state, it never
scans or writes.

`$ARGUMENTS` picks the depth:

| Argument | View | Answers |
|----------|------|---------|
| *(none)* | **Snapshot** | "Where do I stand right now?" |
| `week`, `month`, `all` | **Recap** | "What have I actually gained over this window?" |
| `previous`, `first`, `since <ISO date>` | **Diff** | "What changed between these two assessments?" |

## Execution Steps

### 1. Load State

```
Read ~/.claude/coaching/state/assessments.jsonl
  → All entries. Filter to the current project_path for the diff view.

Read ~/.claude/coaching/state/outcomes.jsonl
  → Entries in the window (recap), or the last 5 (snapshot).
```

If `~/.claude/coaching/state/` does not exist, or both files are empty:

> No coaching data yet. Run `/coach:assess` to establish a baseline, then `/coach:learn`
> to start. Come back and `/coach:progress` will show how far you've come.

Then stop. Do not invent a baseline.

### 2. Read the Signals in Leverage Order

Every view leads with readiness, not the level number. A repo can level up and still
regress on verification — say so when it does.

| Dimension | Read as |
|-----------|---------|
| `verification_ready` | `false → true` is the biggest possible gain. This is the headline |
| `verification_gate` | A gate appearing closes the loop unattended |
| `claude_md_score` | X/10 → Y/10, naming which elements were added or lost |
| `anti_patterns` | Resolved (gone) vs new (appeared) |
| `gaps` | Closed vs newly surfaced |
| `practice_gaps` | Which practices were internalized |
| `detected_level` | Last, framed as feature breadth — not the point |

### 3a. Snapshot (no arguments)

Use the most recent assessment. Present it tight:

```
Coaching Status
───────────────
Verification:  <not runnable | runnable | runnable + gated>
CLAUDE.md:     <score>/10
Level:         L<N> — <level name>
Last scan:     <date> (<project path>)
Gaps:          <N> open
Anti-patterns: <N> open
Sessions:      <N> coaching interactions logged
```

Then at most two recommendations, highest-leverage first:

- Verification not ready → that, regardless of level.
- Open gaps → `/coach:apply` to close them on this project.
- No assessment for the current project → `/coach:assess` to scan it.

### 3b. Recap (`week` / `month` / `all`)

Default window is 7 days, falling back to the last 10 outcomes if fewer. 150–300 words:

```markdown
## Your Progress — [window]

### The headline
[The biggest real gain, in one or two sentences. Prefer "Claude can now verify its own
work in this repo — you added a test command and a Stop-hook gate" over "You reached
Level 5."]

### What you practiced
- [Topic / exercise] — [applied? evidence?]

### How your repo got more Claude-ready
- CLAUDE.md: [X/10 → Y/10] — added [elements]
- Verification: [not runnable → runnable / gated]
- Anti-patterns resolved: [list]

### Still open (your next focus)
[1–2 highest-leverage things, practice first. If verification is still missing, that is
#1 regardless of level.]
→ `/coach:learn` to take the next one, or `/coach:progress previous` for the diff.
```

With only one assessment on record, recap the activity and say: "This is your baseline —
run `/coach:assess` again after you've made changes and the delta will show up here."

### 3c. Diff (`previous` / `first` / `since <ISO date>`)

`after` = most recent entry for this project. `before` = the baseline the argument selects
(`first` = earliest, `previous` = the one before latest, a date = nearest on/before it).

Thin cases, then stop:

- **No assessments:** "No assessments yet — run `/coach:assess` to set a baseline."
- **Only one:** "Only one assessment on record (your baseline). Make some changes, run
  `/coach:assess` again, then `/coach:progress previous` will show the delta."

Otherwise, 150–300 words:

```markdown
## Before → After  ([before date] → [after date])

### Is the repo more Claude-ready? [Yes, clearly / Somewhat / Not yet / Regressed]
[One-line verdict, led by verification readiness.]

### Gains
- Verification: [not runnable → runnable + gated]
- CLAUDE.md: [X/10 → Y/10] (+[elements added])
- Resolved: [anti-pattern / gap]

### Regressions (if any)
- [anything that got worse — a new anti-pattern, a lost score element]

### Net
[detected_level N → M, noted as feature breadth.] [One sentence on the next-highest-
leverage move.]
→ `/coach:learn` to take it.
```

If `before` and `after` are identical, say "No change between these two assessments."
Do not manufacture a delta.

## Tone

- Concrete deltas from the state files: numbers and named elements, not adjectives.
- Celebrate real progress with specifics ("CLAUDE.md went 4/10 → 8/10"), not empty praise.
- Lead with repo-readiness; the level number is a footnote.

## Avoid

- Inventing progress or changes the state files do not support
- Leading with the level number
- Hiding a regression to make the report look good
- Volunteering cost or token estimates
