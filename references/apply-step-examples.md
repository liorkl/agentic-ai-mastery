<!-- Reference for commands/apply.md. Not a command — read on demand. -->

# /coach:apply — Worked Step Presentations

Three fully worked examples of the step format `/coach:apply` presents. Read this when you
need the exact shape and tone; the command body carries the rules.

For gap: `No .claude/settings.json with deny rules` on the example project:

```markdown
---
## Step 1 of 4 — Create .claude/settings.json with Deny Rules

**Priority:** HIGH

### What You're Doing

Create `.claude/settings.json` in your the example project project with permission
rules that block Claude from reading credential files.

### Why This Matters

Claude's tools can read any file accessible on your filesystem. Right now,
a poorly-worded prompt (or an automated task) could cause Claude to read your
`.env`, include your database credentials in its context, and log them.
the example project has a `.env` file — this is not hypothetical risk.

### How to Implement

Create `<project-root>/.claude/settings.json`:

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

For a **config-backed practice** (`verification_ready: false`) on the example project:

```markdown
---
## Step 1 of 5 — Give Claude a Check It Can Run

**Priority:** CRITICAL

### What You're Doing

Add your project's real test/build/lint command to `CLAUDE.md` so Claude can
verify its own changes instead of waiting for you to catch mistakes.

### Why This Matters

This is the single biggest lever on output quality. Right now Claude finishes a
change and hands it back unchecked — you're the test runner. the example project has a
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
