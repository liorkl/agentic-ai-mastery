<!--
topic: Context Engineering
last_updated: February 2026
source_docs: curriculum-v1.1.md, cost-guide-v1.0.md
curriculum_level: L3
-->

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

**Keep CLAUDE.md under 150 lines** — it's loaded every session.

### @imports for Modular Context

Split large configs:

```markdown
# CLAUDE.md
@import .claude/rules/api-patterns.md
@import .claude/rules/testing.md
```

Rules files load contextually, cheaper than putting everything in CLAUDE.md.

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
- [ ] Is your CLAUDE.md under 150 lines?
- [ ] Do you use the commit-and-clear pattern?
- [ ] Can you explain context rot to a colleague?
- [ ] Have you set up context monitoring?

## Cost Implications

**Context is THE cost lever. Everything else is optimization at the margin.**

- A 100K context window at message 20 has cost 2M input tokens in history re-reads
- Auto-compaction kicks in at 95% — too late, you've overpaid for many messages
- Every line in CLAUDE.md is read on every message

**Cost impact of each CLAUDE.md section:**
- Architecture map: Prevents exploratory file-reading (saves thousands of tokens)
- Build/test commands: Prevents Claude guessing and failing (saves retry cycles)
- DO NOT patterns: Prevents the most wasteful reads

## Official Resources

- [Context Engineering for AI Agents (Anthropic)](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)
- [Claude Code Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices)
- [Using CLAUDE.md Files](https://claude.com/blog/using-claude-md-files)
