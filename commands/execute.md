---
description: "Work your assessment plan step by step — cross-cutting practices (verification first), then feature gaps, with the why explained inline"
---

# /coach:execute — Step-by-Step Plan Execution

Walks the user through their assessment plan one step at a time. Each step combines **doing** (implementation) with **learning** (the why behind it).

## Philosophy

Assessment creates a plan. Execute turns the plan into applied knowledge.
The goal is not just to fix gaps — it's to understand why each fix matters
so the developer builds real intuition, not just a checklist.

The plan leads with the cross-cutting practices (verification first), then the
feature gaps — because a practice like "Claude can verify its own work here"
moves output quality more than the next feature. Practices are coached
*hands-on* here, not merely explained.

## Execution Steps

### 1. Load Assessment

```
Read ~/.claude/coaching/state/assessments.jsonl
  → Get the LAST entry (most recent assessment)
  → Extract: detected_level, gaps, anti_patterns, practice_gaps,
    verification_ready, verification_gate, project_path
```

If no assessment exists:
- Tell user: "No assessment found. Run `/coach:assess` first to generate your plan."
- Exit

### 2. Load or Initialize Execution State

```
Read ~/.claude/coaching/state/execution-state.json
  → If file doesn't exist, initialize it (see schema below)
  → If assessment_timestamp differs from latest assessment, reset state
```

**Schema:**

```json
{
  "assessment_timestamp": "<ISO from latest assessment>",
  "project_path": "<project_path from assessment>",
  "steps": [
    {
      "id": "<practice_gap slug | gap.gap | anti_pattern.id>",
      "type": "practice | gap | anti_pattern",
      "is_habit": "<true for behavioral practices with no file artifact, else false>",
      "priority": "CRITICAL | HIGH | MEDIUM | LOW",
      "summary": "<one-line description>",
      "status": "pending | done | skipped",
      "completed_at": null
    }
  ],
  "current_step_index": 0
}
```

**Building steps from assessment:**

Practices outrank features — a missing cross-cutting practice (especially verification) is a more important step than the next feature gap. Order steps like this:

1. **Verification & security first:**
   - Security anti-patterns (CRITICAL) — safety can't wait (no deny rules, `dangerouslySkipPermissions`)
   - `verification_ready: false` (or a `no-verification` practice gap) → a CRITICAL `practice` step: give Claude a check it can run
   - `verification_gate: false` (when verification is ready) → a HIGH `practice` step: make the check run automatically
2. **Other `practice_gaps`** (HIGH) — one `practice` step per slug, built from the Practice Catalog below
3. Gaps with `priority: HIGH` (ordered as they appear)
4. Anti-patterns with `severity: HIGH` or `CRITICAL` (any not already placed in step 1)
5. Gaps with `priority: MEDIUM`
6. Anti-patterns with `severity: MEDIUM`
7. Gaps with `priority: LOW`
8. Anti-patterns with `severity: LOW`

**Practice Catalog** — practices are coached *hands-on* here, not just explained:

| Signal | Step summary | Kind | How to implement | How to verify |
|--------|--------------|------|------------------|---------------|
| `verification_ready: false` / `no-verification` | Give Claude a check it can run | config | Add the repo's real test/build/lint command to CLAUDE.md | Read CLAUDE.md for a runnable command; if safe, run it once |
| `verification_gate: false` | Make the check run automatically | config | Add a Stop hook in `.claude/settings.json` that runs the check before Claude finishes | Read settings.json; confirm the Stop hook is present |
| `no-plan-mode-habit` | Plan before multi-file work | habit | Use plan mode (Shift+Tab → "plan") for unfamiliar or multi-file tasks; optionally add a one-line "plan-first for X" note to CLAUDE.md | Confirm they know the keybind and when to reach for it |
| `vague-prompts` | Ground every prompt | habit | Point at specific files, an example pattern to follow, and the symptom — not "fix the bug" | Confirm they can restate a recent vague prompt in grounded form |
| `no-clear-between-tasks` / `no-context-hygiene` | Keep context clean | habit (may pair with a CLAUDE.md trim) | `/clear` between unrelated tasks; keep CLAUDE.md short; use subagents for investigation | Behavioral; if a CLAUDE.md trim is involved, re-check the line count |
| `no-course-correction` | Course-correct early | habit | Stop and redirect the moment Claude drifts; `/clear` and re-prompt rather than fight a polluted context | Confirm they'll interrupt and redirect instead of pushing through |

Set each practice step's `is_habit` from the **Kind** column (`config` → false, `habit` → true). `config` steps use the normal apply / done / skip + verify flow; `habit` steps are handled in **Step 6b**.

If a practice overlaps a `gap`, `anti_pattern`, or assessment `recommendation` (e.g. verification often also appears as a recommendation), create ONE step — typed `practice` — and don't duplicate it.

### 3. Check Completion

