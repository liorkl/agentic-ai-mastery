# Claude Code Coaching Agent — Requirements
## Project: agentic-ai-mastery

**Version:** 1.0
**Date:** February 20, 2026
**Status:** Pre-implementation

---

## 1. Project Overview

### 1.1 Vision

A Claude Code custom agent that teaches developers to master agentic AI development progressively — from first install to system-level design. The coach lives inside the developer's Claude Code workflow, assesses skill level by scanning their environment, delivers targeted coaching through real work (not abstract exercises), and improves its own teaching over time.

### 1.2 Why a Plugin (Not MCP, Not Standalone Agent, Not API Product)

| Option Considered | Decision | Rationale |
|------------------|----------|-----------|
| MCP Server | Rejected for v1 | Overhead of running a server; coaching doesn't need custom tools |
| Claude.ai Skill | Rejected | Lives in Claude.ai, not Claude Code/Cowork where the target user works |
| API-based SaaS | Deferred | Future product; v1 validates the coaching model first |
| Standalone Custom Agent | Evolved from | Works but limited to Claude Code only, manual copy install, no marketplace |
| **Plugin** | **Selected** | Works in Claude Code AND Cowork, marketplace distribution, one-command install, namespaced commands (`/coach:*`), auto-triggered skills, sub-agents for complex flows |

### 1.3 Design Documents (Source of Truth)

These documents contain the detailed designs. Requirements below reference them. The implementation should consult these when building each component.

| Document | Contents | File |
|----------|----------|------|
| Curriculum v1.1 | 11-level progression (L0–L10), mastery checks, teaching content | `claude-code-mastery-curriculum-v1.1.md` |
| Environment Diagnostic v1.1 | Scan targets, quality heuristics, gap detection, anti-patterns | `environment-diagnostic-framework-v1.1.md` |
| Cost Optimization Guide v1.0 | Pricing reference, cross-cutting cost annotations per level, monitoring tools | `cost-optimization-guide-v1.0.md` |
| Self-Learning & Discovery v1.0 | Outcome tracking, retrospective protocol, weekly discovery, knowledge base structure | `self-learning-discovery-architecture-v1.0.md` |

---

## 2. Scope

### 2.1 v1.0 Scope (Build Now)

**Core agent:**
- Coach agent file (`coach.md`) with YAML frontmatter and system prompt
- Responds to explicit coaching commands (listed below)
- Also available for auto-delegation when Claude detects coaching-related questions

**Environment scanner:**
- Passive skill assessment by reading project/global configuration files
- Level detection algorithm (L0–L10)
- Gap detection (identifies missing foundations below current level)
- Anti-pattern flagging
- Privacy-safe (never reads .env, credentials, secrets)

**Curriculum delivery:**
- Teaches from the 11-level curriculum
- Adapts to detected level — never teaches above or skips below
- Includes cost awareness at every level
- References official learning resources

**Knowledge base (seed):**
- Structured reference files extracted from design documents
- Organized by feature area for targeted context loading
- The coach loads ONLY files relevant to the current coaching topic (context budget discipline)

**State management:**
- JSONL-based progress tracking (assessments, outcomes)
- File-based persistence in `.claude/coaching/`
- Discovery state file (last scan timestamp, known version)

**Weekly discovery (simplified):**
- Version check on coach startup if >7 days stale
- Changelog scan via web_fetch of GitHub CHANGELOG.md
- Classification of curriculum-relevant vs. noise
- Append to discoveries.jsonl
- Human-readable digest update

**Basic self-learning:**
- Outcome logging after each coaching interaction
- Evidence-based outcome detection via environment scan deltas
- Strategy file that the coach reads on startup (manually updated initially, auto-updated later)

### 2.2 Explicitly Deferred (Backlog)

| Item | Reason | Backlog Priority |
|------|--------|-----------------|
| 24-hour real-time discovery service | Separate product, overkill for coaching agent | Future product |
| Standalone AI dev skill assessment (web/chat) | Separate product, not project-tied | Future product |
| Retrospective auto-analysis | Needs ~20+ data points first; build after weeks of usage | v1.1 |
| Auto-updating strategies.md | Needs retrospective working first | v1.1 |
| Community scanning (Phase 3 discovery) | Official sources cover 90% of needs | v1.2 |
| Web dashboard / progress visualization | SaaS layer; premature before coaching model validated | v2.0 |
| Multi-user support | Solo developer tool first | v2.0 |
| Distribution / packaging (npm, marketplace) | Ship locally first, package later | v1.2 |
| Prompt feedback system ("ears") | Real-time coaching on prompt quality; complex | v1.1 |
| Integration with ccusage data | Would enable cost coaching with real data | v1.1 |

### 2.3 Success Criteria for v1.0

