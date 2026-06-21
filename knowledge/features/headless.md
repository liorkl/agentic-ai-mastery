<!-- file: knowledge/features/headless.md -->
<!-- last-updated: 2026-06-21 -->
<!-- source: https://code.claude.com/docs/en/best-practices -->
<!-- curriculum_level: L8 -->

# Headless Mode & Harness Pattern

## Current State

Headless mode runs Claude Code programmatically. The harness pattern enables multi-session projects that span context window limits.

## Key Concepts

### Headless Mode Basics

```bash
# One-off, non-interactive execution (also: --print)
claude -p "prompt"

# Output format: text (default) | json | stream-json
claude -p "prompt" --output-format text
claude -p "prompt" --output-format json

# Newline-delimited JSON for real-time streaming
claude -p "prompt" --output-format stream-json --verbose

# With model selection
claude -p "prompt" --model haiku

# Scope which tools Claude may use without prompting
claude -p "prompt" --allowedTools "Read,Edit,Bash"
```

`text` prints plain text; `json` wraps the result with session ID and metadata
(the text is in the `result` field); `stream-json` emits one JSON event per line
as tokens are produced. Pipe data in over stdin like any CLI tool:
`cat build.log | claude -p "explain this error" > out.txt`.

### CI/CD Integration Patterns

**PR Review Bot**:
```yaml
# .github/workflows/review.yml
- name: Claude Code Review
  run: |
    claude -p "Review this PR for security issues and code quality. Files: $(git diff --name-only origin/main)"
```

**Automated Test Generation**:
```bash
claude -p "Generate tests for src/new-feature.ts based on existing test patterns"
```

**Documentation Sync**:
```bash
claude -p "Update README.md to reflect changes in src/api/"
```

**Release Notes**:
```bash
claude -p "Generate release notes from commits since last tag: $(git log --oneline v1.0.0..HEAD)"
```

### The Harness Pattern (November 2025)

**The problem**: Complex projects can't be completed in one context window.

**The solution**: Structured handoffs between sessions, like shift changes between engineers.

#### Components

**1. Initializer Agent** (first session):
- Sets up environment (`init.sh`)
- Creates feature list (JSON, not Markdown)
- Creates progress file (`claude-progress.txt`)
- Makes initial git commit

**2. Coding Agent** (every subsequent session):
- Reads progress file
- Makes incremental progress on one feature
- Updates progress file
- Commits with descriptive message
- Leaves codebase in merge-ready state

**3. Progress File** (`claude-progress.txt`):
```
## Session 3 — 2026-02-22

### Completed
- Implemented user authentication
- Added JWT token validation

### Current Focus
- Working on password reset flow

### Blockers
- None

### Next Session Should
- Complete password reset
- Add email verification
```

**4. Feature List** (JSON format):
```json
{
  "features": [
    {"name": "user-auth", "status": "complete", "tests": "passing"},
    {"name": "password-reset", "status": "in-progress", "tests": "none"},
    {"name": "email-verification", "status": "pending", "tests": "none"}
  ]
}
```

**Why JSON?**: Less likely to be improperly modified than Markdown.

#### Key Principles

**Incremental progress**: One feature at a time.

**Clean state**: Every session ends merge-ready.

**Descriptive commits**: Future sessions learn from commit messages.

**Progress file as context**: Cheapest possible inter-session state transfer.

### Scheduled and Autonomous Runs

You don't have to invoke every run by hand. Three concept-level options:

- **Scheduled cloud agents ("Routines")** — run a prompt on a cron schedule in
  the cloud, unattended.
- **Desktop scheduled tasks** — schedule a run on your machine.
- **`/loop`** — repeat a prompt (or slash command) on an interval *within a
  session*; omit the interval to let Claude self-pace.

Exact invocation varies by surface and changes over time — check the docs rather
than memorizing flags. Anything scheduled or looping runs unattended, so it
**must** carry a verification gate (see the fan-out pattern below).

### Fan-Out Pattern

When the same task applies across many items (files, packages, services), loop
over the list and call `claude -p` once per item, with the tool scope restricted
to just what that item needs:

```bash
# Restrict tools per item; pre-approve only what's required
for f in $(git diff --name-only origin/main); do
  claude -p "Add a missing JSDoc comment to the exported functions in $f" \
    --allowedTools "Read,Edit"
done
```

Each invocation gets a fresh, focused context (no cross-item bleed) and can be
parallelized. For unattended safety, pair the restricted `--allowedTools` scope
with the `dontAsk` permission mode, which denies anything not in your
`permissions.allow` rules so a stray action aborts the run instead of hanging on
a prompt. See `knowledge/features/permissions.md` for how the permission modes
and allow/deny rules work — don't duplicate them here.

**Every fan-out run needs a verification gate.** Unattended automation has no
human watching, so give Claude a check it can run itself — a test, a linter, a
type-check, a schema validation — and make passing it the bar for "done." Without
a gate, a fan-out silently propagates the same mistake across every item.

### Claude Agent SDK (formerly the Claude Code SDK)

The **Claude Agent SDK** (renamed from the Claude Code SDK) exposes the same
building blocks that power the Claude Code CLI — tools, hooks, subagents, MCP,
permissions, and session management — for programmatic and embedded use (CI,
custom apps, services). It supports streaming JSON output and structured outputs.

**Capabilities**:
- Same agent loop, tools, and context management as the CLI
- Tool registration, hooks, subagents, MCP servers
- Permission modes and tool-approval callbacks
- Session management and state persistence
- Automatic compaction for long-running agents

**SDKs available**:
- Python
- TypeScript

**When to use SDK vs. headless mode**:
- Simple scripting/CI → headless mode (`claude -p`)
- Complex agent workflows, structured outputs, native message objects → SDK
- Embedding agents in a product or service → SDK

## Mastery Checks

- [ ] Have you used headless mode for a CI/CD task?
- [ ] Can you implement the harness pattern for a multi-session project?
- [ ] Do you set `max_turns` and `timeout_minutes` in automated runs?
- [ ] Have you used a progress file for session continuity?

## Why It Matters

**The harness pattern is what makes long projects actually finish.** It survives context limits by handing off clean, structured state between sessions instead of trying to cram everything into one window.

**Why it produces better results**:
- Each session starts with a clean context, so reasoning stays focused on the current feature
- The progress file carries just-enough continuity — the key decisions and next steps, not the noise of a full transcript
- Git commits as session boundaries keep the codebase merge-ready at every handoff

**Guardrails make automation safe and predictable**:
```bash
# Always set limits so an automated run can't loop indefinitely
claude -p "..." --max-turns 20 --timeout-minutes 30
```

Without `--max-turns`/`--timeout-minutes`, an unattended agent can loop on a stuck task with no one watching.

(For the token/cost angle, use the opt-in `/coach:cost` command.)

## Official Resources

- [Effective Harnesses for Long-Running Agents](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)
- [Run Claude Code Programmatically (Headless)](https://code.claude.com/docs/en/headless)
- [Claude Agent SDK Documentation](https://docs.claude.com/en/docs/agent-sdk/overview)
- [Permission Modes](https://code.claude.com/docs/en/permission-modes)
- [Autonomous Coding Quickstart](https://github.com/anthropics/claude-quickstarts/tree/main/autonomous-coding)
