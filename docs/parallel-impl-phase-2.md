# Parallel Implementation Spec — Phase 2 Trust & UX

## Overview

Four independent improvements are ready for implementation. Each touches a different file set, has no inter-task dependencies, and can be merged in any order. This spec describes how to execute them in parallel using four worker agents orchestrated by a single main agent.

---

## Orchestration Pattern

```
Main Agent
├── [worktree] Worker A — plugin.json tool permissions
├── [worktree] Worker B — assess scan receipt
├── [worktree] Worker C — token estimate footer
└── [worktree] Worker D — /coach:next actionable output
```

Each worker:
1. Receives the full task spec below (files, changes, acceptance criteria)
2. Runs in an isolated git worktree on its own branch
3. Implements, then opens a PR against `master`
4. Returns the PR URL to the main agent

Main agent collects all four PR URLs and reports a summary table.

---

## Main Agent Prompt

```
You are orchestrating four parallel plugin improvements.

Steps:
1. Read this file completely: docs/parallel-impl-phase-2.md
2. Read the current branch: `git branch --show-current`
3. Launch all four Worker tasks in PARALLEL using the Task tool with
   subagent_type=general-purpose and isolation=worktree.
   Pass each worker its full spec from the "Worker Specs" section below.
4. Wait for all four to complete.
5. Report a summary table:

| # | Task | Branch | PR | Status |
|---|------|--------|----|--------|
| A | plugin.json permissions | feat/plugin-tool-permissions | <url> | ✓ |
| B | assess scan receipt | feat/assess-scan-receipt | <url> | ✓ |
| C | token estimate footer | feat/token-estimate-footer | <url> | ✓ |
| D | next actionable output | feat/next-actionable-output | <url> | ✓ |

Do not implement any task yourself — delegate all implementation to workers.
Do not wait for PRs to be merged before reporting.
```

---

## Worker Specs

### Worker A — Explicit Tool Permissions in plugin.json

**Branch:** `feat/plugin-tool-permissions`
**Base:** `master`

**Context:**
The plugin.json manifest currently has no `permissions` field. Users and marketplace reviewers cannot audit what tools the plugin is allowed to use. Claude Code's plugin schema supports a `permissions` block.

**File to modify:** `.claude-plugin/plugin.json`

**Change:** Add a `permissions` block that explicitly declares every tool the plugin uses across all commands, skills, and agents. Base the list on what the commands actually do (reading files, writing state to ~/.claude/coaching/, web fetching for discovery, bash for version checks).

Use this structure:
```json
"permissions": {
  "allow": [
    "Read",
    "Write(~/.claude/coaching/**)",
    "Glob",
    "Grep",
    "Bash(claude --version)",
    "Bash(wc)",
    "Bash(ls)",
    "Bash(stat)",
    "WebFetch",
    "WebSearch"
  ],
  "deny": [
    "Read(**/.env)",
    "Read(**/.env.*)",
    "Read(**/secrets*)",
    "Read(**/credentials*)",
    "Write(**)",
    "Bash(*)"
  ]
}
```

The `deny` list must come after `allow` and must explicitly block: env files, credentials, unrestricted Write, unrestricted Bash.

**Acceptance criteria:**
- [ ] `python3 -m json.tool .claude-plugin/plugin.json` exits 0 (valid JSON)
- [ ] `permissions.allow` lists all tools used by commands/skills/agents
- [ ] `permissions.deny` blocks .env, credentials, unrestricted Write, unrestricted Bash
- [ ] No other fields in plugin.json are changed

**PR title:** `feat: add explicit tool permissions to plugin.json`

**PR body:**
```
## Summary
- Adds `permissions` block to `.claude-plugin/plugin.json`
- Declares every tool the plugin uses (Read, Write to coaching state only, Glob, Grep, limited Bash, WebFetch, WebSearch)
- Explicitly denies access to .env files, credentials, unrestricted Write, unrestricted Bash
- Allows marketplace reviewers and users to audit plugin behavior without reading source

## Test plan
- [ ] `python3 -m json.tool .claude-plugin/plugin.json` passes
- [ ] Review allow list matches tools used across commands/, skills/, agents/
- [ ] Review deny list blocks sensitive file patterns
```

---

### Worker B — Scan Receipt in /coach:assess

**Branch:** `feat/assess-scan-receipt`
**Base:** `master`

**Context:**
`/coach:assess` delegates to the coach sub-agent which reads many files. The developer has no visibility into what was actually scanned. A scan receipt at the end of the output closes this trust gap.

**File to modify:** `commands/assess.md`

**Change:** Replace the existing Step 5 (Privacy Reminder) with a more structured **Scan Receipt** step. The receipt must:

- Be titled `### Scan Receipt`
- List every path pattern the coach agent scanned, grouped into three sections:
  - **Project scope** — `.claude/`, `CLAUDE.md`, `.mcp.json`, `.claude-plugin/`, project root files
  - **Global scope** — `~/.claude/settings.json`, `~/.claude/CLAUDE.md`, `~/.claude/keybindings.json`
  - **State written** — path appended to in `~/.claude/coaching/state/`
- End with one line: `Nothing else was read or written.`

The receipt is static (always the same paths) — it reflects what the coach agent is *instructed* to scan, not a dynamic log.

**Acceptance criteria:**
- [ ] Step 5 is replaced (not added as Step 6) — file stays ≤ 60 lines
- [ ] Receipt lists all three scope groups
- [ ] Receipt ends with "Nothing else was read or written."
- [ ] No frontmatter or other sections are changed

**PR title:** `feat: add scan receipt to /coach:assess output`