The v1.0 is successful when:

1. A developer can install the coach via `claude plugin install` or by copying files
2. Running `/coach:help` lists commands; asking a coaching question triggers the skill
3. `/coach:assess` accurately detects the developer's skill level from their environment
4. `/coach:next` delivers relevant, level-appropriate teaching
5. The coach identifies and flags gaps and anti-patterns
6. Progress persists across sessions via JSONL files in `~/.claude/coaching/state/`
7. Weekly discovery detects Claude Code version changes and new features
8. The coach's own context overhead stays under ~3,000 tokens per session
9. The coach never reads sensitive files (.env, credentials, keys)
10. The plugin works in both Claude Code and Cowork

---

## 3. Technical Requirements

### 3.1 Project Structure (Plugin Format)

The project IS a Claude Code plugin. The repo root is the plugin directory.

```
agentic-ai-mastery/                        # ~/liorklibansky/dev/agentic-ai-mastery
├── .claude-plugin/
│   └── plugin.json                        # Plugin manifest (name, version, author)
│
├── commands/                              # User-invoked slash commands (/coach:*)
│   ├── assess.md                          # /coach:assess
│   ├── next.md                            # /coach:next
│   ├── status.md                          # /coach:status
│   ├── exercise.md                        # /coach:exercise
│   ├── whats-new.md                       # /coach:whats-new
│   ├── discover.md                        # /coach:discover
│   ├── cost.md                            # /coach:cost
│   └── help.md                            # /coach:help
│
├── skills/                                # Auto-triggered by Claude on context match
│   └── coaching/
│       └── SKILL.md                       # Core coaching behavior + level awareness
│
├── agents/                                # Sub-agents for complex flows
│   └── coach.md                           # Deep coaching agent (scan logic, curriculum ref)
│
├── knowledge/                             # Reference files, read on-demand
│   ├── features/
│   │   ├── agents.md                      # L5 content
│   │   ├── skills.md                      # L4 content
│   │   ├── hooks.md                       # L6 content
│   │   ├── mcp.md                         # L7 content
│   │   ├── models.md                      # L0-L1 content
│   │   ├── context.md                     # L3 content
│   │   ├── output-styles.md               # L1 content
│   │   ├── teams.md                       # L9 content
│   │   └── headless.md                    # L8 content
│   ├── commands/
│   │   └── commands-ref.md
│   ├── pricing/
│   │   └── pricing-current.md
│   └── ecosystem/
│       ├── cowork.md
│       └── api.md
│
├── docs/                                  # Design documents (dev reference only)
│   ├── requirements.md
│   ├── curriculum-v1.1.md
│   ├── diagnostic-v1.1.md
│   ├── cost-guide-v1.0.md
│   └── self-learning-discovery-v1.0.md
│
├── CLAUDE.md                              # Project dev instructions
├── README.md                              # Installation, usage, marketplace
└── LICENSE                                # MIT
```

**Plugin component roles:**

| Component | Location | Trigger | Purpose |
|-----------|----------|---------|---------|
| Commands | `commands/*.md` | User types `/coach:assess` etc. | Explicit coaching actions |
| Skill | `skills/coaching/SKILL.md` | Auto — Claude detects learning questions | Passive coaching behavior |
| Agent | `agents/coach.md` | Delegated by commands/skill for complex flows | Deep analysis, full discovery |
| Knowledge | `knowledge/**/*.md` | Read on-demand by commands/skill/agent | Curriculum content |

**State directory** (`~/.claude/coaching/state/`) is created at runtime by commands/agent using Claude's Write tool. State persists across sessions and projects — NOT inside the plugin directory.

**Works in both Claude Code AND Cowork** — commands and skills are cross-compatible.

**Marketplace distribution:** The repo root doubles as a marketplace. Add `.claude-plugin/marketplace.json` alongside `plugin.json`:

```json
{
  "name": "agentic-ai-mastery",
  "owner": { "name": "Lior Klibansky" },
  "plugins": [{
    "name": "coach",
    "source": ".",
    "description": "Coaches developers to master agentic AI development through 11 progressive levels"
  }]
}
```

Users install with: `claude plugin marketplace add liorklibansky/agentic-ai-mastery` then `claude plugin install coach@agentic-ai-mastery`.

### 3.2 Installation (User Perspective)

**Option A — From marketplace (preferred):**

```bash
# Add the marketplace
claude plugin marketplace add liorklibansky/agentic-ai-mastery

# Install the coach plugin
claude plugin install coach@agentic-ai-mastery
```

One command installs everything. Plugin is available in every Claude Code AND Cowork session.

**Option B — Local install (development / testing):**

