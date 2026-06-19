<!-- file: knowledge/features/headless.md -->
<!-- last-updated: 2026-06-19 -->
<!-- source: https://code.claude.com/docs/en/best-practices -->
<!-- curriculum_level: L8 -->

# Headless Mode & Harness Pattern

## Current State

Headless mode runs Claude Code programmatically. The harness pattern enables multi-session projects that span context window limits.

## Key Concepts

### Headless Mode Basics

```bash
# Non-interactive execution
claude -p "prompt"

# With output format
claude -p "prompt" --output-format json

# Streaming JSON output
claude -p "prompt" --output-format streaming-json

# With model selection
claude -p "prompt" --model haiku
```

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

### Claude Agent SDK

Renamed from Claude Code SDK (September 2025). Powers Claude Code but also non-coding agents.

**Capabilities**:
- Agent lifecycle management
- Tool registration
- State persistence
- Workflow orchestration
- Automatic compaction for long-running agents

**SDKs available**:
- Python
- TypeScript

**When to use SDK vs. headless mode**:
- Simple automation → Headless mode
- Complex agent workflows → SDK
- Building a product with agents → SDK

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
- [Agent SDK Documentation](https://docs.anthropic.com/en/docs/claude-code/sdk)
- [Autonomous Coding Quickstart](https://github.com/anthropics/claude-quickstarts/tree/main/autonomous-coding)
