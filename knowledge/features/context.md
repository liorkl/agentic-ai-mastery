<!-- file: knowledge/features/context.md -->
<!-- last-updated: 2026-06-19 -->
<!-- source: https://code.claude.com/docs/en/best-practices -->
<!-- curriculum_level: L3 -->

# Context Engineering

## Current State

Context engineering is the most critical discipline in agentic AI development. Anthropic formally introduced it as the successor to prompt engineering in September 2025.

**Definition**: The set of strategies for curating and maintaining the optimal set of tokens during LLM inference.

**Why it matters**: LLM performance degrades as context fills — a phenomenon called **context rot**. Every token introduced depletes an "attention budget."

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

**The Explore subagent**: Use for read-only codebase discovery without polluting your main context.

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
