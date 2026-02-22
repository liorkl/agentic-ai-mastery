# Agentic AI Mastery — Project Instructions

## What This Project Is

A Claude Code **plugin** that coaches developers to master agentic AI development. The plugin bundles commands, a skill, a sub-agent, and a knowledge base into a single installable package.

**Works in both Claude Code and Cowork.**

## Architecture

```
.claude-plugin/plugin.json    → Plugin manifest
commands/*.md                  → User-invoked slash commands (/coach:*)
skills/coaching/SKILL.md       → Auto-triggered coaching behavior
agents/coach.md                → Sub-agent for complex flows (assessment, discovery)
knowledge/**/*.md              → Curriculum content, read on-demand
docs/                          → Design documents (dev reference only)
```

**Runtime state** (created by plugin at first use):
- `~/.claude/coaching/state/` — assessments, outcomes, discoveries (JSONL + JSON)
- Plugin writes here using Claude's Write tool
- State persists across sessions and projects

## Validation

```bash
# Validate plugin structure
claude plugin validate .

# Verify knowledge files under limits
wc -l knowledge/**/*.md        # Each file <500 lines
cat knowledge/**/*.md | wc -l  # Total <5,000 lines

# Local install for testing
/plugin marketplace add ~/liorklibansky/dev/agentic-ai-mastery
/plugin install coach@agentic-ai-mastery

# Test commands
/coach:help
/coach:assess
/coach:next
```

## Key Constraints

- Plugin manifest is JSON, commands/skills/agents are Markdown with YAML frontmatter
- No external scripts or dependencies — components use Claude's native tools
- Knowledge files: max 500 lines each, <5,000 lines total
- Context overhead target: ≤3,000 tokens per coaching interaction
- Plugin NEVER reads .env, credentials, secrets, keys
- State writes ONLY to ~/.claude/coaching/**
- MIT License

## Design Documents (Read Before Implementing)

- `docs/requirements.md` — Scope, plugin components, acceptance criteria, implementation plan
- `docs/curriculum-v1.1.md` — Full 11-level curriculum content
- `docs/diagnostic-v1.1.md` — Environment scan targets and heuristics
- `docs/cost-guide-v1.0.md` — Pricing data and cost coaching annotations
- `docs/self-learning-discovery-v1.0.md` — Discovery protocol and state schemas

## Conventions

- Markdown: ATX headers, no trailing whitespace, blank line before/after headers
- JSON/JSONL: One JSON object per line in JSONL files, pretty-print plugin.json
- File naming: kebab-case for all files
- Command files: YAML frontmatter with `description` field, then markdown instructions
- Knowledge files: metadata header → Current State → Key Concepts → Mastery Checks → Cost Implications → Official Resources

## DO NOT

- Create a web frontend, API server, or database
- Create shell scripts — commands/skills/agent use Claude's native tools
- Add npm/pip dependencies
- Put anything inside `.claude-plugin/` except `plugin.json`
- Create files over 500 lines — split them
- Reference files outside the plugin directory (they won't exist after install)