```bash
# Clone the repo
git clone <repo-url> ~/dev/agentic-ai-mastery

# In Claude Code, add as local marketplace
/plugin marketplace add ~/dev/agentic-ai-mastery
/plugin install coach@agentic-ai-mastery
```

**What the user gets after install:**
- Slash commands: `/coach:assess`, `/coach:next`, `/coach:cost`, etc.
- Auto-triggered skill: Claude automatically coaches when learning questions detected
- Sub-agent: available for complex coaching flows
- All knowledge files bundled and accessible

**What the plugin creates at runtime (first invocation):**
- `~/.claude/coaching/state/` directory
- `~/.claude/coaching/state/assessments.jsonl`
- `~/.claude/coaching/state/outcomes.jsonl`
- `~/.claude/coaching/state/discoveries.jsonl`
- `~/.claude/coaching/state/discovery-state.json`
- `~/.claude/coaching/state/strategies.md`

State files persist across sessions and projects. Assessments include project path for per-project analysis.

### 3.3 Runtime Constraints

| Constraint | Requirement |
|-----------|-------------|
| **Write scope** | Coach may ONLY write to `~/.claude/coaching/**` |
| **Read scope** | Coach may read `~/.claude/**`, project `.claude/**`, `CLAUDE.md`, project root config files |
| **Forbidden reads** | `.env*`, `**/credentials*`, `**/secrets*`, `**/*.key`, `**/*.pem` |
| **Network** | Web search/fetch for discovery ONLY (not during regular coaching) |
| **Context budget** | Coach loads ≤3,000 tokens of coaching-specific context per session |
| **Model** | Coach agent should specify `model: sonnet` (no need for Opus overhead) |
| **Tool restrictions** | Read-only for project files; write only to `~/.claude/coaching/` |
| **Auto-scan** | Minimal scan on every invocation (<5 seconds). Deep scan only when triggered by changes, gaps, or explicit `assess` command |

### 3.4 File Formats

**JSONL files** (assessments.jsonl, outcomes.jsonl, discoveries.jsonl):
- One JSON object per line
- UTF-8 encoding
- Append-only during normal operation
- Schema defined per file (see Section 4)

**Knowledge base files** (knowledge/**/*.md):
- Markdown with metadata header comments
- Updated by discovery process only
- Under 500 lines each (context budget discipline)

**State files** (discovery-state.json, coaching-config.json):
- Standard JSON
- Read on startup, updated on session end

**Strategy file** (strategies.md):
- Markdown
- Read by coach on every session
- Updated by retrospective process (v1.1) or manually (v1.0)

---

## 4. Functional Requirements

### 4.1 Plugin Components

#### FR-PLUGIN-01: Plugin Manifest

`.claude-plugin/plugin.json`:

```json
{
  "name": "coach",
  "description": "Coaches developers to master agentic AI development. Assesses skill by scanning your Claude Code/Cowork environment, teaches from an 11-level curriculum, tracks progress, discovers new features.",
  "version": "1.0.0",
  "author": { "name": "Lior Klibansky" }
}
```

#### FR-PLUGIN-02: Commands (User-Invoked)

Each command is a markdown file in `commands/` with YAML frontmatter (`description` field). Commands are invoked as `/coach:<command-name>`.

| Command | File | Behavior | Priority |
|---------|------|----------|----------|
| `/coach:assess` | `commands/assess.md` | Delegate to coach agent for full environment scan, level report, gaps, anti-patterns | P0 |
| `/coach:next` | `commands/next.md` | Read assessment, load relevant knowledge file, deliver level-appropriate lesson | P0 |
| `/coach:status` | `commands/status.md` | Show current level, last assessment date, discovery staleness | P0 |
| `/coach:exercise` | `commands/exercise.md` | Hands-on exercise with clear success criteria | P1 |
| `/coach:whats-new` | `commands/whats-new.md` | Show discovery digest of recent changes | P1 |
| `/coach:discover` | `commands/discover.md` | Delegate to coach agent for full discovery protocol | P1 |
| `/coach:cost` | `commands/cost.md` | Cost-relevant coaching for current level | P1 |
| `/coach:help` | `commands/help.md` | List commands and current coaching state | P0 |

Each command markdown file contains instructions for Claude: which files to read, what to scan, what to output, and what state to update (append to outcomes.jsonl).

#### FR-PLUGIN-03: Coaching Skill (Auto-Triggered)

`skills/coaching/SKILL.md` auto-triggers when Claude detects coaching-relevant context — no explicit command needed. This enables natural coaching during regular work.

```yaml
---
name: coaching
description: >
  Coaches developers on Claude Code and Cowork mastery. Triggers when the user
  asks about learning, best practices, configuration, features, or cost optimization.
  Examples: "how do I use agents", "what's the best way to structure CLAUDE.md"
---
```

