<!-- file: knowledge/features/permissions.md -->
<!-- last-updated: 2026-06-21 -->
<!-- source: https://code.claude.com/docs/en/permission-modes -->
<!-- curriculum_level: L0 -->

# Permissions, Modes & Safe Operation

## Current State

Every action Claude Code takes — reading a file, editing code, running Bash, hitting the network — passes through a permission layer before it runs. The **permission mode** decides what is auto-approved, what is blocked, and what prompts you. Picking the right mode is how you tune the autonomy ↔ oversight tradeoff: how much Claude runs on its own versus how often you're in the loop.

This is the foundation under everything else. Loosen the mode and Claude moves faster but you review more after the fact; tighten it and you approve more up front but catch problems before they happen. The five cross-cutting practices — verification first, explore→plan→code, ground the prompt, course-correct early, manage context — all assume you've matched the mode to the task.

## Key Concepts

### The Six Permission Modes

| Mode | Behavior | Use when |
|------|----------|----------|
| `default` | Reads freely; **prompts** for writes, Bash, and network | Day-to-day work where you want a checkpoint before anything changes |
| `acceptEdits` | Auto-approves file edits and safe filesystem ops | Fast iteration on a known task — you'll review the diff after |
| `plan` | Research and propose only; **no edits** until you approve the plan | Anything non-trivial: this is the mode behind explore→plan→code |
| `auto` | A background safety classifier pre-approves routine work and blocks scope escalation, unknown infrastructure, and hostile content | You want autonomy with a guardrail, not blanket approval |
| `dontAsk` | Only pre-approved, allow-listed tools run; nothing else | CI, scripts, unattended runs where no human is at the keyboard |
| `bypassPermissions` | Skips checks entirely | **Only** inside an isolated container or VM |

### Choosing a Mode

- **Start tight, loosen deliberately.** `plan` for design, `default` for normal edits, `acceptEdits` once the plan is agreed and you just want speed.
- `auto` is the modern "allow + classifier review" model: routine work flows through, but the classifier blocks scope escalation, unknown infrastructure, and hostile/injected content. After repeated blocks it falls back to prompting you, so it fails safe rather than silently stalling.
- `dontAsk` and `bypassPermissions` are for non-interactive or sandboxed contexts only. `bypassPermissions` outside an isolated environment is dangerous — it removes the layer that stops a mistaken `rm -rf` or an exfiltration attempt.

### Plan Mode and explore→plan→code

`plan` mode is entered interactively — cycle modes with **Shift+Tab** (see the docs for exact keys, as bindings can vary). In plan mode Claude explores the codebase and proposes an approach but makes **no edits** until you approve the plan.

This directly implements the explore→plan→code practice: read and understand first, agree on a plan, only then write. Approving before any edit is your earliest and cheapest course-correction point — it's far easier to redirect a plan than to unwind code.

(`opusplan` is gone; use plan mode directly.)

### Protected Paths

Some paths are **never auto-approved** regardless of mode — for example `.git` and `.claude`. Touching them always requires explicit approval. The only exception is `bypassPermissions`, which is exactly why that mode belongs only in throwaway isolated environments.

### Sandboxing

Sandboxing adds **filesystem and network isolation** around Bash execution, so commands can run without touching your real files or reaching the network. The intended use is running untrusted or unknown code — a generated script, a dependency's build step, anything you wouldn't run unguarded on your machine. This is a concept-level summary; see the official docs for setup and current capabilities.

### Security & Trust Basics

- **Deny rules for secrets.** In `.claude/settings.json`, add deny rules so Claude can't read sensitive files, e.g. `Read(.env)` and `Read(**/*.key)`. A deny rule is a hard block, not a suggestion.
- **Never hardcode secrets.** Read credentials from environment variables or a secret manager at runtime; reference them by placeholder in code and docs.
- **Vet third-party extensions.** Treat unfamiliar MCP servers and third-party skills as untrusted code — review them, and sandbox them — before granting access. They can introduce prompt-injection and exfiltration paths.
- **Org/managed policy.** Managed settings can enforce permission configuration org-wide, so individual projects can't loosen below the baseline your organization requires.

### Pair Loose Modes with a Verification Gate

The more autonomy you grant, the more you need an automatic backstop. A **Stop-hook verification gate** (see the hooks knowledge file) runs deterministic checks — lint, tests, build — when Claude finishes, catching problems a looser mode let through. Looser mode for speed + a Stop hook for correctness is the standard high-autonomy setup: it keeps verification first even when you're not approving each step.

## Mastery Checks

- [ ] Can you name all six modes and when each is appropriate?
- [ ] Do you reach for `plan` mode on non-trivial tasks and approve before any edit?
- [ ] Do you understand why `bypassPermissions` belongs only in isolated containers/VMs?
- [ ] Have you added deny rules (e.g. `Read(.env)`, `Read(**/*.key)`) to your project settings?
- [ ] Do you sandbox or vet untrusted code, MCP servers, and third-party skills before granting access?
- [ ] Have you paired a looser mode with a Stop-hook verification gate?

## Why It Matters

**The mode is your autonomy dial.** Too tight and you babysit every step; too loose and Claude can act outside your intent before you notice. Matching the mode to the task is what lets you safely hand Claude more work without losing control.

**Oversight should fail safe.** `auto`'s classifier blocks escalation and falls back to prompting; `plan` mode forces approval before edits; protected paths resist all but the most explicit override. These defaults mean a mistake gets caught rather than executed.

**Trust is earned, not assumed.** Deny rules keep secrets out of context, sandboxing contains untrusted code, and vetting third-party extensions closes injection paths. Combined with a verification gate, this is how you let Claude run more on its own while staying confident in the result.

## Official Resources

- [Permission modes](https://code.claude.com/docs/en/permission-modes)
- [Claude Code documentation](https://code.claude.com/docs/en/)
