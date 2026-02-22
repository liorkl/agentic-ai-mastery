<!--
topic: Agent Teams
last_updated: February 2026
source_docs: curriculum-v1.1.md, cost-guide-v1.0.md
curriculum_level: L9
-->

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

## Cost Implications

**Agent teams multiply costs**:
```
N agents × (system prompt + CLAUDE.md + tool defs + task context)
```

**Each teammate has independent context window**:
- No shared memory
- Some duplication unavoidable
- Teammates load project context but NOT lead's conversation history

**Broadcast messages scale with team size**:
- Broadcast to 5 agents = 5× cost of single message
- Use direct messages when possible

**Fast Mode** (Opus 4.6): 2.5x speed for interactive team work, but 6x standard rates.

**The ROI calculation**:
> Before spinning up a team, calculate: Does the time savings justify 3-5x the token cost? Often, a well-prompted solo agent with `/clear` between sub-tasks is cheaper AND faster.

**Cost-justified scenarios**:
- PR review of 10 files → 10 parallel reviewers finish in time of 1
- Multi-module refactor → parallel work on isolated modules
- Code + tests + docs → three specialists in parallel

**NOT cost-justified**:
- Simple feature implementation
- Tasks requiring heavy back-and-forth coordination
- Debugging (usually needs focused, serial investigation)

## Official Resources

- [Orchestrate Teams of Claude Code Sessions](https://code.claude.com/docs/en/agent-teams)
- [Agent Teams Controls](https://claudefa.st/blog/guide/agents/agent-teams-controls)
- [Swarm Orchestration Skill (GitHub Gist)](https://gist.github.com/kieranklaassen/4f2aba89594a4aea4ad64d753984b2ea)