Skill body contains: coaching tone/behavior rules, level awareness (read latest assessment), knowledge loading instructions, cost awareness mandate, anti-pattern flagging, and outcome logging.

#### FR-PLUGIN-04: Coach Sub-Agent

`agents/coach.md` handles complex multi-step flows via context isolation:
- Full deep assessment (reads many files, produces structured report)
- Full discovery protocol (web fetch, classification, knowledge updates)
- Retrospective analysis (reads outcome history, identifies patterns)

Commands like `/coach:assess` and `/coach:discover` delegate to this agent. It returns a summary to the user's main context.

```yaml
---
name: coach
description: Deep coaching agent for assessment, discovery, and analysis.
model: sonnet
tools: [Read, LS, Glob, Grep, WebSearch, WebFetch, "Write(~/.claude/coaching/**)", "Bash(stat, claude --version)"]
---
```

Agent body contains full scan logic, level detection algorithm, quality scoring rubric, and anti-pattern detection list.

#### FR-PLUGIN-05: Coaching Behavior Rules

1. **Never skip levels.** If user is Level 3, don't teach Level 7 concepts even if asked. Instead explain what prerequisites are needed.
2. **Always ground in real work.** Don't give abstract explanations. Reference the user's actual files and configuration.
3. **Include cost awareness.** Every teaching should mention cost implications where relevant.
4. **Flag anti-patterns immediately.** If the scan detects a security or cost anti-pattern, mention it regardless of what was asked.
5. **Be concise.** Coaching messages should be actionable, not lecture-length. Target 200-400 words per coaching response.
6. **Reference official sources.** Link to Anthropic docs, Academy courses, or engineering blog posts when relevant.
7. **Track everything.** Append to outcomes.jsonl after each coaching interaction.
8. **Practice context hygiene.** Load only the knowledge files relevant to the current topic. Never load the entire knowledge base.

#### FR-PLUGIN-06: Context Loading Strategy

Commands and the coaching skill implement progressive context loading:

```
On every command/skill invocation:
  ALWAYS load: strategies.md from ~/.claude/coaching/state/ (~200 tokens)
  ALWAYS load: latest assessment from assessments.jsonl (~100 tokens)
  ALWAYS load: last 5 outcomes from outcomes.jsonl (~300 tokens)

On /coach:assess (delegated to agent):
  Agent reads project files directly using native tools (~500 tokens)

On /coach:next or teaching at Level N:
  ALSO load: knowledge/features/<relevant-file>.md (~400 tokens)
  ALSO load: knowledge/pricing/pricing-current.md IF cost topic (~300 tokens)

On /coach:discover (delegated to agent):
  ALSO load: discovery-state.json (~100 tokens)
  Agent fetches changelog via WebFetch

Target total: ≤3,000 tokens of coaching context per interaction
```

### 4.2 Environment Scanner

#### FR-SCAN-00: Two-Tier Scan Architecture

The agent performs scanning using its native tools (LS, Read, Glob, Grep, Bash for `stat` commands) — no external scripts required.

**Minimal scan** (runs automatically on every coach invocation):

Purpose: Quick fingerprint to detect if anything changed since last full scan.

```
Checks:
1. Does ~/.claude/coaching/assessments.jsonl exist? (first-run detection)
2. CLAUDE.md — exists? modified since last scan? (stat check, not content parse)
3. .claude/ directory — file count changed since last scan?
4. ~/.claude/ global config — modified since last scan?
5. claude --version — changed since last known?

Decision logic:
- First run ever → trigger deep scan
- Any file modified since last assessment → trigger deep scan
- Version changed → trigger deep scan + discovery
- Nothing changed → use cached assessment, proceed to coaching
```

**Deep scan** (runs when minimal scan detects changes OR on explicit `/coach:assess`):

Purpose: Full environment analysis with level detection, quality scoring, gap analysis, and anti-pattern detection. All FR-SCAN-01 through FR-SCAN-05 below apply to the deep scan.

This two-tier approach means the coach starts fast on repeat visits but stays current when the environment changes.

#### FR-SCAN-01: Scan Targets

The scanner must check all targets defined in the Diagnostic Framework v1.1:

**Project-level (`.claude/`):**
- agents/ (presence, count, quality of files)
- skills/ (presence, SKILL.md format, progressive disclosure, evals/)
- hooks/ (presence, event types, patterns)
- rules/ (presence, count)
- output-styles/ (presence, custom styles)
- .mcp.json (presence, server count)
- settings.json / settings.local.json (sophistication level)

**Project root:**
- CLAUDE.md (presence, quality score based on 10 weighted elements)
- Multiple CLAUDE.md files in subdirectories (architecture awareness)
- AGENTS.md symlink (cross-tool compatibility)
- claude-progress.txt (harness pattern indicator)

