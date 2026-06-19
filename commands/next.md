---
description: "Learn the next concept for your level — best for greenfield projects or building new skills from the curriculum"
---

# /coach:next — Next Lesson

Delivers a targeted lesson based on the user's current skill level and priority gaps.

## Execution Steps

### 1. Load State

```
Read ~/.claude/coaching/state/assessments.jsonl
  → Get the LAST entry (most recent assessment)
  → Extract: detected_level, gaps, features_detected, anti_patterns

Read ~/.claude/coaching/state/strategies.md
  → Get coaching approach and pacing guidance

Read last 3 entries from ~/.claude/coaching/state/outcomes.jsonl
  → Avoid repeating recent topics
```

### 2. Handle Missing Assessment

If assessments.jsonl doesn't exist or is empty:
- Tell user: "I need to assess your environment first to provide targeted coaching."
- Run: "Please run `/coach:assess` first, then come back with `/coach:next`."
- Exit

### 3. Determine Lesson Topic

**Priority order** (order by leverage, not by level):

1. **Missing cross-cutting practice — verification first**
   - If `verification_ready` is false (no test/build/lint command Claude can run): teach this FIRST, regardless of level. It's the #1 lever for output quality.
   - Then the other practices when weak: plan-first (explore→plan→code), grounding prompts in specific files/patterns/symptoms, course-correcting early, context hygiene.
   - These outrank features — a Level 7 repo with no verification gets a verification lesson, not an MCP lesson.

2. **Anti-patterns** (if severity HIGH or CRITICAL)
   - Address these before teaching new material
   - Security and verification issues take precedence

3. **HIGH-priority feature gaps** (features missing below detected level)
   - Foundations the user skipped — e.g. a Level 5 user missing a quality CLAUDE.md (Level 2)

4. **Current level mastery** (if no practice gaps, anti-patterns, or feature gaps)
   - Teach the next skill at their current level, using the curriculum mastery checks

5. **Next level preview** (if current level mastered)
   - Brief introduction to what's ahead — don't deep-dive above level

### 4. Load Relevant Knowledge File

Based on topic, read ONE file from knowledge/:

| Level | Topic | File |
|-------|-------|------|
| any | Cross-cutting practices: verification, plan-first, grounding prompts, course-correction, context hygiene | knowledge/features/productivity-tips.md |
| 0 | CLI orientation, first session | knowledge/features/cli-orientation.md |
| 0-1 | Model selection | knowledge/features/models.md |
| 1 | Output styles | knowledge/features/output-styles.md |
| 1-3 | Productivity tips, prompting, context hygiene | knowledge/features/productivity-tips.md |
| 2-3 | CLAUDE.md, context | knowledge/features/context.md |
| 4 | Skills | knowledge/features/skills.md |
| 5 | Agents | knowledge/features/agents.md |
| 6 | Hooks | knowledge/features/hooks.md |
| 7 | MCP | knowledge/features/mcp.md |
| 8 | Headless | knowledge/features/headless.md |
| 9 | Teams | knowledge/features/teams.md |
| 10 | Plugins — packaging & sharing a Claude-ready setup with the team | knowledge/features/plugins.md |

Do NOT load `knowledge/pricing/pricing-current.md` here — cost/token coaching is off by default and lives in the opt-in `/coach:cost` command.

### 5. Deliver Lesson

**Format (150-350 words):**

```markdown
## [Topic Name] — Level [N]

[Opening: Why this matters at their level]

### Key Concept

[Core teaching point, grounded in their project]

### In Your Environment

[Specific reference to their files/config]
[What they should check or create]

### Do This Now

[The actual file edit, config block, or command to run — formatted as a code block with the target file path as the language hint comment]

[One sentence: where this goes and what it does]

### Why It Matters

[One paragraph: the reasoning, grounded in their project]

### Resources

- [Link to official docs or Academy course]
```

### 6. Log Outcome

Append to `~/.claude/coaching/state/outcomes.jsonl`:

```json
{
  "timestamp": "[ISO timestamp]",
  "session_id": "next-[YYYYMMDD]",
  "user_level_at_time": [detected_level],
  "topic": "[feature area]",
  "subtopic": "[specific topic]",
  "coaching_action": "taught",
  "exercise_given": false,
  "applied": null,
  "evidence_type": null,
  "notes": "[gap addressed or topic covered]"
}
```

## Example Output

For a Level 3 user with gap "CLAUDE.md missing test command":

```markdown
## CLAUDE.md Test Commands — Level 2 Gap

Your assessment shows Level 3 features (rules, imports) but your CLAUDE.md is missing test commands. This is a foundational gap — Claude can't verify its changes work.

### Key Concept

The `test` section in CLAUDE.md tells Claude how to run your test suite. Without it, Claude can't self-verify or catch regressions.

### In Your Environment

Your CLAUDE.md exists at project root (score 6/10). Add a test section:

```markdown
## Testing
npm test                    # Run all tests
npm test -- --watch         # Watch mode
npm run test:coverage       # Coverage report
```

### Do This Now

```markdown
<!-- Add to your CLAUDE.md -->
## Test Commands

Run tests with: `npm test`
Run a single file: `npm test -- src/utils.test.ts`
```

Add this to your `CLAUDE.md` so Claude runs the right test command instead of guessing.

### Why It Matters

Verification is the single biggest quality lever in Claude Code: give Claude a check it can run (tests, build, lint) and it closes its own loop instead of waiting for you to catch mistakes. Without an explicit test command Claude guesses how to run your suite; with this snippet it runs the real one and iterates until it passes.

### Resources

- [Claude Code Best Practices — Testing](https://www.anthropic.com/engineering/claude-code-best-practices)
```

## Avoid

- Teaching concepts above user's level
- Generic advice not grounded in their project
- Lessons over 400 words
- Repeating topics covered in last 3 outcomes
- Volunteering cost/token advice (it's opt-in via `/coach:cost`)
