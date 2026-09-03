<!-- file: knowledge/repo-ready/claude-md.md -->
<!-- last-updated: 2026-09-03 -->
<!-- source: https://code.claude.com/docs/en/memory -->
<!-- curriculum_level: L2 -->

# CLAUDE.md — The Repo's Instructions to Claude

## Current State

`CLAUDE.md` is the file Claude reads at the start of every session in your repo. It is the
single highest-leverage artifact for making a repository Claude-ready: it is what lets a
teammate — or Claude on its own — get good results without being told the same things
again.

Claude Code reads `CLAUDE.md`, **not** `AGENTS.md`. If your repo already has an
`AGENTS.md` for other tools, don't duplicate it — import it:

```markdown
@AGENTS.md

## Claude Code

Use plan mode for changes under `src/billing/`.
```

## Key Concepts

### Where It Goes

| Location | Scope | Shared with |
|----------|-------|-------------|
| `./CLAUDE.md` or `./.claude/CLAUDE.md` | This project | The team, via source control |
| `./CLAUDE.local.md` | This project, just you | Nobody — gitignore it |
| `~/.claude/CLAUDE.md` | Every project on your machine | Just you |

Files in the directory hierarchy above your working directory load at launch; files in
subdirectories load on demand when Claude reads files there. That makes a per-package
`CLAUDE.md` in a monorepo cheap — it costs nothing until it's relevant.

### What Belongs In It

```markdown
# CLAUDE.md

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

Write down what you'd otherwise re-explain. Add to it when Claude makes the same mistake
twice, when a review catches something Claude should have known, or when a new teammate
would need the same context.

**The `## Commands` section is the one that matters most.** It is what makes verification
possible: without an explicit test command Claude guesses how to run your suite; with one
it runs the real thing and iterates until it passes.

### What Does NOT Belong In It

- **Anything Claude can derive from the codebase** — directory listings, dependency
  lists, architecture it can read for itself. `/doctor` will offer to trim these.
- **Multi-step procedures.** A deploy runbook or a review checklist is a
  [skill](../repo-ready/skills.md) — it loads on demand instead of every session.
- **Guidance that only applies to part of the tree.** That's a path-scoped rule (below).
- **Contradictions.** If two instructions conflict, Claude may pick either one.

### Keep It Short

Target **under ~200 lines**; shorter is better. It loads into context every single
session, and longer files measurably reduce adherence. For each line, ask: *"Would
removing this cause Claude to make a mistake?"* If not, cut it. A bloated `CLAUDE.md`
causes Claude to **ignore** the instructions that matter.

### Path-Scoped Rules

For a large repo, split instructions into `.claude/rules/*.md` and scope them with a
`paths` frontmatter field so they load only when Claude touches matching files:

```markdown
---
paths:
  - "src/api/**/*.ts"
---

# API Development Rules

- All endpoints must validate input
- Use the standard error response format
```

The field is `paths` — a rule without it loads unconditionally. Rules live alongside
`CLAUDE.md` and are shared through source control the same way.

### @imports for Modular Context

`CLAUDE.md` can pull in other files with `@path/to/file` (there is no `@import` keyword):

```markdown
# CLAUDE.md
See @README.md for project overview.
- Git workflow: @.claude/rules/git-instructions.md
- Testing: @.claude/rules/testing.md
```

Note the tradeoff: imports help *organization*, but imported files still load at launch,
so they don't reduce context the way a path-scoped rule or a skill does.

## Mastery Checks

- [ ] Does your repo have a committed `CLAUDE.md`?
- [ ] Does it contain a test/build/lint command Claude can actually run?
- [ ] Is it under ~200 lines, with nothing Claude could derive itself?
- [ ] Have you moved multi-step procedures into skills rather than growing the file?
- [ ] Have you checked `/context` to confirm it actually loaded?

## Why It Matters

**This is the artifact that makes a repo Claude-ready for everyone, not just you.** Your
personal habits travel with you; `CLAUDE.md` travels with the repo. A teammate who has
never tuned their setup still gets a Claude that knows how to build, test, and follow the
conventions.

**It is context, not enforcement.** Claude reads `CLAUDE.md` and tries to follow it, but
there is no guarantee. Anything that *must* happen — a check before every commit, a
blocked path — belongs in a [hook](../repo-ready/hooks.md), which runs as code regardless
of what Claude decides.

**Length is a correctness issue, not a style one.** Past a few hundred lines, adherence
drops and your real rules get lost among the ones that didn't need writing down.

## Official Resources

- [How Claude remembers your project](https://code.claude.com/docs/en/memory)
- [Monorepos and large repos](https://code.claude.com/docs/en/large-codebases)