**Global (`~/.claude/`):**
- Personal skills, agents, output-styles, commands
- ~/.claude.json (global MCP servers)

#### FR-SCAN-02: Level Detection Algorithm

Map scan results to curriculum levels using the highest-level feature detected:

| Detected Feature | Minimum Level |
|-----------------|---------------|
| No configuration at all | Level 0 |
| Basic CLAUDE.md exists | Level 1 |
| CLAUDE.md with quality score ≥6/10 + settings.json | Level 2 |
| Multiple CLAUDE.md + rules/ + @imports | Level 3 |
| skills/ with SKILL.md format | Level 4 |
| agents/ with custom agents | Level 5 |
| hooks/ with configured hooks | Level 6 |
| .mcp.json with servers | Level 7 |
| claude-progress.txt + headless indicators | Level 8 |
| Agent teams config (experimental flag) | Level 9 |
| All of the above with quality + governance | Level 10 |

**Important:** Detected level is the highest feature present, but gaps below that level are flagged as HIGH priority coaching targets.

#### FR-SCAN-03: Quality Scoring

**CLAUDE.md quality score (10 points):**

| Element | Points | Weight Rationale |
|---------|--------|-----------------|
| Build command | 2 | Prevents most expensive failure mode |
| Test command | 2 | Enables quality verification |
| Architecture description | 1 | Reduces exploratory file reading |
| Code style/conventions | 1 | Prevents rework |
| Constraints/DO NOTs | 1 | Prevents wasteful operations |
| @imports used | 1 | Shows modular thinking |
| Under 150 lines | 1 | Context budget discipline |
| Project-specific content (not generic) | 1 | Shows intentional configuration |

#### FR-SCAN-04: Anti-Pattern Detection

The scanner must flag all anti-patterns listed in the Diagnostic Framework v1.1 and Cost Optimization Guide v1.0. Each anti-pattern produces a structured finding:

```jsonc
{
  "anti_pattern": "claude_md_too_long",
  "severity": "medium",  // low, medium, high, critical
  "current_value": "237 lines",
  "recommendation": "Split into rules/ files or use @imports. Target: <150 lines.",
  "cost_impact": "Loaded every message. ~237 tokens of overhead on every interaction.",
  "curriculum_level": 2
}
```

#### FR-SCAN-05: Privacy

- NEVER read files matching: `.env*`, `*credentials*`, `*secret*`, `*.key`, `*.pem`, `*password*`, `*token*` (as filenames)
- NEVER read file contents outside `.claude/`, `CLAUDE.md`, and project root config files
- ALWAYS inform the user what was scanned at the end of an assessment
- Log the scan scope in assessments.jsonl

### 4.3 Knowledge Base

#### FR-KB-01: Seed Knowledge Base

On first setup, knowledge base files are seeded from the design documents. Each file follows the standard format:

```markdown
<!-- .claude/coaching/knowledge/features/<topic>.md -->
<!-- COACH KNOWLEDGE BASE — Last updated: 2026-02-20 -->
<!-- Source: curriculum-v1.1, cost-guide-v1.0 -->

# <Topic> Knowledge Base

## Current State (as of Claude Code v<version>)

### Core Capabilities
- ...

### Recent Changes
- [v<version>] <change description>

### Coaching Relevance
- Curriculum level: <N>
- Cost considerations: ...
- Common anti-patterns: ...
- Mastery check: <criteria from curriculum>
```

#### FR-KB-02: Knowledge File Size Limits

- Each file: ≤500 lines
- Total knowledge base: ≤5,000 lines across all files
- If a file exceeds 500 lines, split by subtopic

#### FR-KB-03: Discovery Updates

When the discovery process finds curriculum-relevant changes:
1. Append raw finding to `discoveries.jsonl`
2. Update the relevant `knowledge/features/<topic>.md` file's "Recent Changes" section
3. Update `discovery-digest.md` with human-readable summary
4. Update `discovery-state.json` with new timestamps and version

### 4.4 State Management

All state files live in `~/.claude/coaching/state/`. The agent creates this directory and all files on first invocation with correct defaults — no templates needed.

#### FR-STATE-01: assessments.jsonl

Location: `~/.claude/coaching/state/assessments.jsonl`

One entry per environment scan:

```jsonc
{
  "timestamp": "2026-02-20T14:30:00Z",
  "project_path": "/Users/dev/my-project",
  "detected_level": 3,
  "claude_md_score": 7,
  "features_detected": ["claude_md", "settings_json", "rules_dir", "imports"],
  "features_missing_below_level": ["test_commands"],
  "anti_patterns": [
    { "id": "mcp_server_count", "severity": "medium", "value": "9 servers" }
  ],
  "gaps": [
    { "level": 2, "gap": "No test commands in CLAUDE.md", "priority": "high" }
  ],
  "scan_scope": [".claude/", "CLAUDE.md", "~/.claude/"],
  "claude_code_version": "2.1.8"
}
```

