# Agentic AI Mastery — Project Instructions

## What This Project Is

A Claude Code **plugin** that coaches developers to master agentic AI development. The plugin bundles commands, a skill, a sub-agent, and a knowledge base into a single installable package.

**Works in both Claude Code and Cowork.**

## Architecture

```
.claude-plugin/plugin.json    → Plugin manifest
commands/*.md                 → Four slash commands, one job each:
                                assess (measure) → apply (change)
                                learn (teach)    → progress (report)
                                assess + apply take a `me` | `repo` scope
skills/coaching/SKILL.md      → Auto-triggered coaching behavior
agents/coach.md               → Read-only scanner/assessor sub-agent
knowledge/
  knowledge-map.md            → THE routing table (never duplicate it)
  personal-env/**             → Mission 1: the developer's own ~/.claude setup
  repo-ready/**               → Mission 2: what gets committed to the repo
  shared/**                   → Cross-cutting practices (both missions)
  pricing/**                  → Loaded only on an explicit cost question
  ecosystem/**                → Adjacent topics (Claude API, Cowork)
templates/                    → Real, CI-tested starter files for a Claude-ready repo
scripts/test-templates.sh     → Runs the templates; called by pre-push AND CI
docs/DESIGN.md                → Design notes (dev reference only)
```

**The two missions.** Mission 1 makes a developer's personal environment effective
(`~/.claude/`, travels with them). Mission 2 makes a repo Claude-ready (committed, so the
team benefits). They fail independently — never average them into one score.

**Runtime state** (created by plugin at first use):

- `~/.claude/coaching/state/` — assessments and outcomes (JSONL)
- Assessment records carry a `scope` field (`me` or `repo`)
- State persists across sessions and projects

## Local Test Workflow

**Dev loop** — load plugin for a single session without installing (primary approach):

```bash
# In the test project, start Claude Code with the plugin loaded
claude --plugin-dir /abs/path/to/agentic-ai-mastery
```

No install, no version bump, no update cycle. Changes to plugin files are picked up
on the next session launch. To reload mid-session without restarting:

```bash
/reload-plugins
```

Then test:

```bash
/help
/coach:assess
/coach:learn
/coach:progress
```

**Integration test** — test the actual install/update UX (run once):

```bash
# Register as a local marketplace (once per machine)
claude plugin marketplace add /abs/path/to/agentic-ai-mastery

# Install globally
claude plugin install coach@agentic-ai-mastery

# After making changes, update the installed copy
claude plugin update coach@agentic-ai-mastery
```

## Key Constraints

- Plugin manifest is JSON, commands/skills/agents are Markdown with YAML frontmatter
- Runtime components (commands, skill, agent) use Claude's native tools — no dependencies
- `templates/` and `scripts/` DO contain real executable files, and CI runs them. This is
  deliberate: guidance that lives only in prose cannot be tested, which is how a hook
  config that never loads and reversed exit codes shipped as the flagship lesson
- Knowledge files: max 500 lines each, <5,000 lines total
- Context overhead target: ≤3,000 tokens per coaching interaction
- Plugin NEVER reads .env, credentials, secrets, keys
- State writes ONLY to ~/.claude/coaching/**
- MIT License

## Validation

**Plugin validation:**

```bash
claude plugin validate .
```

**Knowledge base line limit check:**

```bash
wc -l knowledge/**/*.md        # Each file must be <500 lines
cat knowledge/**/*.md | wc -l  # Total must be <5,000 lines
```

**Template test suite** (the same script CI runs):

```bash
bash scripts/test-templates.sh
```

**JSON validation:**

```bash
python3 -m json.tool .claude-plugin/plugin.json
python3 -m json.tool .claude-plugin/marketplace.json
```

## Design Notes

`docs/DESIGN.md` — the two missions, design principles, and where the authoritative
answer lives for each question.

**The runtime is the specification.** `agents/coach.md` owns the scanner, level ladder,
scoring, and assessment schema; `knowledge/knowledge-map.md` owns knowledge routing.
Do not create a parallel design doc that restates them — the previous set drifted into
self-contradiction and was deleted.

## Conventions

- Markdown: ATX headers, no trailing whitespace, blank line before/after headers
- JSON/JSONL: One JSON object per line in JSONL files, pretty-print plugin.json
- File naming: kebab-case for all files
- Command files: YAML frontmatter with `description` field, then markdown instructions
- Knowledge files: metadata header → Current State → Key Concepts → Mastery Checks → Why It Matters → Official Resources

## Git Workflow

**Never commit directly to `master`.** Always:

1. Create a feature branch: `git checkout -b feat/<short-description>`
2. Commit changes on the branch
3. Push and open a PR for review

## DO NOT

- Create a web frontend, API server, or database
- Add shell scripts to the *runtime* (commands/skills/agent use Claude's native tools).
  `templates/` and `scripts/` are the exception — those are tested files, not runtime
- Add npm/pip dependencies
- Put anything inside `.claude-plugin/` except `plugin.json`
- Create files over 500 lines — split them
- Reference files outside the plugin directory (they won't exist after install)
