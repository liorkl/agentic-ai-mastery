---
name: run-migrations
description: Run database migrations for this project, including the pre-flight checks that are easy to forget
disable-model-invocation: true
argument-hint: "[up | down | status]"
allowed-tools: Bash(npm run migrate:*) Bash(git status) Read
---

# Run Migrations

A worked example of a task skill: a multi-step procedure with side effects, so
**you** trigger it with `/run-migrations` and Claude never starts it on its own.

That is what `disable-model-invocation: true` is for. Use it for anything you would
not want Claude to decide to do because the code looked ready — deploys, commits,
migrations, sending messages.

## Steps

### 1. Pre-flight

- `git status` — refuse to run with a dirty tree; a failed migration on top of
  uncommitted work is hard to unpick.
- Confirm which environment is targeted. Say it out loud before running anything.
- Check `migrations/` for files newer than the last applied migration.

### 2. Run

| Argument | Command |
|----------|---------|
| `status` *(default)* | `npm run migrate:status` |
| `up` | `npm run migrate:up` |
| `down` | `npm run migrate:down` — one step only, and confirm first |

### 3. Verify

Re-run `npm run migrate:status` and show the result. A migration that reports
success without a status check has not been verified.

## Why this is a skill and not a CLAUDE.md section

It is a procedure, not a fact. Facts belong in `CLAUDE.md`, which loads every
session; a procedure like this loads only when invoked, so it costs nothing the rest
of the time. The moment a `CLAUDE.md` section grows steps, it wants to be a skill.
