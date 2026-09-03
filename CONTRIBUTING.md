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

# 2. Activate the pre-push hook (one-time setup, optional)
git config core.hooksPath .githooks

# 3. Start Claude Code in a test project with the plugin loaded
claude --plugin-dir ~/dev/agentic-ai-mastery

# 4. Verify it loaded
/help
```

**Which gate actually enforces what.** The pre-push hook is opt-in — nothing checks that
you ran the `core.hooksPath` line, so do not treat it as a safety net. **CI is the real
gate** and runs on every push and PR regardless. In-session, the `Stop` hook in
`.claude/settings.json` runs the same checks before Claude can finish a turn, so a Claude
session is covered whether or not you enabled the git hook.

That is the dev loop: no install, no version bump, no update cycle. Plugin changes are
picked up on the next session launch, or `/reload-plugins` mid-session.

Test the real install/update UX only when you are changing packaging itself:

```bash
claude plugin marketplace add ~/dev/agentic-ai-mastery
claude plugin install coach@agentic-ai-mastery
claude plugin update coach@agentic-ai-mastery
```

The pre-push hook runs the same checks as CI (JSON validation, plugin.json key whitelist, file line limits) before every push, so issues are caught locally before they reach a PR.

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

- [ ] Tested locally with `claude --plugin-dir <repo>`
- [ ] `claude plugin validate .` passes
- [ ] All knowledge files are under 500 lines (`wc -l knowledge/**/*.md`)
- [ ] Total knowledge base is under 5,000 lines
- [ ] JSON files are valid (`python3 -m json.tool .claude-plugin/plugin.json`)
- [ ] `CHANGELOG.md` updated under `[Unreleased]`
- [ ] No `.env`, credentials, secrets, or key files touched or referenced
- [ ] Branch targets `master`

## Knowledge File Format

All files under `knowledge/` must follow this structure:

Knowledge files start with an **HTML comment metadata header** — not YAML frontmatter.
The authoritative spec is `.claude/rules/knowledge-limits.md`; this section must stay in
sync with it.

```markdown
<!-- file: knowledge/<category>/<filename>.md -->
<!-- last-updated: YYYY-MM-DD -->
<!-- source: <upstream doc URL or "internal"> -->

# <Title>

## Current State

<What Claude Code currently supports in this area>

## Key Concepts

<Core concepts a developer needs to understand>

## Mastery Checks

<How the coach verifies the developer has internalized this level>

## Why It Matters

<Why this changes how the developer works>

## Official Resources

<Links to official Claude Code documentation>
```

Additional rules for knowledge files:

- Maximum **500 lines** per file — split if needed
- Filename in **kebab-case**, with no level prefix: `context.md`, not `l3-context-engineering.md`
- No content before the metadata header
- ATX headers (`#`, `##`, `###`) — no underline-style headers
- No trailing whitespace
- Blank line before and after every header
- File ends with a single newline

There is no `## Cost Implications` section — cost coaching is off by default, so cost
facts live in `knowledge/pricing/` and load only on an explicit cost question.

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
