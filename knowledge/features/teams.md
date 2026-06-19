<!-- file: knowledge/features/teams.md -->
<!-- last-updated: 2026-06-19 -->
<!-- source: https://code.claude.com/docs/en/best-practices -->
<!-- curriculum_level: L9 -->

# Agent Teams

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
