<!--
topic: Custom Agents
last_updated: February 2026
source_docs: curriculum-v1.1.md, cost-guide-v1.0.md
curriculum_level: L5
-->

# Custom Agents

## Current State

Custom agents are specialized AI team members you design. Each agent has its own context window, system prompt, tool access, permissions, model, and visual color.

**Key feature**: Automatic delegation — Claude routes tasks based on agent descriptions, like tool invocation.

## Key Concepts

### Agent Structure

Agents are markdown files with YAML frontmatter in `.claude/agents/`:

```markdown
---
name: reviewer
description: Reviews code for quality, security, and best practices. Read-only analysis.
model: haiku
tools:
  - Read
  - Glob
  - Grep
color: blue
---

# Code Reviewer Agent

## Role
You are a code reviewer focused on quality and security. You NEVER modify files.

## Process
1. Read the files specified
2. Check against project standards
3. Identify issues by severity
4. Report findings with line references

## Standards
- Security: OWASP Top 10
- Style: Project conventions in CLAUDE.md
- Performance: Flag O(n²) or worse

## Output Format
Structured report with:
- Summary
- Critical issues
- Warnings
- Suggestions
```

### Agent Design Principles

**One agent, one job**:
- Code reviewer ≠ code writer ≠ test writer
- Separation enables tool restrictions and model optimization

**Constrain tool access**:
- Read-only agents: `[Read, Glob, Grep]`
- Writers: add `[Write, Edit]`
- Executors: add `[Bash]`

**Model selection per agent**:
```yaml
model: haiku  # 90% of Sonnet's performance at 1/3 cost
```

### Built-in Subagents

| Agent | Purpose | Default Model |
|-------|---------|---------------|
| **Explore** | Fast, read-only codebase search | Sonnet |
| **Plan** | Research and analysis, no file changes | Sonnet |
| **General-purpose** | Default delegation target | Session model |

### Agent Locations

```
.claude/agents/          # Project-level agents
~/.claude/agents/        # User-level agents
```

### Creating Agents

**1. Generate with Claude (recommended)**
```
/agents → Create new agent → Generate with Claude
```

**2. Manual creation**
Create `.claude/agents/name.md` with frontmatter + system prompt.

### Essential Starter Set

| Agent | Role | Model | Tools |
|-------|------|-------|-------|
| Reviewer | Read-only code analysis | Haiku | Read, Glob, Grep |
| Planner | Architecture and design | Opus | Read, Glob, Grep |
| Implementer | Code writing | Sonnet | All |
| Tester | Test writing and running | Sonnet | All |

### Subagent Patterns

**Task delegation**: Claude invokes agents automatically based on description matching.

**Explicit invocation**: `/agent reviewer`

**Fan-out**: Multiple agents working on different aspects simultaneously.

**Builder-Validator**: Implementation agent + read-only validation agent.

**Context isolation**: Subagents don't inherit parent conversation history.

### Auto-Delegation

For reliable auto-delegation:
- Write clear, specific descriptions
- Include trigger keywords
- Specify what the agent does AND doesn't do

```yaml
description: Reviews Python code for PEP-8 compliance, type hints, and security issues. Does NOT modify files or write code.
```

## Mastery Checks

- [ ] Have you created a custom agent with tool restrictions?
- [ ] Do your agents specify appropriate models (Haiku for simple tasks)?
- [ ] Can you explain when auto-delegation will trigger?
- [ ] Have you used the Builder-Validator pattern?

## Cost Implications

**Every agent gets its own context window** — including system prompt, CLAUDE.md, tool definitions.

**Agent spin-up has fixed initialization cost**:
- An agent that runs for one message and exits wasted most tokens on setup
- Design agents for sustained work, not one-shot questions

**Model selection matters**:
- Agents without `model:` field default to session model
- Haiku agents cost 1/3 of Sonnet agents per token

**Tool restrictions prevent expensive operations**:
- Read-only agents can't accidentally trigger costly write/execute operations

## Official Resources

- [Create Custom Subagents](https://code.claude.com/docs/en/sub-agents)
- [Anthropic Academy: Claude Code in Action](https://anthropic.skilljar.com/claude-code-in-action) (free, certificate)
