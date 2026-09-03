---
description: "Scan your Claude Code setup and report readiness, gaps, and anti-patterns — for your personal environment, this repo, or both"
argument-hint: "[me | repo]"
disable-model-invocation: true
allowed-tools: Read(~/.claude/coaching/state/**)
---

# /coach:assess — Environment Assessment

Measures where you stand. Everything else in this plugin consumes what this produces.

There are two missions, and they fail independently:

| Scope | Mission | What it covers |
|-------|---------|----------------|
| `me` | **Your personal environment** | `~/.claude/` — settings, permissions, your skills/agents/commands, MCP servers, model and effort defaults, statusline, global CLAUDE.md. Travels with you across every project |
| `repo` | **This repo's Claude-readiness** | `CLAUDE.md`, `.claude/` rules and hooks, `.mcp.json`, project skills and agents, whether a test/build/lint command exists. Travels with the repo, to everyone on the team |
| *(none)* | **Both** | Report each separately — do not average them into one number |

A developer with an excellent personal setup can sit in a repo where Claude has no way to
verify its work, and a well-prepared repo does nothing for someone whose permissions
prompt on every edit. Report them apart so the reader knows which one to fix.

## Instructions

### 1. First-Run Check

If `~/.claude/coaching/state/` does not exist, delegate to the **coach** agent to run
first-run initialization before proceeding.

### 2. Delegate the Scan

Delegate to the **coach** agent, scoping the task to `$ARGUMENTS`:

**`me`** —

> Scan the personal Claude Code environment only: `~/.claude/settings.json`,
> `~/.claude/CLAUDE.md`, `~/.claude/rules/`, `~/.claude/skills/`, `~/.claude/agents/`,
> `~/.claude/commands/`, installed plugins, MCP server configuration, and
> `~/.claude/keybindings.json`. Do not scan the project. Apply level detection,
> anti-pattern detection, and gap detection against the personal-environment criteria.
> Append the assessment with `scope: "me"`.

**`repo`** —

> Scan the current project only: `.claude/` (settings, rules, hooks), `CLAUDE.md`,
> `.mcp.json`, `.claude-plugin/`, project skills and agents, and project root files
> (`package.json`, `pyproject.toml`, `go.mod`, `Makefile`) to determine whether Claude has
> a test/build/lint command it can actually run. Do not scan `~/.claude/`. Apply level
> detection, CLAUDE.md quality scoring, anti-pattern detection, and gap detection. Append
> the assessment with `scope: "repo"`.

**No argument** — run both scans and append both records.

### 3. Display Results

Lead with readiness, per scope. Never average the two missions together.

1. **Is Claude doing its best work here?** — the headline verdict, 1–2 lines per scope,
   led by verification: can Claude verify its own work in this repo (a test/build/lint
   command, ideally a gate that runs it)? This goes **above** the level number.
2. **Detected level** (L0–L10) with a one-line explanation, and an explicit note that
   level means feature breadth, not output quality.
3. **CLAUDE.md score** (X/10) with the element breakdown — `repo` scope only.
4. **What's working** — configured and doing its job.
5. **Gaps** — missing foundations below the detected level. HIGH priority.
6. **Anti-patterns** — with severity and a specific fix.
7. **Top 3 next steps** — ordered by leverage, not by level, and each **tagged with its
   mission** so the reader knows whether it changes their machine or the repo. A missing
   practice, especially verification, outranks the next feature.

### 4. Outcome Logging

Append to `~/.claude/coaching/state/outcomes.jsonl`.

These state files are append-only, but **the Write tool truncates**. To add a line:
read the existing file, append the new line to its contents, and write the whole file
back. Writing only the new line destroys the history.

```json
{
  "timestamp": "<ISO 8601>",
  "session_id": "assess-<YYYYMMDD>",
  "user_level_at_time": <detected_level>,
  "topic": "assessment",
  "subtopic": "<me|repo|full>-scan",
  "coaching_action": "assessed",
  "exercise_given": false,
  "applied": null,
  "evidence_type": "env_change",
  "notes": "scope <me|repo|full>: level <N>, CLAUDE.md <N>/10, <N> gaps, <N> anti-patterns"
}
```

### 5. Call to Action

Point at the mission that needs the work — that is the whole reason the scopes are
separate.

**Gaps in the personal environment:**

```
---
**What to do now:**
Run `/coach:apply me` to fix your personal setup — the changes travel with you to every project.
```

**Gaps in the repo:**

```
---
**What to do now:**
Run `/coach:apply repo` to make this repo Claude-ready — the changes get committed, so your whole team benefits.
```

**Both:** offer both, personal environment first — it is usually cheaper to fix and
improves every repo you touch.

**Clean:**

```
---
**What to do now:**
Nothing is broken. Run `/coach:learn` for your next level-appropriate lesson.
```

### 6. Scan Receipt

Always tell the user exactly what was touched.

**Personal scope (`me`):**

- `~/.claude/settings.json` — settings, permissions, model, hooks, statusline
- `~/.claude/CLAUDE.md` and `~/.claude/rules/` — your global instructions
- `~/.claude/skills/`, `~/.claude/agents/`, `~/.claude/commands/` — your own extensions
- Installed plugins and MCP server configuration
- `~/.claude/keybindings.json` — if present

**Repo scope (`repo`):**

- `.claude/` — settings, rules, hooks
- `CLAUDE.md` — project instructions
- `.mcp.json` — MCP server configuration, if present
- `.claude-plugin/` — plugin manifest, if present
- Project root files: `package.json`, `pyproject.toml`, `go.mod`, `Makefile`, etc.

**State written:**

- `~/.claude/coaching/state/assessments.jsonl` — one record per scope scanned

Nothing else was read, and nothing was modified. This command only measures — `/coach:apply`
is the one that changes files.