**PR body:**
```
## Summary
- Replaces vague "Privacy Reminder" in Step 5 with a structured Scan Receipt
- Lists every file path pattern the coach agent is instructed to scan
- Grouped into: project scope, global scope, state written
- Closes with explicit "Nothing else was read or written." statement
- Builds user trust without requiring dynamic file logging

## Test plan
- [ ] Run `/coach:assess` and confirm Scan Receipt section appears at end
- [ ] Verify three scope groups are present
- [ ] Verify closing statement is present
- [ ] Confirm file is under 500 lines: `wc -l commands/assess.md`
```

---

### Worker C — Token Usage Estimate Footer on Every Command

**Branch:** `feat/token-estimate-footer`
**Base:** `master`

**Context:**
Each command loads context (knowledge files, state files) and generates output. Without estimates, developers can't understand cost or validate the ≤3,000 token target. A footer on every command output makes cost visible.

**Files to modify:** All files in `commands/` that have a multi-step execution flow:
- `commands/assess.md`
- `commands/next.md`
- `commands/execute.md` (if it exists and has steps)
- `commands/exercise.md`
- `commands/cost.md`
- `commands/discover.md`
- `commands/whats-new.md`
- `commands/status.md`

**Change:** In each command file, add a new final step titled `### Token Estimate` (after the last existing step, before any "Avoid" section). The step instructs the command to append a footer to its output:

```markdown
### Token Estimate

End every response with this footer:

---
**Estimated tokens this interaction:** ~[N]k input / ~[N]k output
*Input includes: [list what was loaded — e.g., "1 knowledge file (~800 tokens), state files (~400 tokens), this command (~300 tokens)"]*
```

Each command file should have hardcoded typical estimates based on what it loads:

| Command | Typical input sources | Input est. | Output est. |
|---|---|---|---|
| assess | coach agent prompt + scan | ~1.5k | ~0.8k |
| next | 1 knowledge file + state | ~1.2k | ~0.5k |
| exercise | 1 knowledge file + state | ~1.0k | ~0.6k |
| cost | pricing file + state | ~1.1k | ~0.5k |
| discover | web results + state | ~2.0k | ~0.6k |
| whats-new | web results | ~1.8k | ~0.5k |
| status | state only | ~0.4k | ~0.2k |

Use these as the hardcoded "typical" estimates in the footer instruction.

**Acceptance criteria:**
- [ ] Every command file listed above has a `### Token Estimate` step
- [ ] Each footer lists the specific input sources for that command
- [ ] All files stay under 500 lines: `wc -l commands/*.md`
- [ ] No other sections are changed

**PR title:** `feat: add token usage estimate footer to all coach commands`

**PR body:**
```
## Summary
- Adds a `### Token Estimate` step to every command file
- Each command appends a footer showing estimated input/output tokens
- Estimates are hardcoded per command based on what each one loads
- Validates the ≤3,000 token target from CLAUDE.md constraints

## Test plan
- [ ] Run each command and confirm footer appears
- [ ] Verify each footer lists the correct input sources for that command
- [ ] `wc -l commands/*.md` — all files under 500 lines
```

---

### Worker D — /coach:next Actionable Code/Config Output

**Branch:** `feat/next-actionable-output`
**Base:** `master`

**Context:**
`/coach:next` currently teaches concepts but the "Try This" section only describes what to do in prose. Users must then figure out the actual config or code themselves. The fix: generate the real, copy-pasteable artifact first, then explain it.

**File to modify:** `commands/next.md`

**Change:** Modify Step 5 (Deliver Lesson) — specifically the output format template.

Replace the current `### Try This` block:
```markdown
### Try This

[Single concrete action they can take now]
```

With:
```markdown
### Do This Now

[The actual file edit, config block, or command to run — formatted as a code block with the target file path as the language hint comment]

[One sentence: where this goes and what it does]

### Why It Matters

[One paragraph: the reasoning, grounded in their project]
```

Also update Step 5's format description from `[200-400 words]` to `[150-350 words]` — the actionable block replaces prose, keeping output tight.

Update the Example Output section to match the new format. Replace the existing `### Try This` example with a `### Do This Now` block that shows an actual CLAUDE.md snippet in a fenced code block.

**Acceptance criteria:**
- [ ] `### Try This` no longer appears in the output format template
- [ ] `### Do This Now` block contains a fenced code block placeholder
- [ ] `### Why It Matters` replaces or consolidates the explanation prose
- [ ] Example output is updated to match the new format
- [ ] Word count target is updated to 150-350
- [ ] File stays under 500 lines: `wc -l commands/next.md`
- [ ] "Avoid" section still present and unchanged

**PR title:** `feat: refactor /coach:next to lead with actionable code/config`

**PR body:**
```
## Summary
- Replaces "Try This" prose block with "Do This Now" + actual code block
- Lesson output now leads with the copy-pasteable artifact, explanation second
- Reduces word count target from 200-400 to 150-350 words
- Updates example output to demonstrate the new format
- Addresses backlog item: "/coach:next should generate actual config/code fix, not just describe it"

## Test plan
- [ ] Run `/coach:next` and confirm output contains a fenced code block
- [ ] Confirm "Try This" no longer appears
- [ ] Confirm "Why It Matters" section is present
- [ ] `wc -l commands/next.md` under 500
```

---

## Completion Criteria

All four PRs merged with:
- [ ] No files over 500 lines
- [ ] `python3 -m json.tool .claude-plugin/plugin.json` passes
- [ ] `claude plugin validate .` passes (if available)
- [ ] Each PR reviewed and approved before merge
