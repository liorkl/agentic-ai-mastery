<!-- file: knowledge/features/hooks.md -->
<!-- last-updated: 2026-06-21 -->
<!-- source: https://code.claude.com/docs/en/best-practices -->
<!-- curriculum_level: L6 -->

# Hooks System

## Current State

Hooks are scripts that run on specific lifecycle events, **outside** the agentic loop. They're deterministic code (shell scripts, Python) that enforces rules without LLM judgment.

**The critical distinction**: Hooks are reliable because they don't involve AI. Zero tokens consumed.

## Key Concepts

### Hook Events

Well-known lifecycle events you'll use most:

| Event | When It Fires | Use Cases |
|-------|--------------|-----------|
| `PreToolUse` | Before Claude uses a tool | Intercept, block, protect paths |
| `PostToolUse` | After Claude uses a tool | Validate, log, alert |
| `Stop` | When Claude finishes responding | Verification gate (test/build/lint) |
| `SessionStart` | When a session begins | Load context, set up state |
| `UserPromptSubmit` | When you submit a prompt | Inject context, pre-flight checks |

Task-oriented events (e.g. `TaskCompleted`) also exist for agent-team flows. For the full, current event list and payload schemas, see the [hooks docs](https://code.claude.com/docs/en/hooks).

### Configuration

Hooks are configured in `.claude/settings.json` or `.claude/settings.local.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit",
        "command": "python .claude/hooks/lint-before-edit.py"
      }
    ],
    "PostToolUse": [
      {
        "matcher": ".*",
        "command": ".claude/hooks/log-activity.sh"
      }
    ],
    "Stop": [
      {
        "command": "npm run lint -- --quiet"
      }
    ]
  }
}
```

### Exit Code Conventions

| Exit Code | Meaning | Behavior |
|-----------|---------|----------|
| 0 | Pass | Continue normally |
| 1 | Error | Block the operation |
| 2 | Feedback | Send hook's stdout back to Claude |

**Exit code 2 is powerful**: It sends the hook's output back as feedback, allowing deterministic corrections.

### Essential Hook Patterns

**Guardrail hook (security)** — A `PreToolUse` hook can block a dangerous command or protect a path *before* the tool runs:
```bash
#!/bin/bash
# PreToolUse hook for Edit/Write
if grep -E "(API_KEY|SECRET|PASSWORD)=" "$1"; then
  echo "Blocked: potential secret in file"
  exit 1
fi
exit 0
```

This is the deterministic complement to permission rules. For the broader permissions / deny-rule model (which tools and paths are allowed at all), see `knowledge/features/permissions.md` — hooks add custom logic on top of it rather than replacing it.

**Quality hook** — Auto-lint after edits:
```bash
#!/bin/bash
# PostToolUse hook for Edit
npx eslint --fix "$1" 2>/dev/null
exit 0
```

**Cost monitoring hook**:
```python
#!/usr/bin/env python3
# PostToolUse hook - track token usage
import json
import sys
# Read tool result, log cost estimate
# Alert if session exceeds budget
```

**Verification gate (the #1 practice, made deterministic)** — A `Stop` hook that runs the project's test/build/lint before Claude can finish is THE way to enforce verification automatically. It closes the loop unattended: Claude cannot declare done while the suite is red, and exit code 2 feeds the failure straight back for correction.
```bash
#!/bin/bash
# Stop hook
npm test --silent
if [ $? -ne 0 ]; then
  echo "Tests failed. Please fix before completing."
  exit 2  # Send feedback to Claude
fi
exit 0
```

### Writing Production Hooks

**Keep hooks fast** — They block the workflow.

**Avoid context pollution**:
- Verbose hook outputs add to context
- Use `--quiet` flags
- Only output what Claude needs to see

**Test independently**:
```bash
# Test hook directly
.claude/hooks/my-hook.sh test-file.js
echo $?  # Check exit code
```

**Typical hook size**: Under 100 lines with clear comments.

### Caveat: Formatting Hooks

Automatic formatting hooks (prettier, black) can consume significant context tokens because:
1. Claude sees the "before" state
2. Hook modifies the file
3. Claude may re-read the "after" state

Consider running formatters only on `Stop`, not every `PostToolUse`.

## Mastery Checks

- [ ] Have you implemented a security hook that blocks secrets?
- [ ] Do you have quality gate hooks (lint, test)?
- [ ] Do you understand the exit code 2 feedback pattern?
- [ ] Have you tested your hooks independently?

## Why It Matters

**Hooks are deterministic — that's the whole point.** They enforce rules with plain code, no LLM judgment, so a security or quality gate fires every single time instead of "usually."

**Reliability you can't get from prompting**:
- A `Stop` hook running the test/build/lint suite turns the #1 practice — verification — into something that fires every time, with no human in the loop
- A `PreToolUse` block on secrets or protected paths cannot be talked around or forgotten
- Exit code 2 feeds the failure back to Claude, turning a hook into an automatic correction loop

**Keep outputs minimal and actionable** — verbose hook output crowds the context and buries the one line Claude actually needs to act on.

(For the token/cost angle, use the opt-in `/coach:cost` command.)

## Official Resources

- [Claude Code Hooks documentation](https://code.claude.com/docs/en/hooks)
- [Claude Code Best Practices — Hooks section](https://www.anthropic.com/engineering/claude-code-best-practices)
