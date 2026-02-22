<!--
topic: Hooks System
last_updated: February 2026
source_docs: curriculum-v1.1.md, cost-guide-v1.0.md
curriculum_level: L6
-->

# Hooks System

## Current State

Hooks are scripts that run on specific lifecycle events, **outside** the agentic loop. They're deterministic code (shell scripts, Python) that enforces rules without LLM judgment.

**The critical distinction**: Hooks are reliable because they don't involve AI. Zero tokens consumed.

## Key Concepts

### Hook Events

| Event | When It Fires | Use Cases |
|-------|--------------|-----------|
| `PreToolUse` | Before Claude uses a tool | Intercept, modify, block |
| `PostToolUse` | After Claude uses a tool | Validate, log, alert |
| `Stop` | When Claude finishes responding | Quality checks |
| `TeammateIdle` | When a team member finishes (L9) | Reassign, redirect |
| `TaskCompleted` | When a task is marked done (L9) | Gate on tests, lint |

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

**Security hook** — Block secrets:
```bash
#!/bin/bash
# PreToolUse hook for Edit/Write
if grep -E "(API_KEY|SECRET|PASSWORD)=" "$1"; then
  echo "Blocked: potential secret in file"
  exit 1
fi
exit 0
```

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

**Test gate hook** — Require tests before complete:
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

## Cost Implications

**Hooks run OUTSIDE the agentic loop** — zero token cost for the hook itself.

**Hooks as cost protection**:
- PreToolUse can block expensive operations before they happen
- Quality gates prevent expensive rework cycles
- Cost monitoring hooks can alert at thresholds

**The ROI calculation**:
- A $0 lint hook that catches errors saves the $0.50 round-trip of Claude fixing them
- Test hooks that fail early prevent hours of debugging later

**Context pollution warning**:
- Hooks that produce verbose output still add to context
- Keep hook outputs minimal and actionable

## Official Resources

- [Skills and Hooks Starter Kit](https://github.com/DavidROliverBA/Daves-Claude-Code-Skills)
- [Claude Code Best Practices — Hooks section](https://www.anthropic.com/engineering/claude-code-best-practices)
