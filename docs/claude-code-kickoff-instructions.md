# Claude Code Kickoff Instructions (Plugin Format)
## Project: agentic-ai-mastery
## Location: ~/liorklibansky/dev/agentic-ai-mastery

---

## Pre-Requisites

```bash
# 1. Create the project directory
mkdir -p ~/liorklibansky/dev/agentic-ai-mastery
cd ~/liorklibansky/dev/agentic-ai-mastery

# 2. Initialize git
git init

# 3. Copy design documents from Claude.ai downloads
mkdir docs
# Copy into docs/:
#   requirements-v1.0.md              → docs/requirements.md
#   curriculum-v1.1.md                → docs/curriculum-v1.1.md
#   diagnostic-v1.1.md                → docs/diagnostic-v1.1.md
#   cost-guide-v1.0.md                → docs/cost-guide-v1.0.md
#   self-learning-discovery-v1.0.md   → docs/self-learning-discovery-v1.0.md

# 4. Copy the CLAUDE.md (project-CLAUDE.md → CLAUDE.md)

# 5. Open Claude Code
claude
```

---

## Prompt 1: Plugin Scaffolding

```
Read docs/requirements.md — specifically sections 3.1 (Project Structure) and 3.2 (Installation).

This project is a Claude Code plugin. Create the full plugin structure:

1. Plugin manifest: .claude-plugin/plugin.json with:
   - name: "coach"
   - description: (from FR-PLUGIN-01)
   - version: "1.0.0"
   - author: { name: "Lior Klibansky" }

2. Directories:
   - commands/
   - skills/coaching/
   - agents/
   - knowledge/features/
   - knowledge/commands/
   - knowledge/pricing/
   - knowledge/ecosystem/

3. Files:
   - LICENSE (MIT, author: Lior Klibansky)
   - .gitignore (.DS_Store, *.log, node_modules/)
   - README.md with:
     - Project overview (what this is, who it's for, works in Claude Code + Cowork)
     - Installation via marketplace: claude plugin marketplace add <repo>, claude plugin install coach@agentic-ai-mastery
     - Local install for development
     - Command reference table (all 8 /coach:* commands from FR-PLUGIN-02)
     - License
   - commands/help.md — simple command that lists all available /coach:* commands with descriptions. Include YAML frontmatter with description field.

4. Validate: run `claude plugin validate .`

Do NOT create the agent, skill, or other commands yet — those are next.

Commit: "chore: plugin scaffolding"
```

---

## Prompt 2: Coach Sub-Agent + Assessment Command

The agent handles the heavy lifting (environment scanning, discovery). Commands delegate to it.

```
Read these documents fully before writing:
- docs/requirements.md sections FR-PLUGIN-04 (agent), FR-SCAN-00 through FR-SCAN-05 (scanner)
- docs/diagnostic-v1.1.md (scan targets, quality rubric, anti-patterns)
- docs/curriculum-v1.1.md (level detection mapping)

Create agents/coach.md — the coaching sub-agent.

YAML frontmatter:
- name: coach
- description: "Deep coaching agent for environment assessment, discovery, and analysis. Delegated to by coaching commands for complex multi-step operations."
- model: sonnet
- tools: Read, LS, Glob, Grep, WebSearch, WebFetch, Write(~/.claude/coaching/**), Bash(stat, claude --version)

System prompt body (~200-300 lines, dense):

1. IDENTITY: What this agent does, its tone (direct, practical)

2. FIRST-RUN INITIALIZATION:
   - Check if ~/.claude/coaching/state/ exists
   - If not, create it with all state files using schemas from FR-STATE-01 through FR-STATE-05
   - This runs before any other operation

3. ENVIRONMENT SCANNER (the core intelligence):
   Minimal scan: 5 stat-checks (FR-SCAN-00)
   Deep scan using native tools:
   - LS .claude/ subdirectories, Read CLAUDE.md, Read settings.json
   - Glob for agent/skill/hook/rule files
   - Read .mcp.json, check file counts
   - Level detection table (FR-SCAN-02)
   - CLAUDE.md quality scoring rubric (FR-SCAN-03, all 10 elements with points)
   - Anti-pattern detection list (FR-SCAN-04, all patterns with severity)
   - Gap detection: features missing below detected level
   - Privacy rules: NEVER read .env, credentials, secrets, keys

4. OUTPUT FORMAT:
   Structured assessment output including: detected level, CLAUDE.md score, features found, gaps, anti-patterns, recommendations
   Append to ~/.claude/coaching/state/assessments.jsonl

5. DISCOVERY PROTOCOL:
   When triggered: check claude --version, WebFetch GitHub CHANGELOG, classify changes, append to discoveries.jsonl

6. SAFETY:
   Files never to read, write only to ~/.claude/coaching/, never modify user config

Then create commands/assess.md:
- YAML frontmatter: description: "Scan your Claude Code environment and report your skill level, gaps, and anti-patterns"
- Body: Instructions to delegate the full assessment to the coach agent, then display the results. Include instructions for first-run initialization check.

Then create commands/status.md:
- YAML frontmatter: description: "Show current coaching level, last assessment date, and discovery staleness"
- Body: Read latest assessment from ~/.claude/coaching/state/assessments.jsonl, read discovery-state.json for staleness, display summary.

Commit: "feat: coach agent + assess/status commands"
```

---

## Prompt 3: Seed Knowledge Base

