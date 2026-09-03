# Design Notes

## The runtime is the specification

This plugin used to carry ~3,100 lines of design documents — `requirements.md`,
`curriculum-v1.1.md`, `diagnostic-v1.1.md` — that restated the engine in parallel prose.
They drifted, as parallel copies do, and the drift was not subtle: `requirements.md` ended
up with two stacked re-order banners that contradicted each other (one asserted skills were
Level 3, the next asserted skills moved from Level 3 to Level 4), and `diagnostic-v1.1.md`
carried the line *"Verify against the engine before relying on any level number here."*

A document that tells you not to trust it has already failed. They were deleted rather than
patched again.

**Read the runtime instead. It is authoritative because it is what executes:**

| Question | Authoritative file |
|----------|-------------------|
| How is the environment scanned? What is the level ladder? How is `CLAUDE.md` scored? Which anti-patterns are detected? What is the assessment schema? | `agents/coach.md` |
| Which knowledge file answers which question? | `knowledge/knowledge-map.md` |
| How does passive coaching behave? | `skills/coaching/SKILL.md` |
| What does each command do? | `commands/*.md` |
| What is the curriculum content? | `knowledge/**` — each file carries its own `## Mastery Checks` |
| What are the repo's own rules? | `CLAUDE.md`, `.claude/rules/` |

## The two missions

Everything in the plugin serves one of two goals, and they fail independently:

1. **A developer's personal environment is highly effective** — `~/.claude/`: permissions,
   model and effort defaults, personal skills and subagents, MCP servers, statusline,
   global `CLAUDE.md`. Travels with the developer into every project.
2. **A repo is Claude-ready** — `CLAUDE.md`, `.claude/rules/`, hooks, project skills and
   agents, and a test/build/lint command Claude can actually run. Travels with the repo, so
   a teammate who has tuned nothing still gets good results.

The knowledge base mirrors this split: `knowledge/personal-env/` and
`knowledge/repo-ready/`, with `knowledge/shared/` for the cross-cutting practices that
apply to both. `/coach:assess` and `/coach:apply` take a `me` or `repo` scope.

Keeping them separate is the point. An excellent personal setup does nothing for a repo
where Claude cannot verify its work, and a well-prepared repo does nothing for a developer
whose permissions prompt on every edit. Averaging the two into one score hides which one to
fix.

## Design principles

**Levels are a scaffold, not a score.** L0–L10 describes feature breadth. It does not
describe whether the developer is getting good work out of Claude. A repo can be "L9" —
hooks, MCP, agent teams — and still produce mediocre output.

**Practice outranks feature, always.** The cross-cutting practices in
`knowledge/shared/productivity-tips.md` apply at every level and move output quality more
than any feature. Verification is first among them: give Claude a check it can run and it
closes its own loop. A Level 7 repo with no test command gets a verification lesson, not an
MCP lesson.

**Cost coaching is off by default.** Lead with capability and correctness, not spend.
`knowledge/pricing/pricing-current.md` loads only when the user explicitly asks about cost.

**Measure and change are different commands.** `/coach:assess` and the `coach` agent are
read-only — an assessment that modifies what it measures is not an assessment. Only
`/coach:apply` writes, only for the step the user is on, only after showing the diff, and
always by merging into existing files rather than overwriting them.

**Four commands, one job each.** `assess` measures, `apply` changes, `learn` teaches,
`progress` reports. The plugin previously shipped eleven, and had to include a decision
matrix explaining which of two to use — that matrix was the evidence the split was wrong.

## Keeping content fresh

Knowledge files carry a `last-updated` metadata header. Freshness is maintained through the
release pipeline: refresh the knowledge base, bump `plugin.json`, and the version bump tags
a release.

This replaced a per-user discovery command that fetched changelogs at runtime. That approach
failed on its own terms — the plugin shipping it went 74 days and three model generations
stale without noticing. Paying one maintainer to refresh content beats charging every user
to re-discover it.