#### FR-STATE-02: outcomes.jsonl

One entry per coaching interaction:

```jsonc
{
  "timestamp": "2026-02-20T15:00:00Z",
  "session_id": "coach-20260220",
  "user_level_at_time": 3,
  "topic": "context-engineering",
  "subtopic": "compact-custom-instructions",
  "coaching_action": "taught",    // taught, reinforced, exercised, flagged-antipattern
  "exercise_given": false,
  "applied": null,                // null=unknown, true, false — populated by future scans
  "evidence_type": null,          // env_change, behavior_change, self_report, none
  "notes": null
}
```

#### FR-STATE-03: discoveries.jsonl

One entry per discovery finding:

```jsonc
{
  "timestamp": "2026-02-20T10:30:00Z",
  "source": "github_changelog",
  "source_version": "2.1.9",
  "classification": "curriculum-relevant",  // curriculum-relevant, diagnostic-relevant, informational, noise
  "title": "Nested skills auto-discovery",
  "description": "Skills in nested .claude/skills directories now auto-discovered",
  "affected_levels": [4],
  "cost_impact": null,
  "status": "pending"             // pending, integrated, dismissed
}
```

#### FR-STATE-04: discovery-state.json

```jsonc
{
  "last_discovery_run": "2026-02-20T10:00:00Z",
  "last_known_claude_code_version": "2.1.8",
  "last_known_changelog_entry": "v2.1.8",
  "curriculum_version": "1.1",
  "knowledge_base_seeded": true
}
```

#### FR-STATE-05: strategies.md

In v1.0, this file is manually maintained (auto-updates deferred to v1.1). Initial content:

```markdown
<!-- .claude/coaching/strategies.md -->
<!-- Coaching strategy — manually maintained in v1.0 -->

## Default Coaching Approach
- Lead with practical, show concrete files/commands
- One concept per coaching interaction
- Always include cost implications
- Reference official sources
- Flag anti-patterns immediately even if not asked

## Pacing
- New users (L0-L2): More explanation, slower pace
- Intermediate (L3-L5): Balance explanation with challenges
- Advanced (L6+): Brief coaching, focus on patterns and trade-offs

## Teaching Preference Observations
(Update this section as you observe what works for this user)
- Preferred style: [not yet known]
- Sticking points: [not yet known]
- Strengths: [not yet known]
```

### 4.5 Discovery System

#### FR-DISC-01: Trigger Conditions

Discovery runs when:
- Coach is invoked AND `discovery-state.json` shows >7 days since last run
- User explicitly runs `/coach:discover` or `/coach:whats-new`

Discovery DOES NOT run:
- On every coach session (too expensive)
- In the background (no scheduler)
- When network is unavailable (graceful skip)

#### FR-DISC-02: Discovery Protocol (Weekly)

```
1. RUN: claude --version (local, free)
   → Compare against last_known_claude_code_version

2. IF version changed OR >7 days since last scan:
   a. FETCH: https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md (raw)
   b. EXTRACT entries between last_known_changelog_entry and current
   c. CLASSIFY each entry:
      - curriculum-relevant: new feature, new command, deprecation, pricing change
      - diagnostic-relevant: new config file/setting, new env variable
      - informational: bug fix, perf improvement
      - noise: internal refactoring, CI changes
   d. APPEND curriculum-relevant and diagnostic-relevant to discoveries.jsonl
   e. UPDATE affected knowledge base files
   f. REWRITE discovery-digest.md
   g. UPDATE discovery-state.json

3. SEARCH: "Anthropic Claude Code new features [current month year]"
   → Check for blog posts, docs updates, model launches
   → Same classify → append → update flow

4. REPORT: Brief summary to user
   "Found N updates since your last session. [M] are relevant to your current level."
```

#### FR-DISC-03: Graceful Degradation

| Failure | Behavior |
|---------|----------|
| Network unavailable | Skip discovery, log reason, coach from existing knowledge |
| CHANGELOG.md fetch fails | Try web_search as fallback, then skip |
| Contradictory information found | Prefer official sources, flag for manual review |
| Knowledge file missing/corrupted | Rebuild from seed, log the incident |
| JSONL corrupted | Start fresh file, log warning |

---

## 5. Non-Functional Requirements

### NFR-01: Performance
- Coach response time: No artificial delay. The agent should respond as fast as any Claude Code agent.
- Environment scan: Complete in <30 seconds for a typical project.
- Discovery: Complete in <3 minutes including web fetches.

