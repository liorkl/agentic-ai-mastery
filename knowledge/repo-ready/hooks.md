<!-- file: knowledge/repo-ready/hooks.md -->
<!-- last-updated: 2026-09-03 -->
<!-- source: https://code.claude.com/docs/en/hooks -->
<!-- curriculum_level: L6 -->

# Hooks System

## Current State

Hooks are scripts that run on specific lifecycle events, **outside** the agentic loop. They're deterministic code (shell scripts, Python) that enforces rules without LLM judgment.

**The critical distinction**: Hooks are reliable because they don't involve AI. Zero tokens consumed.

## Key Concepts

### Hook Events

There are ~33 hook events. These are the ones you'll reach for first:

| Event | When It Fires | Use Cases |
|-------|--------------|-----------|
| `PreToolUse` | Before a tool call executes | Intercept, block, protect paths |
| `PostToolUse` | After a tool call succeeds | Validate, log, alert |
| `Stop` | When Claude finishes responding | Verification gate (test/build/lint) |
| `SessionStart` | When a session begins or resumes | Load context, set up state |
| `UserPromptSubmit` | When you submit a prompt, before Claude processes it | Inject context, pre-flight checks |
| `PermissionRequest` | When a tool call needs a permission decision | Custom auto-approve / auto-deny |
| `InstructionsLoaded` | When a CLAUDE.md or `.claude/rules/*.md` file loads | Debug which instructions actually loaded |

Others cover subagents (`SubagentStart`, `SubagentStop`), tasks (`TaskCreated`, `TaskCompleted`), compaction (`PreCompact`, `PostCompact`), failures (`PostToolUseFailure`, `StopFailure`), and more. For the full event list and payload schemas, see the [hooks docs](https://code.claude.com/docs/en/hooks).

### Configuration

Hooks are configured in `.claude/settings.json` or `.claude/settings.local.json`. Each event maps to a list of **matcher groups**, and each group holds a nested `hooks` array — the nesting is required:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "python .claude/hooks/block-secrets.py"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Edit",
        "hooks": [
          { "type": "command", "command": ".claude/hooks/lint-changed.sh" }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "npm test --silent",
            "timeout": 120
          }
        ]
      }
    ]
  }
}
```

A flat `{"matcher": "Edit", "command": "..."}` — without the inner `hooks` array — is **not** a valid hook and silently never fires. Optional per-hook fields include `timeout` (seconds) and `statusMessage` (shown in the UI while it runs).

### How a Hook Receives Its Input

Command hooks get a **JSON object on stdin** — not positional arguments. Every event provides `session_id`, `cwd`, `permission_mode`, `hook_event_name`, and `transcript_path`; tool events add `tool_name` and `tool_input`.

```bash
input=$(cat)
file=$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty')
```

There is no `$1`. A hook that reads `"$1"` gets an empty string.

### Exit Codes

| Exit Code | Meaning | Behavior |
|-----------|---------|----------|
| 0 | Pass | Continue normally |
| 1 | Non-blocking error | Logged; **the action still proceeds** |
| 2 | Block | Blocks the action on events that support blocking |

**Exit code 2 is the blocker** — on `PreToolUse` it blocks the tool call, on `Stop` it prevents Claude from finishing, on `UserPromptSubmit` it blocks the prompt. stderr is fed back to Claude as the reason.

Exit code 1 does **not** block. A guardrail written with `exit 1` prints a warning and lets the operation through.

Blocking is also expressible as structured JSON on stdout, which gives you a reason string:

```json
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "Potential secret in the proposed edit"
  }
}
```

Other useful output fields: `additionalContext` (inject into Claude's context), `updatedInput` (rewrite the tool input), `systemMessage` (show a note in the transcript).

### Essential Hook Patterns

**Guardrail hook (security)** — a `PreToolUse` hook that blocks a secret before the write lands. It inspects the *proposed* content from `tool_input`, because the file on disk doesn't have the change yet:

```bash
#!/bin/bash
# PreToolUse, matcher: Edit|Write
input=$(cat)
payload=$(printf '%s' "$input" | jq -r '[.tool_input.content, .tool_input.new_string] | map(select(.)) | join("\n")')

if printf '%s' "$payload" | grep -qE '(API_KEY|SECRET|PASSWORD|TOKEN)='; then
  echo "Blocked: potential secret in the proposed edit" >&2
  exit 2
fi
exit 0
```

This is the deterministic complement to permission rules. For the broader permissions / deny-rule model (which tools and paths are allowed at all), see `knowledge/personal-env/permissions.md` — hooks add custom logic on top of it rather than replacing it.

**Quality hook** — auto-lint after edits:

```bash
#!/bin/bash
# PostToolUse, matcher: Edit
input=$(cat)
file=$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty')
[ -n "$file" ] || exit 0
npx eslint --fix "$file" 2>/dev/null
exit 0
```

**Verification gate (the #1 practice, made deterministic)** — a `Stop` hook that runs the project's test/build/lint before Claude can finish is THE way to enforce verification automatically. It closes the loop unattended: Claude cannot declare done while the suite is red, and exit code 2 blocks the stop and feeds the failure straight back for correction.

```bash
#!/bin/bash
# Stop hook
if ! npm test --silent; then
  echo "Tests failed. Fix before completing." >&2
  exit 2   # blocks the stop and sends the reason back to Claude
fi
exit 0
```

### Writing Production Hooks

**Keep hooks fast** — they block the workflow. Set an explicit `timeout`.

**Avoid context pollution**:
- Verbose hook output adds to context
- Use `--quiet` flags
- Only output what Claude needs to see

**Test independently** — feed the hook the JSON it will actually receive:

```bash
echo '{"tool_name":"Edit","tool_input":{"file_path":"test.js","new_string":"x"}}' \
  | .claude/hooks/my-hook.sh
echo $?  # 0 = pass, 2 = block
```

**Typical hook size**: under 100 lines with clear comments.

### Caveat: Formatting Hooks

Automatic formatting hooks (prettier, black) can consume significant context tokens because:
1. Claude sees the "before" state
2. Hook modifies the file
3. Claude may re-read the "after" state

Consider running formatters only on `Stop`, not every `PostToolUse`.

## Mastery Checks

- [ ] Does your hook config use the nested `hooks: [{ type, command }]` shape?
- [ ] Have you implemented a security hook that blocks secrets with `exit 2`?
- [ ] Do you have a `Stop` verification gate (lint, test)?
- [ ] Does your hook read its input as JSON from stdin rather than `$1`?
- [ ] Have you tested your hooks independently by piping them JSON?

## Why It Matters

**Hooks are deterministic — that's the whole point.** They enforce rules with plain code, no LLM judgment, so a security or quality gate fires every single time instead of "usually."

**Reliability you can't get from prompting**:
- A `Stop` hook running the test/build/lint suite turns the #1 practice — verification — into something that fires every time, with no human in the loop
- A `PreToolUse` block on secrets or protected paths cannot be talked around or forgotten
- Exit code 2 blocks the action and feeds the reason back to Claude, turning a hook into an automatic correction loop

**The two failure modes that make a hook silently useless**: the flat config shape (no inner `hooks` array), and `exit 1` where you meant `exit 2`. Both look right and neither errors.

**Keep outputs minimal and actionable** — verbose hook output crowds the context and buries the one line Claude actually needs to act on.

## Official Resources

- [Claude Code Hooks reference](https://code.claude.com/docs/en/hooks)
- [Claude Code Hooks guide](https://code.claude.com/docs/en/hooks-guide)