```
Read docs/curriculum-v1.1.md and docs/cost-guide-v1.0.md.

Create knowledge base files under knowledge/. Each file must:
- Start with metadata comment: topic, last updated, source docs, curriculum level
- Follow structure: Current State → Key Concepts → Mastery Checks → Cost Implications → Official Resources
- Stay under 500 lines, be factual and dense
- Include Feb 2026 pricing where relevant

Create these 13 files:
1. knowledge/features/models.md — L0-L1: model selection, pricing, effort levels
2. knowledge/features/output-styles.md — L1: output styles, customization
3. knowledge/features/context.md — L3: context engineering, CLAUDE.md, @imports, rules
4. knowledge/features/skills.md — L4: skills framework, SKILL.md format
5. knowledge/features/agents.md — L5: custom agents, delegation, YAML frontmatter
6. knowledge/features/hooks.md — L6: hooks system, event types
7. knowledge/features/mcp.md — L7: MCP servers, tool search
8. knowledge/features/headless.md — L8: headless mode, harness pattern, SDK, CI/CD
9. knowledge/features/teams.md — L9: agent teams, orchestration
10. knowledge/commands/commands-ref.md — slash commands reference
11. knowledge/pricing/pricing-current.md — Feb 2026 pricing, model comparison, cost strategies
12. knowledge/ecosystem/cowork.md — Cowork overview, plugin compatibility
13. knowledge/ecosystem/api.md — API capabilities for developers

After creating, verify:
- wc -l knowledge/**/*.md (each <500, total <5,000)
- All 11 curriculum levels covered

Commit: "feat: seed knowledge base"
```

---

## Prompt 4: Coaching Skill + Teaching Commands

```
Read docs/requirements.md sections FR-PLUGIN-03 (skill), FR-PLUGIN-05 (behavior rules), FR-PLUGIN-06 (context loading).

Create skills/coaching/SKILL.md:
- YAML frontmatter: name, description (triggers on learning/coaching questions)
- Body: coaching behavior rules, level awareness (read latest assessment), how to load relevant knowledge files, cost awareness mandate, anti-pattern flagging, outcome logging to ~/.claude/coaching/state/outcomes.jsonl

Create commands/next.md:
- description: "Get your next lesson based on current skill level and gaps"
- Body: Read latest assessment, identify current level and top-priority gap, load the relevant knowledge file from knowledge/features/, deliver a 200-400 word lesson grounded in the user's actual files, include cost awareness, append outcome to outcomes.jsonl

Create commands/exercise.md:
- description: "Get a hands-on exercise for your current skill level"
- Body: Read assessment, design a practical exercise the user can do in their current project, include clear success criteria they can verify, target current level or gap

Create commands/cost.md:
- description: "Get cost optimization coaching for your current level"
- Body: Read assessment level, load knowledge/pricing/pricing-current.md, deliver level-appropriate cost coaching from the cost guide annotations

Commit: "feat: coaching skill + teaching commands"
```

---

## Prompt 5: Discovery Commands

```
Read docs/self-learning-discovery-v1.0.md and docs/requirements.md sections FR-DISC-01 through FR-DISC-03.

Create commands/discover.md:
- description: "Check for new Claude Code features and updates"
- Body: Delegate to coach agent for full discovery protocol (version check, changelog fetch, classification, knowledge update)

Create commands/whats-new.md:
- description: "Show recent Claude Code changes that affect your learning"
- Body: Read ~/.claude/coaching/state/discoveries.jsonl, filter for recent and curriculum-relevant entries, format as digest

Commit: "feat: discovery commands"
```

---

## Prompt 6: Install, Test, Iterate

```
Let's test the plugin end-to-end.

1. Validate the plugin: run `claude plugin validate .`

2. Fix any validation issues

3. Update README.md with final installation instructions and CHANGELOG.md

Commit: "docs: final README + CHANGELOG"
```

After this commit, exit Claude Code and test:

```bash
# Start fresh Claude Code session
cd ~/liorklibansky/dev/agentic-ai-mastery
claude

# Add as local marketplace and install
/plugin marketplace add .
/plugin install coach@agentic-ai-mastery

# Restart Claude Code, then go to a real project:
cd ~/some-real-project
claude

# Test all commands
/coach:help
/coach:assess
/coach:next
/coach:cost
/coach:status

# Test skill auto-trigger (ask naturally):
"How should I structure my CLAUDE.md for better results?"

# Test in Cowork (open Claude Desktop app):
# Click Cowork tab, install plugin, try /coach:assess
```

---

## Prompt 7: Fix Issues From Testing

Template — adapt based on what you find:

```
I tested the coach plugin against [my project]. Here's what happened:

[Paste output or describe behavior]

Issues:
1. [e.g., "/coach:assess returned generic advice instead of scanning my files"]
2. [e.g., "Skill didn't auto-trigger when I asked about agents"]
3. [e.g., "State directory wasn't created on first run"]

Fix these issues. After fixing, re-read the relevant sections of docs/requirements.md to ensure alignment with the spec.

Commit: "fix: [description]"
```

---

## Working With Claude Code — Tips

**Session pattern:** One prompt per commit. /clear between prompts.

**Model:** Use Sonnet — this project doesn't need Opus.

**Reference docs:** Use `@docs/requirements.md` to point Claude Code at sections.

**Plugin validation:** Run `claude plugin validate .` after each structural change.

**Iteration > perfection:** The agent system prompt and command instructions will need 3-5 rounds of testing. That's expected. Ship, test, iterate.

**Testing in Cowork:** Install the plugin, open Cowork tab, point it at a project folder. Verify `/coach:assess` works. This validates cross-compatibility.