If all steps are `done` or `skipped`:
```
Congratulate user. Show summary:
  - Steps completed: N
  - Skipped: N
  - Suggest: "Run `/coach:assess` to verify your improvements and detect your new level."
```
Exit.

### 4. Find Current Step

Find the first step in `steps[]` where `status === "pending"`.

Show progress header:
```
**Plan Progress: Step N of Total** (N remaining)
████░░░░░░ 40%
```

### 5. Present the Step

Present the step in this format:

```markdown
---
## Step N of Total — [Step Summary]

**Priority:** HIGH / MEDIUM / LOW

### What You're Doing

[One concrete sentence: what file to create/edit, what setting to add]

### Why This Matters

[2-3 sentences explaining the real-world consequence of having vs. not having this.
Ground it in their project — reference actual files from the assessment.
Make the risk or benefit tangible, not abstract.]

### How to Implement

[Concrete implementation — file path, exact content to add, command to run.
Include a code block showing exactly what to create or change.
Reference their project_path where relevant.]

### The Mental Model

[One insight that transfers beyond this specific fix.
What principle does this teach? What will they recognize next time?]

---

Type **apply** to let me implement this for you, **done** if you've already applied it,
**skip** to come back later, or ask any question before proceeding.
```

### 6. Wait for User Response

After presenting the step, **stop and wait**. Do not auto-advance.

Change the closing prompt to:

```
Type **apply** to let me implement this for you, **done** if you've already applied it,
**skip** to come back later, or ask any question before proceeding.
```

The user must respond with one of:
- **"apply"** → use Claude's tools to implement the fix directly (see Step 6a), then mark complete and advance
- **"done"** → user applied it manually, mark complete and advance
- **"skip"** → mark skipped, advance
- **Any other text** → treat as a question, answer it in context of this step,
  then re-present the prompt

### 6a. On "apply" — Implement Using Claude's Tools

Use the appropriate tool to apply the fix:
- File creation or edit → use **Write** or **Edit** with the exact content from "How to Implement"
- Shell command → use **Bash**
- Multiple changes → apply them in sequence

After applying, confirm what was done:

```
✓ Applied. I've created/updated <file or command> as shown above.
```

Then proceed as if the user said "done" — mark complete, log, advance.

### 6b. Practice Steps — Behavioral Habits

For a step with `type: "practice"` and `is_habit: true`, there is no file to create — the change is a working habit, not config. Adapt the flow:

- **Options:** replace the closing prompt with:
  `Type **got it** once you've taken it in (you'll practice it in your next sessions), **skip** to come back later, or ask anything about it first.`
- **No "apply":** there is nothing to implement with a tool. If the practice has an *optional* artifact (e.g. a one-line CLAUDE.md note for plan-first), you may offer it, but don't require it.
- **Verification (Step 7) becomes a quick check, not a file read:** confirm understanding or commitment in one line — e.g. "✓ You can now restate a vague prompt in grounded form — that's the habit." If they're unsure, answer and re-present rather than advancing.
- **Logging (Step 9):** use `coaching_action: "practiced"`, `applied: false`, `evidence_type: "acknowledged"`.

`config` practice steps (verification command, verification gate, a CLAUDE.md trim) keep the normal apply / done / skip + file-verification flow and log `coaching_action: "applied"`, `evidence_type: "env_change"`.

### 7. On "done" or after "apply" — Verify the Fix

Before marking complete, verify the fix was actually applied using Claude's tools:

- **File created/edited** → Read the file and confirm the expected content is present
- **Shell command** → Run a verification command (e.g. `cat`, `ls`, `which`) to confirm the outcome
- **Multiple changes** → Spot-check the most critical one

**If verification passes:**

```
✓ Verified. <one sentence confirming what was found, e.g. "deny rules are present in .claude/settings.json">
```

Proceed to mark complete and log.

**If verification fails** (file missing, content wrong):

```
⚠ I checked but couldn't confirm the fix was applied — <what was expected vs. what was found>.
Type **apply** to let me implement it, or fix it manually and type **done** again.
```

Do not mark complete. Re-present the options.

### 8. Cross-Step Dependency Hint

After verification passes, check if the completed step and the next pending step are known to build on each other. If so, add a one-line bridge before advancing:

| Completed | Next | Bridge hint |
|---|---|---|
| verification command (CLAUDE.md) | verification gate (Stop hook) | "Claude now has a command to run — the next step makes a hook run it automatically before Claude finishes, so the loop closes without you watching." |
| L4 skill gap | L5 agent gap | "The skill you just created can be wired into your agent in the next step — we'll reference it from the agent's system prompt." |
| L5 agent gap | any | "Your agent is ready. Consider which skills it should call on — we'll connect them if needed." |
| settings.json deny rules | any | "Deny rules apply to all tools, including any agents you create — no extra config needed." |

Only show the bridge hint when both steps are present and pending. Skip silently otherwise.

### 9. Mark Complete and Log

