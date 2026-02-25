---
description: "Fix the gaps in an existing project step by step — applies your assessment plan with the why explained inline"
---

# /coach:execute — Step-by-Step Plan Execution

Walks the user through their assessment plan one step at a time. Each step combines **doing** (implementation) with **learning** (the why behind it).

## Philosophy

Assessment creates a plan. Execute turns the plan into applied knowledge.
The goal is not just to fix gaps — it's to understand why each fix matters
so the developer builds real intuition, not just a checklist.

## Execution Steps

### 1. Load Assessment

```
Read ~/.claude/coaching/state/assessments.jsonl
  → Get the LAST entry (most recent assessment)
  → Extract: detected_level, gaps, anti_patterns, project_path
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
      "id": "<gap.gap or anti_pattern.id>",
      "type": "gap | anti_pattern",
      "priority": "HIGH | MEDIUM | LOW",
      "summary": "<one-line description>",
      "status": "pending | done | skipped",
      "completed_at": null
    }
  ],
  "current_step_index": 0
}
```

**Building steps from assessment:**

Order steps by priority:
1. Gaps with `priority: HIGH` (ordered as they appear)
2. Anti-patterns with `severity: HIGH` or `CRITICAL`
3. Gaps with `priority: MEDIUM`
4. Anti-patterns with `severity: MEDIUM`
5. Gaps with `priority: LOW`
6. Anti-patterns with `severity: LOW`

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

Type **done** when you've applied it, **skip** to come back later,
or ask any question to learn more before proceeding.
```

### 6. Wait for User Response

After presenting the step, **stop and wait**. Do not auto-advance.

The user must respond with one of:
- **"done"** → mark step complete, advance
- **"skip"** → mark step skipped, advance
- **Any other text** → treat as a question, answer it in context of this step,
  then re-present the prompt ("Type **done** when ready...")

### 7. On "done" — Mark Complete and Log

Update execution-state.json:
- Set `steps[current_index].status = "done"`
- Set `steps[current_index].completed_at = <ISO timestamp>`
- Increment `current_step_index`

Append to `~/.claude/coaching/state/outcomes.jsonl`:

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

Then show a brief reinforcement:
```
✓ Done. [One sentence connecting what they just did to the bigger picture.]

Moving to next step...
```

Then immediately present the next step (Step N+1).

### 8. On "skip" — Mark Skipped and Advance

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

Type **done** when you've applied it, **skip** to come back later,
or ask any question to learn more before proceeding.
```
