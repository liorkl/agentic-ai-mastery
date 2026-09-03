---
description: "Teach the next highest-leverage thing for your setup — as a lesson, or as a hands-on exercise"
argument-hint: "[topic | exercise]"
disable-model-invocation: true
allowed-tools: Read(~/.claude/coaching/state/**)
---

# /coach:learn — Next Lesson or Exercise

Picks the one thing worth learning next and delivers it. Two depths:

| Argument | Mode | Output |
|----------|------|--------|
| *(none)* or a topic | **Lesson** | 150–350 words: the concept, grounded in their environment, with the exact edit to make |
| `exercise` | **Exercise** | A task they do themselves, with success criteria and a verification command |

Naming a topic (`/coach:learn hooks`) overrides the priority ladder — the user asked, so
teach that. Otherwise the ladder decides.

## Execution Steps

### 1. Load State

```
Read ~/.claude/coaching/state/assessments.jsonl
  → LAST entry. Extract: detected_level, gaps, features_detected,
    anti_patterns, practice_gaps, verification_ready, project_path

Read ~/.claude/coaching/state/strategies.md
  → Coaching approach and pacing guidance

Read last 5 entries from ~/.claude/coaching/state/outcomes.jsonl
  → Don't repeat a topic or exercise covered recently
```

### 2. Handle a Missing Assessment

If `assessments.jsonl` is absent or empty:

> I need to see your environment before I can coach on it. Run `/coach:assess` first,
> then come back to `/coach:learn`.

Then stop.

### 3. Pick the Topic — by Leverage, Not by Level

1. **Missing cross-cutting practice — verification first.** If `verification_ready` is
   false (no test/build/lint command Claude can run), teach that FIRST, whatever the
   level. It is the single biggest lever on output quality. A Level 7 repo with no
   verification gets a verification lesson, not an MCP lesson.
   Then the other practices when weak: plan-first (explore → plan → code), grounding
   prompts in specific files and symptoms, course-correcting early, context hygiene.
2. **Anti-patterns** at HIGH or CRITICAL severity. Fix before teaching new material;
   security and verification take precedence.
3. **HIGH-priority feature gaps** — foundations skipped below the detected level, e.g. a
   Level 5 user with a weak CLAUDE.md (Level 2).
4. **Current-level mastery** — the next skill at their level, per the curriculum mastery
   checks.
5. **Next-level preview** — a brief look ahead if the current level is mastered. Don't
   deep-dive above level.

### 4. Load Exactly One Knowledge File

| Level | Topic | File |
|-------|-------|------|
| any | Cross-cutting practices: verification, plan-first, grounding prompts, course-correction, context hygiene | `knowledge/features/productivity-tips.md` |
| 0 | CLI orientation, first session | `knowledge/features/cli-orientation.md` |
| 0 | Permission modes, plan mode, safe operation, sandboxing | `knowledge/features/permissions.md` |
| 0-1 | Model selection, effort | `knowledge/features/models.md` |
| 1 | Output styles | `knowledge/features/output-styles.md` |
| 1-2 | Productivity, prompting, context hygiene | `knowledge/features/productivity-tips.md` |
| 2 | CLAUDE.md, context & memory | `knowledge/features/context.md` |
| 3 | MCP — external context & reach | `knowledge/features/mcp.md` |
| 4 | Skills | `knowledge/features/skills.md` |
| 5 | Subagents | `knowledge/features/agents.md` |
| 6 | Hooks | `knowledge/features/hooks.md` |
| 7 | Headless, SDK & CI | `knowledge/features/headless.md` |
| 8 | Parallel work: git worktrees, dual-instance | `knowledge/features/teams.md` |
| 9 | Agent teams | `knowledge/features/teams.md` |
| 10 | Distribution — packaging and sharing a Claude-ready setup | `knowledge/features/plugins.md` |

One file, not several. Do **not** load `knowledge/pricing/pricing-current.md` — cost
coaching is off by default and loads only on an explicit cost question.

### 5a. Deliver a Lesson (default)

150–350 words:

```markdown
## [Topic Name] — Level [N]

[Opening: why this matters at their level, in their repo]

### Key Concept

[The core teaching point]

### In Your Environment

[Specific reference to their files/config — what to check or create]

### Do This Now

[The actual file edit, config block, or command, as a code block with the target path
as a comment]

[One sentence: where this goes and what it does]

### Why It Matters

[One paragraph of reasoning, grounded in their project]

### Resources

- [Link to official docs]
```

### 5b. Deliver an Exercise (`exercise`)

Same ladder picks the focus; the output is a task they complete themselves.

```markdown
## Exercise: [Title]

**Level:** [N] | **Focus:** [Topic] | **Effort:** [Low/Medium/High]

### Why This Matters

[1–2 sentences tying it to their gaps]

### Your Task

1. [First step]
2. [Second step]
3. [Third step]

### Success Criteria

- [ ] [Criterion]
- [ ] [Criterion]

### Verify

```bash
[the command that proves it worked]
```

Expected: [what they should see]

### Hints

<details>
<summary>Stuck?</summary>

[Hints that don't give away the answer]

</details>
```

Prefer an exercise whose verification is a command the user can actually run in their
repo. An exercise with no runnable check teaches the wrong habit.

### 6. Log the Outcome

`outcomes.jsonl` is append-only, but **the Write tool truncates**. To add a line: read
the existing file, append the new line to its contents, and write the whole file back.
Writing only the new line destroys the history.

```json
{
  "timestamp": "[ISO timestamp]",
  "session_id": "learn-[YYYYMMDD]",
  "user_level_at_time": [detected_level],
  "topic": "[feature area]",
  "subtopic": "[specific topic or exercise]",
  "coaching_action": "taught",
  "exercise_given": [true if exercise mode],
  "applied": null,
  "evidence_type": null,
  "notes": "[gap addressed or topic covered]"
}
```

## Avoid

- Teaching above the user's level
- Generic advice not grounded in their project
- Loading more than one knowledge file
- Repeating a topic from the last 5 outcomes
- Volunteering cost or token advice
- Writing `outcomes.jsonl` without first reading it