Update execution-state.json:
- Set `steps[current_index].status = "done"`
- Set `steps[current_index].completed_at = <ISO timestamp>`
- Increment `current_step_index`

After confirming, append to `~/.claude/coaching/state/outcomes.jsonl`:

```json
{
  "timestamp": "<ISO 8601>",
  "session_id": "execute-<YYYYMMDD>",
  "user_level_at_time": <detected_level>,
  "topic": "<step type: gap or anti_pattern>",
  "subtopic": "<step id>",
  "coaching_action": "applied",
  "exercise_given": false,
  "applied": true,
  "evidence_type": "env_change",
  "notes": "User applied: <step summary>"
}
```

For **practice** steps, log per **Step 6b**: habit steps use `coaching_action: "practiced"`, `applied: false`, `evidence_type: "acknowledged"`; config-backed practice steps use `applied: true`, `evidence_type: "env_change"`.

Then show a brief reinforcement:
```
✓ Done. [One sentence connecting what they just did to the bigger picture.]

Moving to next step...
```

Then immediately present the next step (Step N+1).

### 10. On "skip" — Mark Skipped and Advance

Update execution-state.json:
- Set `steps[current_index].status = "skipped"`
- Increment `current_step_index`

Show: "Skipped. You can re-run `/coach:execute` later to return to skipped steps."

Then present the next step.

## Resuming

When the user runs `/coach:execute` again mid-plan:
- Show the progress header with how many steps are done/remaining
- Jump directly to the first `pending` step
- Add: "Resuming from where you left off."

## Example Step Presentation

For gap: `No .claude/settings.json with deny rules` on FounderFinder:

```markdown
---
## Step 1 of 4 — Create .claude/settings.json with Deny Rules

**Priority:** HIGH

### What You're Doing

Create `.claude/settings.json` in your FounderFinder project with permission
rules that block Claude from reading credential files.

### Why This Matters

Claude's tools can read any file accessible on your filesystem. Right now,
a poorly-worded prompt (or an automated task) could cause Claude to read your
`.env`, include your database credentials in its context, and log them.
FounderFinder has a `.env` file — this is not hypothetical risk.

### How to Implement

Create `/Users/liorklibansky/dev/FounderFinder/.claude/settings.json`:

```json
{
  "permissions": {
    "deny": [
      "Read(.env)",
      "Read(.env.*)",
      "Read(**/.env)",
      "Read(**/secrets/**)",
      "Read(**/credentials/**)"
    ]
  }
}
```

### The Mental Model

Claude's permission system evaluates `deny` before `allow`. Think of it like
a firewall: deny rules are your default-closed gates. Any pattern you add here
applies to ALL tools (Read, Edit, Bash). One settings.json protects the whole project.

---

Type **apply** to let me implement this for you, **done** if you've already applied it,
**skip** to come back later, or ask any question before proceeding.
```

For a **config-backed practice** (`verification_ready: false`) on FounderFinder:

```markdown
---
## Step 1 of 5 — Give Claude a Check It Can Run

**Priority:** CRITICAL

### What You're Doing

Add your project's real test/build/lint command to `CLAUDE.md` so Claude can
verify its own changes instead of waiting for you to catch mistakes.

### Why This Matters

This is the single biggest lever on output quality. Right now Claude finishes a
change and hands it back unchecked — you're the test runner. FounderFinder has a
`package.json` with a `test` script; once Claude knows the command, it runs it,
sees failures, and iterates until green on its own.

### How to Implement

Add a Verification section to your `CLAUDE.md` (shown indented):

    ## Verification

    Run tests: `npm test`
    Run one file: `npm test -- src/foo.test.ts`
    Type-check: `npm run typecheck`

### The Mental Model

A session where Claude can run a check is one it can finish; a session where it
can't is one you babysit. Verification is the difference — it's why this is step 1.

---

Type **apply** to let me implement this for you, **done** if you've already applied it,
**skip** to come back later, or ask any question before proceeding.
```

For a **habit practice** (`vague-prompts`) — note the different options and no file to apply:

```markdown
---
## Step 3 of 5 — Ground Every Prompt

**Priority:** HIGH

### What You're Doing

Build the habit of pointing Claude at specific files, an example pattern to
follow, and the actual symptom — instead of "fix the bug" or "make it better."

### Why This Matters

Your recent prompts ("clean up the auth code") send Claude exploring blind. A
grounded prompt — "in `src/auth/session.ts`, the refresh token isn't rotated on
renewal; follow the pattern in `login.ts`" — gets the right change on the first
try. Precision up front beats correction after.

### How to Implement

Nothing to install — this is a working habit. Next time, before you hit enter,
add the three anchors: which file(s), which pattern to follow, what's wrong.

### The Mental Model

Claude is only as grounded as your prompt. Naming the file, the pattern, and the
symptom turns an open-ended search into a targeted edit.

---

Type **got it** once you've taken it in (you'll practice it in your next sessions),
**skip** to come back later, or ask anything about it first.
```
