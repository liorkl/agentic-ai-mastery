<!-- file: knowledge/features/context.md -->
<!-- last-updated: 2026-06-21 -->
<!-- source: https://code.claude.com/docs/en/best-practices -->
<!-- curriculum_level: L2 -->

# Context Engineering

## Current State

Context engineering is the most critical discipline in agentic AI development. Anthropic formally introduced it as the successor to prompt engineering in September 2025.

**Definition**: The set of strategies for curating and maintaining the optimal set of tokens during LLM inference.

**Why it matters**: The context window is the fundamental constraint, and it fills fast. LLM performance degrades as context fills — a phenomenon called **context rot** — because the model has a limited attention budget and every token introduced depletes it. This single fact is the root reason behind most Claude Code best practices: `/clear`, `/compact`, subagents, and lean CLAUDE.md files all exist to keep the working context small and relevant.

## Key Concepts

### What Goes Into Context

Every message includes:
- System prompt
- CLAUDE.md content
- Conversation history
- Files read
- Tool results
- MCP tool definitions

### The n² Attention Problem

Every token attends to every other token. A 100K context window means 10 billion attention computations per message. Performance AND accuracy degrade past ~50% context fill.

### Context Hygiene Commands

```bash
# Clear context completely (most important habit)
/clear

# Automatic summarization when approaching limits
/compact

# Custom compaction with focus
/compact Focus only on the API endpoints and test results

# Save conversation before clearing
/rename "auth-refactor-session"
/clear

# Resume a saved conversation
/resume
```

### When to /clear vs /compact

| Situation | Action | Why |
|-----------|--------|-----|
| Switching to unrelated task | `/clear` | Zero wasted tokens |
| Long session, same task | `/compact` | Preserves essential context |
| After completing sub-task | `/clear` + git commit | Clean slate, work saved |
| Debugging going in circles | `/clear` + fresh prompt | Stale wrong-turns waste tokens |

### The Commit-and-Clear Pattern

The single most cost-effective workflow habit:

```
1. Work on a focused task
2. Git commit when done
3. /clear
4. Start next task with fresh context
```

### Checkpoints & Rewind (Safe Exploration)

Claude Code takes an automatic **checkpoint at each user prompt**, so you can always get back to an earlier state.

- **`/rewind`** opens a menu to restore to a previous checkpoint. You can restore the **code**, the **conversation**, or **both** — independently — and you can choose to summarize the work from or up to a chosen point.
- **`Esc` then `Esc`** interrupts a run in progress so you can change course before things go further off track.

Two ways to use it:

- **Beginner — safe exploration**: Checkpoints let you try bold edits without fear. If an approach doesn't pan out, roll back cleanly and try again. Experiment first, undo later.
- **Course correction**: When the context has gotten polluted — Claude went down a wrong path, the conversation is full of dead ends — the high-leverage move is to **stop and rewind rather than fight a degraded context**. Restoring the conversation to a clean point removes the wrong turns from the attention budget, which is faster and more reliable than arguing your way out.

Limits to know:

- Checkpoints persist for **~30 days**, then expire. They are **not a git replacement** — keep committing.
- Only edits made through Claude's **Read/Write/Edit tools** are tracked. Files changed by **raw bash** commands (e.g. `sed`, redirects, `mv`) are **not** captured by a rewind.

### CLAUDE.md Best Practices

```markdown
# CLAUDE.md cost-relevant sections

## Architecture
- Frontend: src/frontend/ (React, TypeScript)
- Backend: src/api/ (Node.js, Express)
- DO NOT read: node_modules/, dist/, .next/, coverage/

## Commands
- Build: npm run build
- Test: npm test
- Lint: npm run lint

## Conventions
- All API responses use ResponseWrapper from src/types/api.ts
- Do NOT create new utility files — check src/utils/ first
```

**Keep CLAUDE.md short** (a good rule of thumb is under ~150 lines) — it's loaded every session. For each line, ask: *"Would removing this cause Claude to make a mistake?"* If not, cut it. Bloated CLAUDE.md files cause Claude to **ignore** your actual instructions. Domain knowledge or workflows that only matter sometimes belong in **skills**, which load on demand, not in CLAUDE.md.

### @imports for Modular Context

CLAUDE.md can pull in other files with the `@path/to/file` syntax (no `@import` keyword):

```markdown
# CLAUDE.md
See @README.md for project overview.
- Git workflow: @.claude/rules/git-instructions.md
- Testing: @.claude/rules/testing.md
```

This keeps the always-loaded file lean while detail lives in files that are pulled in when relevant.

### Strategic Context Loading

**Just-in-time retrieval** vs. upfront loading:
- Don't front-load entire codebases
- Maintain lightweight identifiers (paths, links)
- Load details only when the task requires them

**Subagents keep the main thread small**: Delegate investigation and read-only codebase discovery to a subagent (e.g. the Explore agent). The subagent burns its own context window reading files and returns only the conclusion, so the main thread stays lean — the same root goal as `/clear` and `/compact`. For *parallel* isolated work on separate branches, see git worktrees in `knowledge/features/teams.md`.

### Monitoring Context

```bash
# Check what's consuming context
/context

# Custom status line showing context usage
# Configure in settings
```

## Mastery Checks

- [ ] Do you /clear between unrelated tasks?
- [ ] Is your CLAUDE.md short and free of lines Claude already knows?
- [ ] Do you use the commit-and-clear pattern?
- [ ] Can you explain context rot to a colleague?
- [ ] Have you set up context monitoring?
- [ ] Do you reach for `/rewind` to course-correct instead of fighting a polluted context?

## Why It Matters

**Context is the fundamental constraint — managing it well is the difference between a session you watch and one Claude can finish on its own.** As context fills, Claude starts forgetting earlier instructions and making more mistakes (context rot). A focused CLAUDE.md and aggressive `/clear` keep Claude's attention on what's relevant:

- A lean CLAUDE.md means Claude actually follows it — an overlong one gets half-ignored.
- Architecture map: lets Claude orient without reading half the repo.
- Build/test commands: Claude runs the real check instead of guessing.
- DO NOT patterns: steer Claude away from the wrong files.

(If you want the token/cost angle specifically, that's the opt-in `/coach:cost` command.)

## Official Resources

- [Context Engineering for AI Agents (Anthropic)](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)
- [Claude Code Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices)
- [Using CLAUDE.md Files](https://claude.com/blog/using-claude-md-files)
- [Claude Code docs (checkpoints, /rewind, context commands)](https://code.claude.com/docs/en/)
