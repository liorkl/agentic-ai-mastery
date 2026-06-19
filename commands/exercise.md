---
description: Get a hands-on exercise for your current skill level
---

# /coach:exercise — Hands-On Exercise

Provides a practical exercise the user can complete in their current project with clear success criteria.

## Execution Steps

### 1. Load State

```
Read ~/.claude/coaching/state/assessments.jsonl
  → Get the LAST entry (most recent assessment)
  → Extract: detected_level, gaps, features_detected, project_path

Read last 5 entries from ~/.claude/coaching/state/outcomes.jsonl
  → Check recent exercises given
  → Avoid repeating same exercise
```

### 2. Handle Missing Assessment

If assessments.jsonl doesn't exist or is empty:
- Tell user: "I need to understand your environment before giving exercises."
- Run: "Please run `/coach:assess` first, then come back with `/coach:exercise`."
- Exit

### 3. Select Exercise

**Priority order:**

1. **Gap-closing exercise** (if HIGH-priority gaps exist)
   - Exercise that directly addresses a gap
   - Example: "Create a CLAUDE.md with all 10 quality elements"

2. **Anti-pattern fix** (if severity MEDIUM+)
   - Exercise to fix the anti-pattern
   - Example: "Refactor your 200-line CLAUDE.md into rules/"

3. **Current level mastery exercise** (if no gaps)
   - Exercise at detected_level
   - Tests mastery criteria from curriculum

4. **Stretch exercise** (if current level mastered)
   - Preview exercise for next level
   - Marked as "stretch" — optional

### 4. Design Exercise

**Exercise components:**

| Component | Description |
|-----------|-------------|
| **Title** | Clear, action-oriented |
| **Context** | Why this exercise matters |
| **Task** | Exactly what to do (step-by-step) |
| **Success Criteria** | How they know it's done correctly |
| **Verification** | Command or check to confirm |
| **Time Estimate** | Rough effort level (not time — just complexity) |

### 5. Deliver Exercise

**Format:**

```markdown
## Exercise: [Title]

**Level:** [N] | **Focus:** [Topic] | **Effort:** [Low/Medium/High]

### Why This Matters

[1-2 sentences on relevance to their level/gaps]

### Your Task

[Step-by-step instructions]

1. [First step]
2. [Second step]
3. [Third step]

### Success Criteria

You've completed this exercise when:
- [ ] [Criterion 1]
- [ ] [Criterion 2]
- [ ] [Criterion 3]

### Verify

Run this to confirm:
```bash
[verification command]
```

Expected output: [what they should see]

### Hints

<details>
<summary>Stuck? Click for hints</summary>

[Helpful hints without giving away the answer]

</details>
```

### 6. Log Outcome

Append to `~/.claude/coaching/state/outcomes.jsonl`:

```json
{
  "timestamp": "[ISO timestamp]",
  "session_id": "exercise-[YYYYMMDD]",
  "user_level_at_time": [detected_level],
  "topic": "[feature area]",
  "subtopic": "[specific exercise]",
  "coaching_action": "exercised",
  "exercise_given": true,
  "applied": null,
  "evidence_type": null,
  "notes": "[exercise title]"
}
```

## Exercise Bank by Level

### Level 0-1: Getting Started

**Exercise: First CLAUDE.md**
- Create CLAUDE.md with project purpose, build command, test command
- Success: File exists with ≥3 sections
- Verify: `cat CLAUDE.md | head -20`

**Exercise: Model Selection**
- Use Haiku for a simple task, Sonnet for a complex one
- Success: Understand when to switch models
- Verify: Check `/context` after each

### Level 2-3: Context Engineering

**Exercise: Quality CLAUDE.md**
- Add all 10 quality elements to CLAUDE.md
- Success: Score 8+/10 on next assessment
- Verify: `/coach:assess`

**Exercise: Rules Extraction**
- Move DO NOT rules from CLAUDE.md to .claude/rules/
- Success: CLAUDE.md under 100 lines, rules/ has 3+ files
- Verify: `wc -l CLAUDE.md && ls .claude/rules/`

### Level 4: Skills

**Exercise: First Skill**
- Create a skill that auto-triggers on a pattern
- Success: Skill activates without explicit invocation
- Verify: Test the trigger phrase

### Level 5: Agents

**Exercise: Read-Only Reviewer**
- Create an agent with only Read, Glob, Grep tools
- Success: Agent can review but not modify files
- Verify: `/agent reviewer` on a file

### Level 6: Hooks

**Exercise: Lint Hook**
- Create PostToolUse hook that lints after Edit
- Success: Lint runs automatically on edits
- Verify: Make an edit, see lint output

### Level 7: MCP

**Exercise: Add MCP Server**
- Configure an MCP server for your workflow
- Success: Server shows in `/mcp list`
- Verify: Use a tool from the server

### Level 8: Headless

**Exercise: Headless PR Review**
- Run `claude -p` for automated code review
- Success: Review output in JSON format
- Verify: `claude -p "Review changes" --output-format json`

### Level 9: Teams

**Exercise: Two-Agent Task**
- Configure two agents that work on different modules
- Success: Parallel work without file conflicts
- Verify: Both agents produce results

## Avoid

- Exercises that require external setup (databases, APIs)
- Exercises above user's level
- Vague success criteria
- Exercises that take more than 30 minutes
- Same exercise given in last 5 outcomes
