<!--
topic: Claude Code CLI Orientation
last_updated: February 2026
source_docs: curriculum-v1.1.md
curriculum_level: 0-1
-->

# Claude Code CLI — Orientation

## Current State

Claude Code is Anthropic's official CLI for working with Claude as an
interactive coding agent. It runs in your terminal and gives Claude the
ability to act — read files, edit code, run commands, search the web — not
just generate text.

## Mental Model

Claude Code is an **agentic loop**: you give a goal, Claude plans a sequence
of tool calls, executes them, observes results, and continues until the goal
is met or it needs your input.

```
You → Prompt → Claude
                ↓
           Tool calls (Read, Edit, Bash, Grep...)
                ↓
           Observe result
                ↓
           Continue or ask you
                ↓
         Final response → You
```

The key difference from a chatbot: Claude **acts** on your codebase, it
doesn't just talk about it.

## Key Concepts

### Sessions and Context

Each Claude Code session has a **context window** — the total tokens Claude
can hold in memory at once. This includes:

- CLAUDE.md (always loaded)
- Conversation history
- File contents read during the session
- Tool outputs

When context fills up, use `/compact` to summarize and continue, or `/clear`
to start fresh (keeps CLAUDE.md, loses conversation).

**Cost implication:** Every token in context costs money on every request.
A bloated CLAUDE.md or large file read early in a session multiplies cost
across all subsequent turns.

### CLAUDE.md — Your Instruction File

Claude reads `CLAUDE.md` at the start of every session. It's your standing
instructions: project structure, tech stack, conventions, build commands, test
commands, constraints.

```
project/
└── CLAUDE.md          ← loaded automatically, every session
└── .claude/
    ├── settings.json  ← permissions, model config
    └── agents/        ← custom sub-agents
```

Without a CLAUDE.md, Claude starts each session with zero project context and
has to rediscover everything.

### Tools — How Claude Acts

Claude uses tools to take action. Each tool call is visible to you and
requires permission (automatic or prompted):

| Tool | What it does |
|------|-------------|
| **Read** | Reads a file |
| **Edit / Write** | Modifies or creates files |
| **Bash** | Runs shell commands |
| **Glob** | Finds files by pattern |
| **Grep** | Searches file contents |
| **WebFetch** | Fetches a URL |
| **WebSearch** | Searches the internet |
| **Task** | Spawns a sub-agent for complex/parallel work |

### Permission Model

You control what Claude can access. Rules live in `.claude/settings.json`:

```json
{
  "permissions": {
    "allow": ["Bash(npm test)", "Bash(npm run build)"],
    "deny": ["Read(.env*)", "Bash(rm -rf *)"]
  }
}
```

`deny` rules are evaluated first. Without them, Claude can read any file
your terminal user can access — including `.env` and credential files.

## Core Interaction Flows

### 1. Explore and Understand

"Explain how the auth flow works"

Claude reads relevant files, traces the logic, explains it. No changes made.
Use this to understand unfamiliar code before touching it.

### 2. Build a Feature

"Add email verification to the signup flow"

Claude reads existing code → plans changes → edits files → runs tests →
reports results. You review diffs along the way.

### 3. Debug an Issue

"The login test is failing with a 401 — fix it"

Claude reads the test, the code, and error output → identifies root cause →
proposes a fix → applies it → reruns the test to verify.

### 4. Review and Improve

"Review the payment module for security issues"

Claude reads the files, applies security heuristics, flags issues with
specific file:line references.

### 5. Automate (Headless)

```bash
claude -p "run the test suite and report failures" --output-format json
```

No interactive session — Claude runs, completes the task, exits. Useful for
CI pipelines or scripted workflows.

## Essential Commands

| Command | What it does |
|---------|-------------|
| `/help` | List available commands and installed skills |
| `/clear` | Reset conversation (keeps CLAUDE.md) |
| `/compact` | Summarize conversation to free context |
| `/undo` | Revert the last file edit |
| `/status` | Show current context usage |
| `/model` | Switch the active model |

See `knowledge/commands/commands-ref.md` for the complete reference.

## Mastery Checks

- [ ] You understand why CLAUDE.md loads on every session (not just once)
- [ ] You can explain what happens when context fills up and your two options
- [ ] You know the difference between `allow` and `deny` rules
- [ ] You've run `/clear` and understand what it resets vs. what it keeps
- [ ] You can name 3 core interaction flows and when to use each

## Cost Implications

- Starting a session costs ~0 tokens (context is empty)
- Every tool result and message adds to context — it compounds
- `/compact` costs ~500-1000 tokens but saves thousands on long sessions
- Running Claude headless on simple tasks: use `haiku` (10x cheaper than Opus)
- The biggest cost multiplier: a large CLAUDE.md loaded on every single turn

## Official Resources

- [Claude Code Overview](https://docs.anthropic.com/en/docs/claude-code/overview)
- [Quickstart Guide](https://docs.anthropic.com/en/docs/claude-code/quickstart)
- [Claude Code Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices)
- [Anthropic Academy — Intro to Claude Code](https://anthropic.com/academy)
