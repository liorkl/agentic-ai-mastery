---
description: "Progress recap — what you've learned and how your repo got more Claude-ready over time"
---

# /coach:recap — Progress Recap

Summarizes the developer's coaching history into a short, motivating progress narrative: what they've practiced, what their repo gained, and what to focus on next. Read-only — it reads state, it doesn't scan or write.

`$ARGUMENTS` may narrow the window (e.g. `week`, `month`, `all`). Default: the last 7 days, falling back to the last 10 outcomes if fewer.

## Execution Steps

### 1. Load State

```
Read ~/.claude/coaching/state/assessments.jsonl
  → All entries. Use first + most recent to compute trajectory.

Read ~/.claude/coaching/state/outcomes.jsonl
  → Entries within the window (default last 7 days, else last 10).
```

If neither file exists or both are empty:
- Say: "No coaching history yet. Run `/coach:assess` to get a baseline, then `/coach:next` to start learning — come back and `/coach:recap` will show how far you've come."
- Exit.

### 2. Compute the Trajectory

From the assessment history (first → latest), derive the deltas that matter for *getting the best out of Claude* — lead with these, not the level number:

- **Verification readiness:** did `verification_ready` go false → true? Did a `verification_gate` appear? (This is the headline.)
- **Practice gaps closed:** which entries left `practice_gaps` (e.g. `no-plan-mode-habit`, `vague-prompts`)?
- **CLAUDE.md score:** first → latest (X/10 → Y/10), and which elements were added.
- **Anti-patterns resolved:** present in an earlier assessment, absent in the latest.
- **Level:** mention last, framed as feature breadth — not the point.

From outcomes, summarize the *coaching activity*: topics taught, exercises completed, and (where `applied` is set) what was actually applied to the repo.

### 3. Deliver the Recap

**Format (150-300 words):**

```markdown
## Your Progress — [window, e.g. "last 7 days" / "since you started on <first date>"]

### The headline
[One or two sentences leading with the biggest real gain. Prefer:
"Claude can now verify its own work in this repo — you added a test command and a Stop-hook gate."
over "You reached Level 5."]

### What you practiced
- [Topic / exercise] — [applied? evidence?]
- [Topic / exercise] — ...

### How your repo got more Claude-ready
- CLAUDE.md: [X/10 → Y/10] — added [elements]
- Verification: [not runnable → runnable / gated]
- Anti-patterns resolved: [list]

### Still open (your next focus)
[1-2 highest-leverage things, practice-first. If verification is still missing, that's #1 regardless of level.]
→ Run `/coach:next` to take the next one, or `/coach:compare` to see the full before/after.
```

If there's only one assessment (no trajectory yet), recap the outcomes/activity and note: "This is your baseline — run `/coach:assess` again after you've made changes and `/coach:recap` will show the delta."

## Tone

- Celebrate real progress with specifics ("you cleared context 3x more often"; "CLAUDE.md went 4/10 → 8/10"), not empty praise.
- Lead with repo-readiness and practice gains; the level number is a footnote.
- Do not include cost or token estimates — that's the opt-in `/coach:cost`.

## Avoid

- Inventing progress not supported by the state files
- Leading with the level number
- Generic encouragement with no concrete delta
