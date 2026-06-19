<!-- file: knowledge/features/skills.md -->
<!-- last-updated: 2026-06-19 -->
<!-- source: https://code.claude.com/docs/en/best-practices -->
<!-- curriculum_level: L4 -->

# Agent Skills

## Current State

Agent Skills are the **open standard** for reusable workflows, introduced December 2025. They work across Claude.ai, Claude Code, Cowork, and the API.

Skills replace the older slash commands approach (still supported) with a more powerful, portable system.

## Key Concepts

### Anatomy of a Skill

```
.claude/skills/
└── my-skill/
    ├── SKILL.md          # Required: name + description in frontmatter, instructions in body
    ├── templates/        # Optional: supporting files
    ├── examples/         # Optional: reference docs
    └── scripts/          # Optional: executable code
```

### SKILL.md Structure

```markdown
---
name: code-review
description: Performs thorough code review following team standards
---

# Code Review Skill

## When to Use
Invoke this skill when the user asks for code review, PR review, or quality feedback.

## Process
1. Read the files to be reviewed
2. Check against team standards in .claude/rules/code-standards.md
3. Identify issues by severity (critical, warning, suggestion)
4. Provide actionable feedback with line references

## Output Format
- Start with a summary
- List issues grouped by severity
- Include specific line references
- Suggest fixes where appropriate
```

### Progressive Disclosure Architecture

Skills use 3-level loading for context efficiency:

1. **Metadata** (startup): Name + description scanned, minimal tokens
2. **Core instructions** (on demand): SKILL.md body loaded when task matches
3. **Nested resources** (as needed): Supporting files loaded only when referenced

**Why this matters**: A 5,000-token skill loaded every session vs. 500 tokens at startup + 4,500 only when invoked.

### Skill Locations

```
.claude/skills/          # Project-level skills
~/.claude/skills/        # User-level skills (personal library)
```

### Built-in Skills

Claude has built-in skills for file creation:
- PDF generation
- DOCX generation
- XLSX generation
- PPTX generation

### Partner Skills

Pre-built integrations from:
- Atlassian (Jira, Confluence)
- Canva
- Figma
- Notion
- Cloudflare
- Stripe
- Zapier

### Creating Skills

Two approaches:

**1. Generate with Claude (recommended)**
```
/skills → Create new skill → Generate with Claude
```

**2. Manual creation**
Create SKILL.md with YAML frontmatter + markdown body.

### Skill Composition

Skills can:
- Invoke other skills
- Reference supporting documents
- Include executable code that runs without loading into context
- Be referenced by custom agents (L5) — the most powerful combination

**Skill → Agent wiring** is the natural next step after creating a skill. An agent's system prompt references the skill file directly, giving the agent a reusable, updateable workflow without duplicating logic:

```markdown
# Agent system prompt excerpt
When asked to review code, apply the instructions in
`.claude/skills/code-review/SKILL.md`.
```

A skill built at L4 becomes the workflow engine for one or more specialized agents at L5.

### Testing Skills

Use the `evals/` directory pattern:

```
.claude/skills/my-skill/
├── SKILL.md
└── evals/
    ├── test-case-1.md
    └── test-case-2.md
```

The skill-creator workflow: draft → eval → iterate → improve

## Mastery Checks

- [ ] Have you created a skill with progressive disclosure?
- [ ] Does your skill work in both Claude Code AND Claude.ai?
- [ ] Have you tested the skill with eval cases?
- [ ] Do you understand the metadata → body → resources loading pattern?

## Why It Matters

Progressive disclosure is what makes skills reliable, not just lean:
- **Loaded only when relevant**: the body enters context when the task matches, so Claude isn't distracted by instructions for unrelated work
- **Sharper triggering**: a tight name + description scanned at startup means the right skill fires at the right moment
- **Eval workflows catch regressions early**: draft → eval → iterate, before a broken skill reaches real tasks
- A well-structured skill keeps its full instructions available without crowding out the actual work.

(For the token/cost angle, use the opt-in `/coach:cost` command.)

## Official Resources

- [Introducing Agent Skills (Anthropic)](https://www.anthropic.com/news/skills)
- [Equipping Agents with Agent Skills](https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills)
- [DeepLearning.AI: Agent Skills with Anthropic](https://www.deeplearning.ai/short-courses/agent-skills-with-anthropic/) (free)
- [The Complete Guide to Building Skills (PDF)](https://resources.anthropic.com/hubfs/The-Complete-Guide-to-Building-Skill-for-Claude.pdf)
- [Skills Cookbook](https://github.com/anthropics/anthropic-cookbook/tree/main/skills)
- [Community Skills Repository](https://github.com/anthropics/skills)
