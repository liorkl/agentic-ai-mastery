# Contributing to Agentic AI Mastery

Thank you for your interest in contributing. This project is a Claude Code plugin that coaches developers through an 11-level agentic AI curriculum. Contributions that improve the curriculum, add commands, fix bugs, or refine coaching quality are all welcome.

## What to Contribute

- **Knowledge files** — New or improved curriculum content under `knowledge/`
- **Curriculum improvements** — Corrections, clarifications, or depth improvements to existing levels
- **New commands** — Additional `/coach:*` commands under `commands/`
- **Bug fixes** — Incorrect behavior in commands, skills, or the sub-agent
- **Docs** — Design documents under `docs/` (dev reference only, not end-user docs)

Do NOT contribute: web frontends, API servers, shell scripts, npm/pip packages, or anything that introduces external dependencies. See the full list under [Do NOT](#do-not) below.

## Local Setup

```bash
# 1. Fork and clone the repository
git clone https://github.com/<your-username>/agentic-ai-mastery ~/dev/agentic-ai-mastery
cd ~/dev/agentic-ai-mastery

# 2. Add the local repo as a marketplace source in Claude Code
claude plugin marketplace add ~/dev/agentic-ai-mastery

# 3. Install the plugin locally
claude plugin install coach@agentic-ai-mastery

# 4. Verify installation
/coach:help
```

## Testing Local Changes

After making changes, follow these steps to pull them into Claude Code:

```bash
# 1. Commit and push your changes
git add .
git commit -m "your change description"
git push

# 2. Refresh the marketplace index
claude plugin marketplace update agentic-ai-mastery

# 3. Update the plugin
claude plugin update "coach@agentic-ai-mastery"
```

> **Note:** the short name `coach` won't work — you must use the full `coach@agentic-ai-mastery` form.

**4. Restart Claude Code** — changes take effect only after a restart.

**5. Verify the update applied:**

```bash
claude plugin list
# Check that lastUpdated reflects today's date
```

**One-liner for the update cycle:**

```bash
claude plugin marketplace update agentic-ai-mastery && claude plugin update "coach@agentic-ai-mastery"
```

Then restart Claude Code and test your changes.

## Validation Before Opening a PR

Run all three checks and confirm they pass before pushing:

```bash
# 1. Validate plugin structure
claude plugin validate .

# 2. Check individual knowledge file line counts (each must be <500 lines)
wc -l knowledge/**/*.md

# 3. Validate JSON files
python3 -m json.tool .claude-plugin/plugin.json > /dev/null && echo "OK"
```

All three must pass. PRs that fail validation will not be merged.

## Branch Naming

Use one of the following prefixes:

| Prefix | When to use |
|--------|-------------|
| `feat/` | New commands, new knowledge files, new curriculum levels |
| `fix/` | Bug fixes in commands, skills, or agent behavior |
| `docs/` | Changes to design documents or README |
| `chore/` | Tooling, CI, plugin manifest updates, non-functional changes |

Examples: `feat/l11-advanced-governance`, `fix/assess-state-path`, `docs/cost-guide-update`

## Submitting a PR

1. Create a branch: `git checkout -b feat/<short-description>`
2. Make your changes
3. Run validation (see above)
4. Update `CHANGELOG.md` under the `[Unreleased]` section
5. Push your branch: `git push -u origin feat/<short-description>`
6. Open a pull request against `master` on GitHub
7. Fill in the PR template, including the checklist
8. Reference any related issue (e.g. `Closes #42`) in the PR description

## PR Checklist

Before marking your PR ready for review, confirm all of the following:

- [ ] Tested locally with `claude plugin install coach@agentic-ai-mastery`
- [ ] `claude plugin validate .` passes
- [ ] All knowledge files are under 500 lines (`wc -l knowledge/**/*.md`)
- [ ] Total knowledge base is under 5,000 lines
- [ ] JSON files are valid (`python3 -m json.tool .claude-plugin/plugin.json`)
- [ ] `CHANGELOG.md` updated under `[Unreleased]`
- [ ] No `.env`, credentials, secrets, or key files touched or referenced
- [ ] Branch targets `master`

## Knowledge File Format

All files under `knowledge/` must follow this structure:

```markdown
---
level: L<N>
topic: <short topic name>
version: 1.0
---

# <Title>

## Current State

<What Claude Code currently supports in this area>

## Key Concepts

<Core concepts a developer needs to understand>

## Mastery Checks

<How the coach verifies the developer has internalized this level>

## Cost Implications

<How this topic affects token usage and cost>

## Official Resources

<Links to official Claude Code documentation>
```

Additional rules for knowledge files:

- Maximum **500 lines** per file — split if needed
- Filename in **kebab-case**: `l3-context-engineering.md`
- ATX headers (`#`, `##`, `###`) — no underline-style headers
- No trailing whitespace
- Blank line before and after every header

## Do NOT

- Add shell scripts — commands and skills use Claude's native tools
- Add npm, pip, or any other package manager dependencies
- Put files inside `.claude-plugin/` other than `plugin.json`
- Create files over 500 lines — split them into multiple files
- Reference files outside the plugin directory (they will not exist after install)
- Read or reference `.env`, credentials, secrets, or API key files
- Write state outside `~/.claude/coaching/`
- Create a web frontend, API server, or database

## Questions

Open a GitHub Issue for questions, proposals, or discussion before starting large contributions. This avoids duplicated effort and ensures alignment with the curriculum design.

## Release Process

This section is for maintainers.

### Steps

1. Ensure all PRs for the release are merged to `master`
2. Create a release branch: `git checkout -b chore/release-vX.Y.Z`
3. Update `CHANGELOG.md`: rename `## [Unreleased]` to `## [X.Y.Z] - YYYY-MM-DD` and add a fresh empty `## [Unreleased]` section above it
4. Update the `version` field in `.claude-plugin/plugin.json`
5. Commit: `chore: release vX.Y.Z` and open a PR
6. Merge the PR — CI auto-tags `vX.Y.Z` and creates the GitHub Release automatically

### Semver Rules

| Bump | When |
|------|------|
| **Patch** (1.0.x) | Bug fixes, knowledge file updates, typo corrections |
| **Minor** (1.x.0) | New commands, new knowledge files, curriculum improvements, new anti-pattern detections |
| **Major** (x.0.0) | Breaking changes to state schema, plugin manifest breaking change, major curriculum restructure |
