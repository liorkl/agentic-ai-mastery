---
description: Eval test cases for the coaching skill
---

# Coaching Skill — Eval Test Cases

These evals verify that the coaching skill (`skills/coaching/SKILL.md`) behaves correctly
across the most important trigger and guard-rail scenarios.

---

## Eval 1: Skill triggers on a learning question

**Input:**

> "How do I use agents in Claude Code?"

**Expected behavior:**

The coaching skill activates. It loads the user's most recent assessment (or falls back
to L0-L1 defaults), reads `knowledge/features/agents.md`, and returns a level-appropriate
explanation of agents. The response is structured as: direct answer → grounding → cost
insight → next step.

**Pass criteria:**

- Response discusses agents (`.claude/agents/`, YAML frontmatter, system prompt).
- Response references the user's detected level or notes no assessment exists.
- Response includes at least one cost-awareness note (e.g., model selection for agents).
- Response ends with a concrete next step or command.

**Fail criteria:**

- Skill does not activate; generic Claude response returned with no coaching framing.
- Response teaches L7+ orchestration concepts to a user below L5 without prerequisite note.
- No cost or token mention anywhere in the response.

---

## Eval 2: Skill does NOT trigger on a non-coaching task

**Input:**

> "Fix the off-by-one error in my sorting function."

**Expected behavior:**

The coaching skill does NOT activate. The request is a direct engineering task, not a
learning question about Claude Code, configuration, cost, or best practices. Claude
handles it as a normal code-fix task without injecting coaching framing.

**Pass criteria:**

- Response addresses the bug directly (code fix or diagnostic question).
- No coaching preamble such as "Based on your assessment…" or level references.
- `outcomes.jsonl` is NOT appended to for this interaction.

**Fail criteria:**

- Skill activates and wraps a bug fix in coaching framing.
- Response redirects user to `/coach:assess` instead of fixing the bug.
- Any mention of user "level" or curriculum progression.

---

## Eval 3: L0 user asks an L5+ concept question — prerequisites explained

**Input (with context: assessment shows `detected_level: 0`):**

> "How do I set up a multi-agent pipeline with parallel subagents?"

**Expected behavior:**

The coaching skill activates, detects the user is at Level 0, and does NOT teach
multi-agent pipelines (a Level 8+ topic). Instead it acknowledges the question,
explains what prerequisites must be mastered first (CLAUDE.md, model selection,
basic commands), and redirects to the user's current level.

**Pass criteria:**

- Response explicitly states the topic is above the user's current level.
- Response names at least two prerequisite skills or levels (e.g., Level 1: CLAUDE.md,
  Level 2: model selection).
- Response suggests a concrete next step appropriate for L0 (e.g., `/coach:next` or
  "let's start with CLAUDE.md").
- Multi-agent pipeline is NOT explained in detail.

**Fail criteria:**

- Full explanation of subagent orchestration is provided to an L0 user.
- Response skips prerequisite framing entirely.
- No redirect to current-level content or next command.

---

## Eval 4: Response includes cost-awareness insight

**Input:**

> "Should I use Claude Opus for all my agents?"

**Expected behavior:**

The coaching skill activates (cost optimization is a declared trigger). The response
explains the cost trade-off between Opus, Sonnet, and Haiku for agent tasks. It
includes concrete numbers or percentages where possible and recommends model selection
based on task complexity.

**Pass criteria:**

- Response explicitly mentions at least one pricing comparison (e.g., Haiku vs Sonnet,
  or token cost difference).
- Response gives a recommendation tied to task type (e.g., "Use Haiku for simple
  read-only agents, Sonnet for reasoning-heavy tasks").
- Response references `model:` field in agent YAML frontmatter as the control point.

**Fail criteria:**

- Response contains no pricing or cost data.
- Response recommends Opus for all tasks without qualification.
- No mention of `model:` field or how to configure per-agent model selection.

---

## Eval 5: Anti-pattern detected — flagged regardless of topic asked

**Input (with context: assessment shows `anti_patterns: ["oversized-claude-md"]`):**

> "What are the best MCP servers to install?"

**Expected behavior:**

The coaching skill activates for this learning question. Before answering MCP servers,
it surfaces the flagged anti-pattern (`oversized-claude-md`) per Rule 4 of the coaching
behavior rules. It briefly explains the cost impact of the anti-pattern, then proceeds
to answer the MCP question concisely.

**Pass criteria:**

- Response opens by flagging the `oversized-claude-md` anti-pattern before the MCP answer.
- Anti-pattern mention includes the cost impact (token overhead per interaction).
- MCP question is still answered (the flag does not replace the answer).
- Anti-pattern is classified as HIGH priority (cost waste category).

**Fail criteria:**

- Anti-pattern is not mentioned; response goes directly to MCP servers.
- Anti-pattern mention replaces the MCP answer entirely (both must appear).
- No cost or token overhead figure given for the anti-pattern.
