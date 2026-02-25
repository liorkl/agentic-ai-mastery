<!--
topic: Productivity Tips
last_updated: February 2026
source_docs: curriculum-v1.1.md
curriculum_level: 1-3
-->

# Productivity Tips

## Current State

Most Claude Code users underutilize the tool — they write vague prompts,
let context balloon, switch tasks without clearing, and use expensive models
for trivial tasks. These habits compound: bad prompts → more back-and-forth →
more tokens → higher cost → slower results.

The tips here are ordered from highest to lowest impact.

## Key Concepts

### 1. Write Prompts That Constrain the Scope

The biggest productivity lever is prompt quality. Claude can't read your mind
and will fill ambiguity with assumptions.

**Weak prompt:**
```
fix the auth bug
```

**Strong prompt:**
```
The login test in src/auth/login.test.ts is failing with a 401 on line 42.
The handler is in src/auth/handler.ts. Fix only the token validation logic —
don't touch session management.
```

The strong prompt:
- Points to specific files
- Names the exact failure
- Scopes what NOT to touch

**Pattern: Scope = file + behavior + boundary**

---

### 2. Use Checkpoints — Undo is Your Safety Net

Before any destructive or uncertain change, note you can always roll back:

```
/undo        # Revert the last file edit
Esc          # Interrupt Claude mid-task
Esc Esc      # Revert all changes from current turn
```

This means you can say "try this approach" without fear. If it's wrong,
undo and try again. Treat Claude like an IDE with infinite undo.

---

### 3. Context Hygiene — Clean Between Tasks

Context is not free. Everything in the window costs tokens on every turn.

**Rule of thumb:**
- Switch topic → `/clear`
- Session feels slow or repetitive → `/compact`
- Starting a big task → `/clear` first

**What `/clear` keeps:** CLAUDE.md, installed skills, settings
**What `/clear` loses:** conversation history, file contents read this session

**What `/compact` does:** summarizes the conversation into ~500 tokens,
preserving key decisions and current state. Use when you need history
but context is filling up.

**Check your context health:**
```
/context
```
Shows a breakdown by source. If CLAUDE.md is consuming >20% of your budget,
it's too long — split it with `@imports`.

---

### 4. One Task Per Session (for complex work)

Claude Code works best when each session has a clear, singular goal.
Mixing tasks in one session creates confusion and bloated context.

**Anti-pattern:**
```
"Fix the auth bug, then add dark mode, then also update the README"
```

**Better:**
```
Session 1: Fix auth bug → /clear
Session 2: Add dark mode → /clear
Session 3: Update README
```

Use `/resume` to return to a previous session if you need to continue it.

---

### 5. Match Model to Task

Using Opus for everything wastes money on tasks Haiku handles fine.

| Task | Recommended Model | Why |
|------|------------------|-----|
| Simple edits, renaming, formatting | `haiku` | Fast, cheap, sufficient |
| Bug fixes, feature additions | `sonnet` | Good balance |
| Architecture, complex reasoning | `sonnet` or `opus` | Needs depth |
| Code review of large codebase | `sonnet` | Context handling |
| One-liner explanations | `haiku` | Overkill to use more |

Switch model mid-session:
```
/model haiku     # Switch to Haiku for current task
/model sonnet    # Switch back
```

**Cost ratio:** Haiku ≈ 1x, Sonnet ≈ 5x, Opus ≈ 15x

---

### 6. Use Sub-Agents for Parallel or Isolated Work

When you have independent tasks, run them in parallel with the Task tool:

```
"Research the best approach for A and research B simultaneously,
then report both before we proceed"
```

Sub-agents get their own context window — they don't pollute your session.
Use them for:
- Research tasks you don't want in your main context
- Parallel work (reviewing two files at once)
- Isolated, long-running operations

Each sub-agent costs tokens but prevents context bleed. For large tasks,
they're often cheaper than a polluted single session.

---

### 7. CLAUDE.md as Your Productivity Multiplier

Everything in CLAUDE.md is available to Claude at session start — for free
(you already paid for it, it's loaded once). Use it to:

- Pre-answer questions Claude would otherwise ask: "What test command?"
  "What's the deployment process?" "Which file handles auth?"
- Establish style rules you don't want to repeat: "Always use named exports."
- Set hard constraints: "Never modify migration files directly."

Every line in CLAUDE.md eliminates one prompt-and-answer turn per session.
At 50 sessions/month, a 10-line CLAUDE.md addition saves 500 prompt turns.

**Anti-pattern:** keeping CLAUDE.md sparse to "save tokens" — the opposite
is true. A good CLAUDE.md *saves* tokens by removing ambiguity.

---

### 8. Headless Claude for Repetitive Work

For tasks you run repeatedly (e.g., reviewing PRs, generating changelogs,
running migrations), don't do it interactively:

```bash
claude -p "Review the staged changes for security issues. Output JSON." \
  --output-format json

claude -p "Run the test suite and summarize failures" \
  --model haiku    # Use cheap model for routine tasks
```

Headless mode:
- No interactive back-and-forth
- Scriptable output (JSON, text)
- Can run in CI/CD pipelines
- Use `haiku` for cost efficiency

---

### 9. Iterative Over Comprehensive

Don't ask Claude to "build the entire feature" in one shot. Break it down:

1. "Scaffold the data model only"
2. Review → "Now add the API endpoint"
3. Review → "Now add validation"
4. Review → "Now write the tests"

Each step is small enough to review, test, and undo. Comprehensive asks
produce code you can't easily verify or roll back piece by piece.

**The compound win:** smaller steps = fewer errors = fewer fix cycles =
lower total cost.

---

### 10. Use `@filename` References in Prompts

Instead of describing a file, reference it directly:

```
Look at @src/auth/handler.ts and explain the token validation logic
```

Claude will read the file in context. This is more precise than
"the auth handler" and avoids Claude guessing the wrong file.

---

## Mastery Checks

- [ ] You write prompts with explicit file, behavior, and boundary scope
- [ ] You use `/clear` between unrelated tasks
- [ ] You know when to use `/compact` vs `/clear`
- [ ] You select model based on task complexity, not habit
- [ ] Your CLAUDE.md answers the questions Claude would otherwise ask
- [ ] You've tried headless mode for at least one repetitive task
- [ ] You break large features into reviewable steps

## Cost Implications

These tips stack:
- Right model selection: up to 15x cost reduction
- Context hygiene: 30-60% reduction on long sessions
- Targeted prompts: 50% fewer follow-up turns
- Headless for automation: eliminates interactive overhead

**Combined effect:** A developer applying all 10 tips typically spends
3-5x less on the same work vs. default usage patterns.

## Official Resources

- [Claude Code Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices)
- [Effective Prompting Guide](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/overview)
- [Model Selection Guide](https://docs.anthropic.com/en/docs/about-claude/models/overview)
- [Anthropic Academy — Prompt Engineering](https://anthropic.com/academy)
