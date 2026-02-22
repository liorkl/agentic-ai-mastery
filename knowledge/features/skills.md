<!--
topic: Agent Skills
last_updated: February 2026
source_docs: curriculum-v1.1.md
curriculum_level: L4
-->

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

## Cost Implications

Progressive disclosure in skills is a cost feature:
- **Monolithic instruction file**: 5,000 tokens loaded every session
- **Properly structured skill**: 500 tokens metadata + 4,500 only when invoked

**Eval workflows prevent expensive cycles**: deploy → discover problems → fix → redeploy

**A well-structured skill costs 1/10th the context budget of a monolithic instruction file.**

## Official Resources

- [Introducing Agent Skills (Anthropic)](https://www.anthropic.com/news/skills)
- [Equipping Agents with Agent Skills](https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills)
- [DeepLearning.AI: Agent Skills with Anthropic](https://www.deeplearning.ai/short-courses/agent-skills-with-anthropic/) (free)
- [The Complete Guide to Building Skills (PDF)](https://resources.anthropic.com/hubfs/The-Complete-Guide-to-Building-Skill-for-Claude.pdf)
- [Skills Cookbook](https://github.com/anthropics/anthropic-cookbook/tree/main/skills)
- [Community Skills Repository](https://github.com/anthropics/skills)
