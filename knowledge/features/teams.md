<!-- file: knowledge/features/teams.md -->
<!-- last-updated: 2026-06-21 -->
<!-- source: https://code.claude.com/docs/en/best-practices -->
<!-- curriculum_level: L9 -->

# Parallelism & Agent Teams

## Simpler First: Worktrees & Dual-Instance

Before reaching for any agent-teams machinery, climb the parallelism ladder from the bottom. The first rungs need **no experimental features and no orchestration** — just two plain CLI sessions and (optionally) git worktrees.

### Git Worktrees

A git worktree gives each session its own isolated checkout on its own branch. Parallel edits land in separate working directories, so two sessions never collide on the same files or index:

```bash
git worktree add ../feature-a -b feature-a
git worktree add ../feature-b -b feature-b
```

Run one Claude session per worktree. Each operates on a clean branch; you merge when each is done. This keeps independent work streams physically separated with zero coordination overhead.

### Dual-Instance (Two Plain Sessions)

A simple, powerful parallel pattern that needs **no agent-teams machinery at all**:

- **Writer + reviewer**: one session writes the code, a second session reviews it (often read-only) and feeds back findings.
- **One session per independent task**: split genuinely separate tasks across two terminals.

Teach this as the **first rung of parallelism**. It captures most of the practical speedup of running work concurrently while staying fully predictable and easy to reason about. Combine it with worktrees when the two sessions touch overlapping files.

## Start Simple — When NOT to Reach for a Team

From Anthropic's "Building effective agents", before adding any multi-agent structure:

- **Find the simplest thing that works.** Often a single model call plus retrieval and a verification check is enough. Add complexity only when simpler approaches demonstrably fall short.
- **Prefer workflows before agents.** A *workflow* is LLMs orchestrated through predefined code paths — predictable and easy to test. An *agent* is an LLM dynamically directing its own process and tool use — open-ended and harder to bound. Reach for the agent only when the open-endedness is genuinely required.
- **Teams trade latency and cost** and risk **compounding errors** across agents. They need trust, sandboxing, and guardrails to be worth it.

Reach for an agent **team** only when the task is genuinely open-ended **AND** the cost of error is recoverable — i.e. you have tests, review, and rollback to catch the compounding-error risk. Otherwise stay on a lower rung: solo agent, dual-instance, or worktrees.

**The parallelism ladder (climb in order):**

1. Solo session (workflow or single agent)
2. Git worktrees — isolated branches, no orchestration
3. Dual-instance — two plain CLI sessions (writer + reviewer, or task split)
4. Agent teams — experimental, token-expensive, **last resort**

## Agent Teams (Experimental, Token-Expensive — Last Resort)

> **Experimental and token-expensive.** Agent teams sit at the **top of the parallelism ladder** — the last resort, not the default. Each teammate runs its own context window, so a team multiplies token spend and adds coordination latency. Use it only after worktrees and dual-instance are clearly insufficient. Flags and behavior may change; confirm against https://code.claude.com/docs/en/.

## Current State

Agent teams coordinate multiple Claude instances working in parallel. Each teammate has an independent context window.

**Experimental status**: Requires `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` in settings.

## Key Concepts

### Team Architecture

| Role | Description |
|------|-------------|
| **Team Lead** | Coordinates, delegates, synthesizes results |
| **Teammates** | Independent context windows, own tools/permissions |

**Communication**:
- Automatic message delivery
- Shared task lists
- Direct messages between agents
- Broadcasts (to all teammates)

**Task states**: pending → in progress → completed (with dependencies)

### Enabling Agent Teams

```json
// .claude/settings.json
{
  "experimental": {
    "agentTeams": true
  }
}
```

Or environment variable:
```bash
export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=true
```

### Team Orchestration Patterns

**Fan-out / Fan-in**:
- Scatter work across teammates
- Gather and synthesize results
- Example: Review 5 modules in parallel

**Batch Processing**:
- Same task on different inputs
- Example: Process 10 files with same transformation

**Triage-then-Deep-Process**:
- One agent categorizes/prioritizes
- Others handle specific categories

**Debate Pattern**:
- Multiple agents investigate different hypotheses
- Challenge each other's conclusions

**Builder-Validator**:
- Implementation agent writes code
- Read-only validation agent reviews

### Team Management

**Delegate Mode**: Force lead to delegate instead of doing work itself.

**Plan Approval**: Review team plans before execution starts.

**Quality Gate Hooks**:
- `TeammateIdle`: Reassign when a teammate finishes
- `TaskCompleted`: Gate on tests/lint before marking done

**Display Modes**:
- Split-pane for monitoring all teammates
- Click into teammate pane for direct interaction

**Spawn Backends**:
- In-process (fastest)
- tmux (visible terminals)
- iTerm2 (split panes)

### CLAUDE.md for Teams

```markdown
## Team Configuration

### Module Boundaries
- Agent A: src/frontend/** (React components)
- Agent B: src/api/** (Express routes)
- Agent C: src/database/** (Prisma models)

DO NOT have multiple agents edit the same file.

### Shared Context
All agents should read:
- src/types/shared.ts
- docs/api-contracts.md

### Communication Protocol
- Use task dependencies for sequential work
- Broadcast only for project-wide announcements
```

### When to Use Agent Teams

First confirm a lower rung of the parallelism ladder (worktrees, dual-instance) can't do the job — teams are the experimental, token-expensive last resort.

**Good fit**:
- Genuinely parallelizable tasks
- Time savings outweigh token cost premium
- Each agent has substantial work (justifies initialization)
- Alternative (serial) would require many context resets anyway

**Bad fit**:
- Simple tasks that don't benefit from parallelism
- Heavy coordination requirements (messages are expensive)
- Near rate limits (agents compete for quota)

## Mastery Checks

- [ ] Have you run an agent team successfully?
- [ ] Do you use delegate mode to prevent lead from bottlenecking?
- [ ] Have you set up module boundaries to prevent conflicts?
- [ ] Can you evaluate when teams are cost-justified?

## Why It Matters

**Teams pay off only when the work is genuinely parallel.** Each teammate has an independent context window with no shared memory, so coordination has real overhead — the win comes from running isolated work streams at once, not from adding agents to a task that's fundamentally serial.

**Where teams produce better outcomes**:
- PR review of many files → parallel reviewers finish in the time of one
- Multi-module refactor → agents work isolated modules without stepping on each other
- Code + tests + docs → specialists run in parallel, each with focused context

**Where a solo agent wins**:
- Simple feature implementation
- Tasks needing heavy back-and-forth coordination (messages add latency and context churn)
- Debugging, which usually needs focused, serial investigation

Define module boundaries in CLAUDE.md so two agents never edit the same file, and prefer direct messages over broadcasts to keep coordination tight.

(For the token/cost angle, use the opt-in `/coach:cost` command.)

## Official Resources

- [Orchestrate Teams of Claude Code Sessions](https://code.claude.com/docs/en/agent-teams)
- [Agent Teams Controls](https://claudefa.st/blog/guide/agents/agent-teams-controls)
- [Swarm Orchestration Skill (GitHub Gist)](https://gist.github.com/kieranklaassen/4f2aba89594a4aea4ad64d753984b2ea)
