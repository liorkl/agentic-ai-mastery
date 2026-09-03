# Templates

Working starting points for a Claude-ready repo. `/coach:apply repo` uses these when a
step needs a file created.

They are **real files, exercised by CI** — not illustrations. Every hook here is run
against real payloads on every push, with both the case it should block and the case it
should allow. That is deliberate: the accuracy bug that made this directory necessary was
a hook config in prose that could never load and exit codes that were backwards. Prose
cannot fail a test; a file can.

| File | Copy to | What it does |
|------|---------|--------------|
| `CLAUDE.md` | `./CLAUDE.md` | Starter project instructions. Delete everything you do not need — length costs adherence |
| `settings.json` | `.claude/settings.json` | Permission allow/deny rules plus both hooks wired up in the correct nested shape |
| `hooks/verify.sh` | `.claude/hooks/verify.sh` | **The verification gate.** A `Stop` hook that runs the project's tests and lint before Claude can finish |
| `hooks/block-secrets.sh` | `.claude/hooks/block-secrets.sh` | A `PreToolUse` hook that blocks a write containing a hardcoded secret |
| `agents/reviewer.md` | `.claude/agents/reviewer.md` | A read-only review subagent on `model: haiku` |
| `skills/run-migrations/SKILL.md` | `.claude/skills/run-migrations/SKILL.md` | A worked task skill with `disable-model-invocation: true` |

## Installing them

```bash
mkdir -p .claude/hooks
cp templates/settings.json      .claude/settings.json
cp templates/hooks/*.sh         .claude/hooks/
chmod +x .claude/hooks/*.sh
cp templates/CLAUDE.md          ./CLAUDE.md      # if you do not have one
```

If you already have a `.claude/settings.json`, **merge** rather than copy — overwriting
discards your existing permissions, hooks, and statusline.

Then confirm the hooks registered:

```bash
claude
/hooks
```

## The two things that make a hook silently useless

Both look correct and neither raises an error.

**1. The flat config shape.** A hook event maps to matcher groups, and each group holds a
nested `hooks` array:

```json
{ "matcher": "Edit", "hooks": [{ "type": "command", "command": "..." }] }
```

Writing `{ "matcher": "Edit", "command": "..." }` — without the inner array — produces a
hook that never fires.

**2. `exit 1` where you meant `exit 2`.** Exit 2 blocks. Exit 1 is a *non-blocking* error:
the operation proceeds and your guardrail does nothing. Both templates here exit 2 to
block, and both are tested for it.

## Adapting them

The commands in `verify.sh` assume npm. Swap them for your stack — `pytest`, `go test`,
`make check`. Two properties matter more than the specific commands:

- **A repo with nothing to verify exits 0.** A gate that blocks when there is no test
  script is a gate people disable.
- **Output stays short.** Verbose hook output crowds the context and buries the one line
  Claude needs to act on. Both templates pipe through `tail`.