### NFR-02: Context Efficiency
- Coach overhead: ≤3,000 tokens of coaching-specific context per session.
- Knowledge loading: Only files relevant to current topic loaded.
- History loading: Only last 5 outcomes + latest assessment.

### NFR-03: Privacy & Safety
- Never read sensitive files (see FR-SCAN-05).
- Never write outside `.claude/coaching/`.
- Never modify user's existing configuration files.
- Always inform user what was scanned.

### NFR-04: Resilience
- Missing state files: Create defaults, don't crash.
- Corrupted JSONL: Start fresh, don't crash.
- Missing knowledge files: Coach from system prompt knowledge, flag for rebuild.
- Network failure during discovery: Skip gracefully, coach from existing knowledge.

### NFR-05: Portability
- Must work on macOS and Linux (Claude Code's supported platforms).
- No external scripts or dependencies — agent uses native tools (Read, LS, Glob, Grep, Bash, WebSearch, WebFetch).
- Installation is file copy only — no build step, no package manager.

---

## 6. Implementation Plan

### Phase 1: Plugin Foundation

| Step | Deliverable | Depends On | Acceptance Test |
|------|------------|------------|-----------------|
| 1.1 | Plugin scaffolding: `.claude-plugin/plugin.json`, directory structure, CLAUDE.md, README, LICENSE | Nothing | `claude plugin validate .` passes |
| 1.2 | Coach sub-agent (`agents/coach.md`) with scan logic + level detection | 1.1 | Agent can scan a project and return structured assessment |
| 1.3 | Core commands: `commands/assess.md`, `commands/help.md`, `commands/status.md` | 1.2 | `/coach:assess` delegates to agent and returns level report |

### Phase 2: Knowledge & Teaching

| Step | Deliverable | Depends On | Acceptance Test |
|------|------------|------------|-----------------|
| 2.1 | Seed knowledge base files (all `knowledge/**/*.md`) | 1.1 | Files exist, each <500 lines, cover all 11 levels |
| 2.2 | Coaching skill (`skills/coaching/SKILL.md`) + teaching commands (`next.md`, `exercise.md`, `cost.md`) | 1.3 + 2.1 | `/coach:next` delivers level-appropriate lesson by reading relevant knowledge file |
| 2.3 | Cost coaching integration | 2.2 | Every teaching includes cost awareness |

### Phase 3: State & Persistence

| Step | Deliverable | Depends On | Acceptance Test |
|------|------------|------------|-----------------|
| 3.1 | First-run initialization in commands/agent (create `~/.claude/coaching/state/` + all files) | 1.3 + 2.2 | First invocation creates directory and state files with correct schemas |
| 3.2 | Outcome logging in commands and skill | 3.1 | outcomes.jsonl grows with each coaching session |
| 3.3 | Evidence-based outcome detection via re-scan | 3.1 | Re-assessment detects env changes and updates `applied` field |

### Phase 4: Discovery

| Step | Deliverable | Depends On | Acceptance Test |
|------|------------|------------|-----------------|
| 4.1 | `commands/discover.md` + `commands/whats-new.md` | 3.1 | `/coach:discover` triggers agent, `/coach:whats-new` shows digest |
| 4.2 | Discovery protocol in agent (version check, changelog fetch, classification) | 4.1 | Detects version change, classifies entries |
| 4.3 | Knowledge file updates from discoveries | 4.2 + 2.1 | Relevant knowledge files updated with new entries |

### Phase 5: Polish & Distribution

| Step | Deliverable | Depends On | Acceptance Test |
|------|------------|------------|-----------------|
| 5.1 | README with marketplace installation instructions | All above | New user can install and run `/coach:assess` in <1 minute |
| 5.2 | Marketplace manifest (`.claude-plugin/marketplace.json` if repo is the marketplace) | 5.1 | `claude plugin marketplace add` works from GitHub |
| 5.3 | End-to-end test: install plugin → open real project → assess → teach → re-assess | All above | Complete coaching flow works in both Claude Code and Cowork |

---

## 7. Test Strategy

### 7.1 Testing Approach

No mock environments or test scripts. Testing is done by installing globally and using the coach against real projects at various configuration levels. The agent's native tool usage (Read, LS, Glob) is validated through actual invocation.

**Manual test checklist for each phase:**

| Test | How to Verify |
|------|--------------|
| Plugin validates | Run `claude plugin validate .` in project root |
| First-run initialization | Delete `~/.claude/coaching/state/`, run `/coach:assess`, verify state dir created |
| Level 0 detection | Open a project with no `.claude/` directory, run `/coach:assess` |
| Level 2+ detection | Open a project with CLAUDE.md + settings, run `/coach:assess` |
| Gap detection | Open a project with agents but weak CLAUDE.md, verify gaps flagged |
| Anti-pattern detection | Create an oversized CLAUDE.md (200+ lines), verify flagged |
| Teaching relevance | At detected level, run `/coach:next`, verify content matches level |
| Cost awareness | In any teaching response, verify cost insight included |
| Skill auto-trigger | Ask "how should I set up CLAUDE.md?" without using a command — verify coaching skill activates |
| Privacy | Confirm `.env` and credential files never mentioned in scan results |
| Persistence | Run two sessions, verify second reads first session's outcomes |
| Discovery | Backdate discovery-state.json, run `/coach:discover`, verify discovery triggers |
| Cowork compatibility | Install plugin, open Cowork, verify `/coach:help` works |

### 7.2 Acceptance Criteria (Detailed)

**AC-01: Assessment accuracy**
Given mock environment at level N, when coach runs assessment, then detected level equals N (±1).

**AC-02: Gap detection**
Given level-5-with-gaps mock, when coach runs assessment, then gaps include "CLAUDE.md quality below Level 2 standard" with HIGH priority.

**AC-03: Anti-pattern detection**
Given anti-patterns mock, when coach runs assessment, then all expected anti-patterns are flagged with correct severity.

**AC-04: Level-appropriate teaching**
Given user at Level 3, when asking about agents (Level 5), coach explains prerequisites needed rather than teaching agents directly.

**AC-05: Cost awareness**
Given any teaching interaction, the response includes at least one cost-relevant insight.

**AC-06: Context budget**
Given a coaching session, coach's own context overhead (knowledge files + state) stays under 3,000 tokens.

**AC-07: Discovery detection**
Given a simulated version bump, when discovery runs, it correctly identifies new changelog entries and classifies them.

**AC-08: Privacy**
Given a project with .env and credentials files, when coach runs assessment, those files are never read (verify via scan scope log).

**AC-09: Persistence**
Given two separate coaching sessions, the second session reads and references data from the first session's outcomes.jsonl.

**AC-10: Graceful degradation**
Given missing or corrupted state files, coach initializes defaults and continues without errors.

---

## 8. Open Questions

| # | Question | Impact | Decision Needed By |
|---|----------|--------|--------------------|
| 1 | ~~Should the coach be project-local or global?~~ | **DECIDED: Plugin (global).** Installed via marketplace, available everywhere. | ✅ Resolved |
| 2 | ~~How to handle coach alongside other plugins?~~ | **RESOLVED by plugin format.** Plugin commands are namespaced (`/coach:*`), skills auto-trigger on context match. No collision with other plugins. | ✅ Resolved |
| 3 | ~~Should knowledge base live inside plugin or separate?~~ | **DECIDED: Inside plugin.** Knowledge bundled with plugin, copied to cache on install. State written to `~/.claude/coaching/state/` at runtime. | ✅ Resolved |
| 4 | ~~License model?~~ | **DECIDED: MIT.** Open source, community contributions welcome. Monetization via future SaaS products. | ✅ Resolved |
| 5 | ~~Scanner: auto or explicit?~~ | **DECIDED: Minimal-first auto-scan.** Commands check for changes; `/coach:assess` always runs full scan via agent. | ✅ Resolved |
| 6 | ~~Install mechanism?~~ | **DECIDED: Plugin marketplace.** `claude plugin marketplace add <repo>` + `claude plugin install coach@agentic-ai-mastery`. Also works in Cowork. | ✅ Resolved |

---

## Appendix A: Glossary

| Term | Definition |
|------|-----------|
| **Coach** | The custom Claude Code agent defined in coach.md |
| **Assessment** | An environment scan that detects skill level, gaps, and anti-patterns |
| **Level** | One of 11 curriculum levels (L0–L10), each with specific mastery criteria |
| **Gap** | A missing or weak skill below the user's detected level |
| **Anti-pattern** | A configuration or behavior that is wasteful, risky, or counterproductive |
| **Discovery** | The process of checking for new Claude Code features and updates |
| **Knowledge base** | Structured reference files the coach reads for teaching content |
| **Outcome** | A logged coaching interaction with its result (applied/not applied/unknown) |
| **Strategy** | The coach's evolved approach to teaching, stored in strategies.md |

## Appendix B: Related Products (Backlog)

| Product | Description | Relationship to Coach |
|---------|-------------|----------------------|
| **Real-Time Discovery Service** | 24h monitoring of Claude ecosystem changes, delivered as newsletter/feed/Slack | Uses same classification logic, broader audience |
| **AI Dev Skill Assessment** | Standalone web/chat assessment of agentic development proficiency | Uses same curriculum levels, not project-tied |

---

*This document is the single source of requirements for the v1.0 implementation. Design documents provide detail. This document provides scope, structure, and acceptance criteria.*
