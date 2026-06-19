<!-- file: knowledge/features/productivity-tips.md -->
<!-- last-updated: 2026-06-19 -->
<!-- source: https://code.claude.com/docs/en/best-practices -->
<!-- curriculum_level: 1-3 -->

# Cross-Cutting Practices (How to Get the Best Out of Claude)

## Current State

These are the habits that decide whether Claude does great work or mediocre work — independent of which features you've installed. They apply at every level. The list is ordered by leverage: get the top ones right and everything downstream improves.

## Key Concepts

### 1. Give Claude a Way to Verify Its Work — the #1 Lever

Claude stops when the work *looks* done. Without a check it can run, "looks done" is the only signal — and you become the verification loop, catching every mistake by hand. Give Claude something that returns pass/fail and the loop closes on its own: it does the work, runs the check, reads the result, and iterates until it passes.

A check is anything that returns a signal Claude can read: a test suite, a build, a linter, a script that diffs output against a fixture, a browser screenshot compared to a design.

**Weak:**
```
implement a function that validates email addresses
```
**Strong:**
```
write a validateEmail function. test cases: user@example.com → true,
"invalid" → false, user@.com → false. run the tests after implementing
and fix until they pass.
```

Three ways to make the check bite, in increasing strength:
- **In the prompt** — "run the tests and iterate until they pass" (works today, any task).
- **Across a session** — set the check as a `/goal` condition; an evaluator re-checks after every turn.
- **As a hard gate** — a `Stop` hook runs the check as a script and blocks the turn from ending until it passes.

Have Claude show evidence (the test output, the command and its result) rather than asserting success.

**This is the practice to fix first.** A repo with no command Claude can run to check itself is the highest-leverage thing to address, at any level.

---

### 2. Explore → Plan → Code

Letting Claude jump straight to code produces code that solves the wrong problem. Separate research from execution:

1. **Explore** (plan mode) — "read /src/auth and explain how sessions work." No edits.
2. **Plan** — "I want to add Google OAuth. What changes? Write a plan." Edit the plan if needed.
3. **Code** — leave plan mode, "implement the plan, write tests, run them, fix failures."

Plan mode (`Shift+Tab` twice) is most valuable when the approach is uncertain, the change spans multiple files, or you don't know the code. Skip it for one-sentence changes — if you can describe the diff in a sentence, just ask.

For larger features, have Claude **interview you first**: "Interview me about this feature using AskUserQuestion, then write a spec to SPEC.md." Then execute the spec in a fresh session.

---

### 3. Ground the Prompt — File + Pattern + Symptom + Boundary

Claude can't read your mind; it fills ambiguity with assumptions. Precise instructions up front beat correction after.

**Weak:** `fix the auth bug`
**Strong:**
```
The login test in src/auth/login.test.ts fails with a 401 on line 42.
The handler is src/auth/handler.ts. Follow the pattern in src/auth/refresh.ts.
Fix only the token validation — don't touch session management.
```

The strong prompt: points at the file, points at an **example pattern to mirror**, names the exact symptom, and scopes what NOT to touch. Reference files with `@path` so Claude reads them instead of guessing.

---

### 4. Course-Correct Early

The best results come from tight feedback loops. Correct Claude the moment it drifts:

- **`Esc`** — stop mid-action; context is preserved, redirect.
- **`Esc Esc` / `/rewind`** — restore a previous conversation/code checkpoint.
- **`/clear`** — reset between unrelated tasks.

If you've corrected Claude more than twice on the same issue, the context is polluted with failed attempts. **`/clear` and start fresh with a better prompt** that bakes in what you learned — a clean session almost always beats a long one full of dead ends.

---

### 5. Manage Context

Performance degrades as the context window fills (Claude starts forgetting earlier instructions). Keep it lean:

- Switch topic → `/clear` (keeps CLAUDE.md, skills, settings; drops conversation + files read).
- Long session, need history → `/compact` (summarizes, preserving key decisions).
- Check health → `/context`. If CLAUDE.md is eating a large share of the budget, it's too long — trim it or split with `@imports`.
- Use **subagents for investigation** ("use a subagent to find how token refresh works") so the exploration doesn't fill your main thread.

---

### 6. Iterate, Don't One-Shot

Don't ask Claude to "build the entire feature" at once. Scaffold → review → add endpoint → review → add validation → review → tests. Each step is small enough to verify and undo, so fewer errors reach the codebase.

---

### 7. Match the Model to the Task

| Task | Model |
|------|-------|
| Simple edits, renaming, formatting, one-liners | `haiku` |
| Bug fixes, feature work, most daily coding | `sonnet` |
| Architecture, complex reasoning, hard debugging, long autonomous runs | `opus` (or `fable` for the hardest) |

Switch mid-session with `/model haiku` / `/model sonnet`. Tune depth with `effort` (low → max) rather than looking for a thinking-token budget. (Cost angle: the opt-in `/coach:cost`.)

---

### 8. Use a Fresh-Context Reviewer

A subagent reviewing the diff in a *fresh* context — seeing only the change and the criteria, not the reasoning that produced it — catches bugs the writing session is blind to. Run the bundled `/code-review` skill, or: "use a subagent to review this diff against PLAN.md; report gaps that affect correctness, not style."

---

### 9. CLAUDE.md Is the Foundation of a Claude-Ready Repo

Everything in CLAUDE.md is available to Claude at session start. A good one means a new teammate gets great results with zero verbal instructions. Put in it: the build/test/lint commands (so Claude can verify), the architecture, the conventions, a pointer to a good example file to mirror, and hard constraints. Keep it **short** — for each line ask "would removing this cause a mistake?"; a bloated CLAUDE.md gets half-ignored.

---

### 10. Headless for Repetitive Work

For things you run repeatedly (PR review, changelogs, migrations), don't do it interactively:

```bash
claude -p "Review the staged changes for security issues. Output JSON." --output-format json
```

Scriptable, runs in CI, and pairs naturally with verification gates.

---

## Mastery Checks

- [ ] Every repo you work in has a test/build/lint command Claude can run — and you ask it to
- [ ] You use plan mode (explore → plan → code) for multi-file or unfamiliar work
- [ ] Your prompts name the file, an example pattern, the symptom, and the boundary
- [ ] You `/clear` and re-prompt after two failed corrections instead of fighting context
- [ ] You delegate investigation and diff-review to subagents
- [ ] Your CLAUDE.md would let a new teammate get great output with no verbal hand-off

## Why It Matters

These habits compound. A check Claude can run turns a babysat session into one it finishes on its own. Planning stops it from solving the wrong problem. Grounded prompts get the right change on the first try. Course-correction and context hygiene keep answers accurate deep into long sessions. Together they are the difference between "Claude is hit or miss" and "Claude reliably does great work in our repo."

## Official Resources

- [Best practices for Claude Code](https://code.claude.com/docs/en/best-practices)
- [Effective Prompting Guide](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/overview)
- [Context Engineering for AI Agents](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)
