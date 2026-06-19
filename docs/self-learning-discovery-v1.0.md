# Coach Self-Learning & Continuous Discovery Architecture
## Making the Coaching Agent Improve Itself Over Time

> **Sync status (2026-06-19):** Reconciled to the shipped plugin — current June-2026 models/effort facts, verification-first framing, cost coaching off by default, knowledge base includes knowledge/features/plugins.md.

**Version:** 1.0 — 2026-06-19
**Purpose:** Architecture for a coaching agent that learns from its own coaching and discovers new Claude Code features
**Constraint reality:** Claude Code agents can't run on a schedule, have no persistent memory across sessions, and depend entirely on file-based state

---

## Architecture Overview

Two independent but complementary systems:

```
┌─────────────────────────────────────────────────────────┐
│                    COACH AGENT                           │
│                                                         │
│  ┌──────────────┐         ┌──────────────────────┐      │
│  │ SELF-LEARNING │         │ CONTINUOUS DISCOVERY  │      │
│  │ (Inward)     │         │ (Outward)            │      │
│  │              │         │                      │      │
│  │ Coaching     │         │ Changelog scanning   │      │
│  │ outcomes     │         │ Doc site checking    │      │
│  │ Pattern      │         │ Community signals    │      │
│  │ detection    │         │ Feature extraction   │      │
│  │ Strategy     │         │ Curriculum gap       │      │
│  │ refinement   │         │ detection            │      │
│  └──────┬───────┘         └──────────┬───────────┘      │
│         │                            │                   │
│         ▼                            ▼                   │
│  ┌──────────────────────────────────────────────┐       │
│  │         KNOWLEDGE BASE (.claude/coaching/)    │       │
│  │                                               │       │
│  │  assessments.jsonl    (coaching history)       │       │
│  │  outcomes.jsonl       (what worked/didn't)     │       │
│  │  discoveries.jsonl    (new features found)     │       │
│  │  knowledge/           (structured reference)   │       │
│  │  strategies.md        (evolved coaching plays) │       │
│  │  discovery-state.json (last scan timestamps)   │       │
│  └──────────────────────────────────────────────┘       │
└─────────────────────────────────────────────────────────┘
```

---

## Part 1: Self-Learning System

### 1.1 What "Self-Learning" Actually Means Here

Not ML. Not fine-tuning. The coach agent reads its own coaching history files, identifies patterns in what worked and what didn't, and adjusts its strategies. This is structured reflection backed by data, implemented as an agent that reads JSONL logs and updates its own strategy files.

**The learning loop:**

```
Coach session → Log outcome → Accumulate data → Periodic analysis → Update strategies → Better coaching
```

### 1.2 Data Collection: What Gets Logged

Every coaching interaction appends to `outcomes.jsonl`:

```jsonc
// .claude/coaching/outcomes.jsonl
{
  "timestamp": "2026-06-18T14:30:00Z",
  "session_id": "coach-20260618-143000",
  "user_level_detected": 3,
  "topic": "context-engineering",
  "coaching_action": "taught-compact-custom-instructions",
  "exercise_given": true,
  "exercise_id": "L3-compact-custom-01",

  // Outcome signals (populated in follow-up sessions)
  "applied": null,         // Did the user apply the teaching?
  "evidence": null,        // What changed in their environment?
  "follow_up_needed": true,
  "difficulty_reported": null,  // User said it was hard/easy/unclear

  // Environment delta (what changed since last scan)
  "env_before": { "has_compact_usage": false },
  "env_after": null  // Populated on next scan
}
```

**How outcomes get populated:**
- `applied` and `env_after`: Populated when the next environment scan detects changes
- `difficulty_reported`: Populated if user gives explicit feedback ("that was confusing" / "got it")
- `follow_up_needed`: Set by the coach based on whether the teaching was acknowledged

### 1.3 Evidence-Based Outcome Detection

The coach doesn't ask "did you learn this?" — it checks the environment:

```jsonc
// Evidence detection rules
{
  "coaching_action": "taught-compact-custom-instructions",
  "evidence_checks": [
    {
      "check": "grep -r 'compact' ~/.zsh_history | tail -5",
      "signal": "User is using /compact with custom instructions",
      "outcome": "applied"
    },
    {
      "check": "session_token_trend",
      "signal": "Average tokens per session decreased >20%",
      "outcome": "internalized"
    }
  ]
}
```

**Evidence types ranked by reliability:**
1. **Environment change** (highest): New config files, updated CLAUDE.md, new hooks — concrete proof
2. **Behavior change**: Different prompt patterns, model switching, session length changes
3. **Self-report**: User says "I tried it" — useful but less reliable
4. **No evidence**: Doesn't mean failure — user may not have had the opportunity yet

### 1.4 Pattern Analysis: The Retrospective Protocol

Triggered by the `/coach:retrospective` command, or automatically when outcomes.jsonl exceeds 20 unanalyzed entries.

**The analysis process:**

```markdown
## Retrospective Protocol

1. READ outcomes.jsonl (all entries since last retrospective)

2. CATEGORIZE outcomes:
   - Applied quickly (< 1 session gap): Teaching resonated
   - Applied slowly (2-5 sessions): Needed reinforcement
   - Not applied (5+ sessions): Teaching failed or was irrelevant
   - Partially applied: Understood concept but implementation needs help

3. IDENTIFY PATTERNS:
   - Which topics have highest/lowest application rates?
   - Which teaching methods work? (explanation, example, exercise, challenge)
   - At which levels does the user stall?
   - What time-of-day/session-length correlates with learning?
   - Are there prerequisite gaps causing downstream failures?

4. GENERATE INSIGHTS and write to strategies.md:
   - "User learns best through X"
   - "Level N topics need more scaffolding"
   - "Exercises in topic X have low completion — simplify or reframe"
   - "User consistently applies immediately when given concrete examples"

5. UPDATE coaching approach:
   - Adjust pacing (faster/slower per topic)
   - Change teaching method for struggling areas
   - Add/remove exercises based on completion rates
   - Reorder curriculum if prerequisite gaps detected
```

### 1.5 Strategy File: Evolved Coaching Playbook

The coach's strategy file is a living document that the coach itself updates:

```markdown
<!-- .claude/coaching/strategies.md -->
<!-- AUTO-UPDATED BY COACH — Last retrospective: 2026-06-18 -->

## User Learning Profile

- **Learning style**: Responds best to concrete examples with real code
- **Pace**: Absorbs 1-2 new concepts per session effectively
- **Sticking points**: Level 3 context engineering took 4 sessions (expected 2)
- **Strengths**: Quick to apply configuration changes, good at architecture thinking
- **Gaps**: Tends to skip testing, needs repeated reinforcement on test commands

## Coaching Adjustments

### What Works
- Show before/after comparisons (especially verification-first workflows)
- Link teachings to interview preparation (high motivation)
- Give concrete file paths and commands (not abstract descriptions)

### What Doesn't Work
- Long explanations before showing the practical step (user disengages)
- Multiple new concepts in one session (retention drops after 2)
- Exercises without clear success criteria (user unsure if they did it right)

### Active Experiments
- Trying: Teaching hooks through a verification-gate use case (relevant to Level 6)
- Hypothesis: A concrete verification hook will motivate faster adoption than the security use case
- Result: [pending — will evaluate in 3 sessions]

## Priority Adjustments
- Level 3 needs extra session on /compact (user skipped custom instructions)
- Skip Level 4 slash commands (deprecated), go straight to skills
- Level 6 hooks: lead with verification hook, not security hook
```

### 1.6 Feedback Collection (Lightweight)

The coach doesn't interrupt workflow with surveys. It collects signals passively:

**Passive signals:**
- Environment scan deltas (strongest signal)
- Session length trends (getting shorter = more efficient, OR disengaged)
- Number of coaching vs. regular work sessions (is the user engaging?)
- Model selection changes (adopting the recommended model for the task?)

**Active signals (minimal, opt-in):**
- After an exercise: "Quick check — did that click or should we approach it differently?"
- After a retrospective: "I've updated my coaching approach based on our sessions. Anything feel off?"
- Never more than one question per session

### 1.7 The Anti-Patterns the Self-Learner Should Detect

| Pattern | Detection | Coach Response |
|---------|-----------|----------------|
| User stuck at same level for 5+ sessions | Level hasn't incremented in outcomes.jsonl | "We've been at Level N for a while. Let's diagnose what's blocking progress." |
| User applying advanced techniques but skipping fundamentals | Level 5+ detected but Level 2 gaps | "Your agents are sophisticated, but your CLAUDE.md has gaps that undermine them." |
| User asking same question multiple times | Similar topics in outcomes.jsonl | "We've covered this before — let me try a different approach." |
| Coach teachings not being applied | Low application rate across topics | Shift from teaching to pairing — work through a real task together |
| User only engages with coach for new features | Discovery sessions >> coaching sessions | Balance: "New feature X is great, and it connects to Level N concept you haven't finished" |

---

## Part 2: Continuous Discovery System

### 2.1 The Discovery Problem

Claude Code ships updates weekly. Anthropic blog posts announce paradigm shifts. Community discovers patterns. The curriculum becomes stale within weeks if not maintained.

**The coach must:**
1. Detect when its knowledge is stale
2. Know where to look for updates
3. Extract coaching-relevant information (not just raw changelogs)
4. Integrate discoveries into the curriculum and diagnostic framework
5. Distinguish signal from noise (not every bug fix is curriculum-relevant)

### 2.2 Discovery State Tracking

```jsonc
// .claude/coaching/discovery-state.json
{
  "last_discovery_run": "2026-06-18T10:00:00Z",
  "staleness_days": 1,
  "sources_checked": {
    "github_changelog": {
      "last_checked": "2026-06-18T10:00:00Z",
      "last_known_version": "2.1.8",
      "url": "https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md"
    },
    "anthropic_release_notes": {
      "last_checked": "2026-06-18T10:00:00Z",
      "url": "https://platform.claude.com/docs/en/release-notes/overview"
    },
    "anthropic_engineering_blog": {
      "last_checked": "2026-06-14T10:00:00Z",
      "url": "https://www.anthropic.com/engineering"
    },
    "claude_code_docs": {
      "last_checked": "2026-06-18T10:00:00Z",
      "url": "https://code.claude.com/docs"
    },
    "npm_version": {
      "last_checked": "2026-06-18T10:00:00Z",
      "last_known_version": "2.1.8"
    }
  },
  "pending_discoveries": [],
  "curriculum_version": "1.1",
  "cost_guide_version": "1.0"
}
```

### 2.3 Discovery Sources (Priority Ordered)

| Source | What It Catches | Check Frequency | Method |
|--------|----------------|-----------------|--------|
| **GitHub CHANGELOG.md** | Every feature, fix, change | Every session (if >24h stale) | `web_fetch` the raw file |
| **`claude --version`** | Version bumps | Every session | Local bash command |
| **Anthropic release notes** | Major features, model launches | Every 3 days | `web_search` + `web_fetch` |
| **Claude Code docs site** | New documentation pages | Weekly | `web_search` targeted queries |
| **Anthropic engineering blog** | Paradigm shifts, best practices | Weekly | `web_search` |
| **npm package info** | Version, dependencies | Every session | `npm view @anthropic-ai/claude-code version` |
| **Community (r/ClaudeAI, ClaudeLog)** | Patterns, workarounds, real-world tips | Bi-weekly | `web_search` targeted queries |

### 2.4 The Discovery Protocol

Triggered on any of:
- Coach startup when `staleness_days >= 1`
- User command: `/coach:discover` or `/coach:whats-new`
- After a retrospective (combines learning + discovery)

```markdown
## Discovery Protocol

### Phase 1: Quick Check (runs every session if >24h stale, ~30 seconds)

1. RUN: `claude --version` → compare against last_known_version
2. If version changed:
   a. FETCH: GitHub CHANGELOG.md (raw)
   b. EXTRACT: All entries between last_known_version and current
   c. CLASSIFY each entry (see Classification below)
   d. APPEND coaching-relevant entries to discoveries.jsonl
   e. UPDATE discovery-state.json

3. If version unchanged AND <24h since last check:
   → Skip, proceed to coaching

### Phase 2: Deep Scan (runs when staleness_days >= 3, ~2-3 minutes)

1. Phase 1 (above)
2. SEARCH: "Anthropic Claude Code new features [current month] [current year]"
3. SEARCH: "Claude API new capabilities [current month] [current year]"
4. SEARCH: "Anthropic engineering blog [current month] [current year]"
5. FETCH: Anthropic release notes page
6. For each result:
   a. CLASSIFY relevance (see Classification below)
   b. CHECK against existing discoveries.jsonl (dedup)
   c. APPEND new discoveries
   d. FLAG curriculum gaps

### Phase 3: Community Scan (runs when staleness_days >= 7, ~3-5 minutes)

1. Phases 1 + 2 (above)
2. SEARCH: "Claude Code tips tricks best practices 2026"
3. SEARCH: "Claude Code workflow optimization"
4. SEARCH: "r/ClaudeAI Claude Code [current month]"
5. For each result:
   a. ASSESS community consensus (single user tip vs. widely confirmed)
   b. CLASSIFY coaching relevance
   c. APPEND confirmed patterns to discoveries.jsonl
   d. FLAG as "community pattern" (lower confidence than official sources)
```

### 2.5 Discovery Classification

Not every changelog entry matters for coaching. The classifier determines what's curriculum-relevant:

```markdown
## Classification Framework

### CURRICULUM-RELEVANT (add to knowledge base)

Lead signals are **capability, correctness, and verification** — not cost. Classify
and surface changes by what they let the user do (or do more reliably), and only note
cost as a secondary detail.

- New feature that unlocks a new capability (e.g., Agent Teams, Output Styles)
- New command or flag that changes workflow (e.g., /coach:recap, /coach:compare, plan rejection feedback)
- New best practice from Anthropic (e.g., verification-first workflows, context engineering, harness patterns)
- Model or capability changes that affect which model fits a task (e.g., a new default model, new `effort` levels)
- Deprecation of a feature the curriculum teaches
- Security fix that affects permission guidance

> **Cost is off by default.** Pricing/model-cost changes are NOT a lead classification
> dimension. Capture them only as a secondary `cost_impact` note (see JSONL format) and
> surface them solely through the opt-in `/coach:cost` path — never as the primary reason
> a change is flagged.

### DIAGNOSTIC-RELEVANT (update scan targets)
- New config file or setting location
- New environment variable
- Changes to settings.json schema
- New tool or MCP capability

### INFORMATIONAL ONLY (log but don't update curriculum)
- Bug fixes for existing features
- Performance improvements
- Platform-specific fixes (Windows, VSCode)
- UI polish changes

### NOISE (skip entirely)
- Internal refactoring
- Dependency updates
- CI/CD changes
```

### 2.6 Discovery JSONL Format

```jsonc
// .claude/coaching/discoveries.jsonl
{
  "timestamp": "2026-06-18T10:30:00Z",
  "source": "github_changelog",
  "source_version": "2.1.9",
  "classification": "curriculum-relevant",

  "title": "Nested skills auto-discovery",
  "description": "Skills in nested .claude/skills directories are now automatically discovered when working with files in subdirectories",
  "raw_changelog_entry": "Added automatic discovery of skills from nested .claude/skills directories...",

  "curriculum_impact": {
    "affected_levels": [4],
    "action": "update",
    "detail": "Level 4 should teach nested skills directory pattern for monorepo/multi-module projects"
  },

  "diagnostic_impact": {
    "new_scan_target": ".claude/skills/**/SKILL.md",
    "detail": "Scan for nested skill directories as indicator of Level 4+ sophistication"
  },

  "cost_impact": null,  // secondary note only; surfaced via opt-in /coach:cost, never a lead signal

  "status": "pending",  // pending → reviewed → integrated → dismissed
  "integrated_date": null
}
```

### 2.7 Knowledge Base Structure

Discoveries don't just sit in JSONL — they get integrated into structured reference files:

```
.claude/coaching/
├── knowledge/
│   ├── features/              # One file per major feature area
│   │   ├── agents.md          # Agent capabilities, syntax, patterns
│   │   ├── skills.md          # Skills standard, progressive disclosure
│   │   ├── hooks.md           # Hook events, patterns, examples
│   │   ├── mcp.md             # MCP servers, Tool Search
│   │   ├── models.md          # Available models, pricing, selection
│   │   ├── context.md         # Context management commands, strategies
│   │   ├── output-styles.md   # Output style configuration
│   │   ├── teams.md           # Agent teams, delegation
│   │   ├── plugins.md         # Plugins: structure, marketplaces, install/update
│   │   └── headless.md        # Headless mode, harness patterns, SDK
│   │
│   ├── commands/              # Quick reference for slash commands
│   │   └── commands-ref.md    # All known / commands with descriptions
│   │
│   ├── pricing/               # Current pricing data
│   │   └── pricing-current.md # Model prices, plan costs, multipliers
│   │
│   └── ecosystem/             # Broader Claude ecosystem
│       ├── cowork.md          # Cowork capabilities, when to use
│       ├── chrome.md          # Chrome agent
│       └── api.md             # API capabilities relevant to developers
│
├── assessments.jsonl          # User skill assessments (existing; schema now includes verification_ready, verification_gate, practice_gaps)
├── outcomes.jsonl             # Coaching outcomes (self-learning)
├── discoveries.jsonl          # Raw discoveries (discovery system)
├── discovery-state.json       # Discovery timestamps and state
├── strategies.md              # Evolved coaching playbook (self-learning)
└── discovery-digest.md        # Human-readable summary of recent discoveries
```

### 2.8 Knowledge File Format

Each knowledge file follows a standard structure:

```markdown
<!-- .claude/coaching/knowledge/features/agents.md -->
<!-- AUTO-MAINTAINED BY COACH — Last updated: 2026-06-18 -->
<!-- Sources: github_changelog, anthropic_docs, community -->

# Agents Knowledge Base

## Current State (as of Claude Code v2.1.8)

### Core Capabilities
- Custom agents via `.claude/agents/*.md` (Markdown + YAML frontmatter)
- Automatic delegation based on description field
- Tool restrictions (read-only agents possible)
- Model selection per agent (model: field in frontmatter; e.g. claude-opus-4-8, claude-sonnet-4-6, claude-haiku-4-5)
- Visual color coding per agent
- Built-in subagents: Explore (read-only), Plan (analysis)

### Recent Changes
- [v2.1.9] Custom agent model field in .claude/agents/*.md now properly respected for team teammates
- [v2.1.7] Subagents continue working after permission denial (try alternative approaches)
- [v2.1.6] Skills in nested directories auto-discovered

### Known Issues
- [#6108] explore→plan→code may not always switch models correctly during execution
- Agent teams on Bedrock/Vertex need env var propagation fix (fixed in 2.1.8)

### Coaching Relevance
- Level 5 curriculum topic
- Verification: read-only/tool-restricted agents make explore→plan→code and review steps safer
- Diagnostic: check for tool restrictions, model specification, description quality
- Cost note (opt-in): agents without a model: field default to the session model

### Open Questions
- Will agent-to-agent communication become first-class? (Currently via files/git)
- When will Agent Teams exit experimental?
```

### 2.9 Discovery Digest: Human-Readable Summary

After each discovery run, the coach updates a digest the user can optionally read:

```markdown
<!-- .claude/coaching/discovery-digest.md -->
<!-- AUTO-GENERATED — Last discovery run: 2026-06-18 -->

# What's New in Claude Code

## Since Your Last Session (Jun 16)

### 🟢 New Capabilities
- **Nested skill discovery**: Skills in subdirectories now auto-discovered
  → Relevant to your Level 4 work. Useful for monorepo structures.

- **Context window percentage in status line**: New fields for easier monitoring
  → Helps with Level 3 context engineering. Use in custom status hooks.

- **New coaching commands `/coach:recap` and `/coach:compare`**: Recap recent sessions; compare two runs
  → Use `/coach:recap` to review what you have applied across sessions.

### ✅ Correctness & Verification
- **Plan mode preserved after compaction**: Previously, compaction could switch out of plan mode
  → Keeps the explore→plan→code flow intact so the plan you approved is the plan that runs.

### 🔧 Fixes That Affect Your Setup
- **Adaptive thinking + `effort`**: `effort` (low/medium/high/xhigh/max) replaced `budget_tokens`
  → Update any agent/config that still sets `budget_tokens`.

### 📚 Curriculum / Knowledge Updates Needed
- Level 4: Add nested skills directory pattern
- Knowledge base: Add knowledge/features/plugins.md
- Models: Refresh to June-2026 lineup (default claude-opus-4-8)
- Diagnostic: Add context_window percentage check to scan

### ⏭️ Coming Soon (Signals from Community)
- Plugins ecosystem expanding (enabledPlugins setting)
- /debug command for session troubleshooting

### 💰 Cost (opt-in via /coach:cost)
- Model-cost changes are tracked but shown only when you opt in. Run `/coach:cost` to see them.
```

---

## Part 3: Integration Between Self-Learning and Discovery

### 3.1 The Combined Intelligence Loop

Self-learning and discovery aren't independent — they inform each other:

```
Discovery finds new feature → Coach teaches it → Outcome tracked →
  If user struggles → Coach adjusts teaching approach (self-learning)
  If user adopts quickly → Coach notes effective teaching method
  If user ignores → Coach assesses: wrong timing? wrong level? not relevant?
```

### 3.2 Discovery-Triggered Coaching

When a discovery is classified as curriculum-relevant AND affects the user's current level:

```jsonc
// Logic in coach agent
if (discovery.curriculum_impact.affected_levels.includes(user.current_level)) {
  // Proactive coaching: bring it up in next session
  "I noticed Claude Code v2.1.9 added nested skill discovery.
   Since you're working on skills right now, this is directly relevant.
   Want me to show you how to structure skills for your monorepo?"
}

// Cost is OFF by default — only surface cost notes when the user opted in via /coach:cost
if (discovery.cost_impact && user.cost_coaching_enabled) {
  "Heads up: a newer model is available at comparable pricing with better
   agentic performance. Worth a look when you next pick a model."
}

if (discovery.curriculum_impact.action === "deprecation") {
  // Urgent: something the user relies on is being removed
  "Important: [feature] is being deprecated. Let's migrate your
   setup to [replacement] before it breaks."
}
```

### 3.3 Self-Learning Informs Discovery Priority

If the self-learning system detects the user struggles with context management (Level 3), the discovery system prioritizes context-related discoveries:

```jsonc
// Discovery query adaptation
if (strategies.sticking_points.includes("context-engineering")) {
  // Add targeted searches
  discovery_queries.push("Claude Code context window optimization tips 2026");
  discovery_queries.push("Claude Code compact improvements");
}
```

### 3.4 Staleness Alerts

The coach proactively warns when knowledge may be stale:

| Staleness | Behavior |
|-----------|----------|
| 0-1 days | Normal operation |
| 1-3 days | Quick check on session start (Phase 1) |
| 3-7 days | Deep scan suggested: "My knowledge is a few days stale. Want me to check for updates?" |
| 7-14 days | Deep scan + community scan: "It's been a week — let me do a thorough update" |
| 14+ days | Alert: "My knowledge base may have significant gaps. Running full discovery." |

---

## Part 4: Implementation Architecture

### 4.1 Agent Commands

The coach agent responds to these commands:

```markdown
## Coaching Commands
/coach:assess          — Run environment scan, show current level
/coach:next            — Next lesson based on level and gaps
/coach:exercise        — Hands-on exercise for current topic
/coach:recap           — Recap recent sessions and what was applied
/coach:compare         — Compare two coaching runs / setups
/coach:retrospective   — Analyze coaching effectiveness, update strategies

## Discovery Commands
/coach:discover        — Run discovery protocol (depth based on staleness)
/coach:whats-new       — Show discovery digest
/coach:update-kb       — Integrate pending discoveries into knowledge base

## Opt-In Commands
/coach:cost            — Show cost/token coaching (OFF by default)

## Meta Commands
/coach:status          — Show current level, pending discoveries, staleness
/coach:reset           — Reset coaching history (keep knowledge base)
/coach:export          — Export coaching data for backup
```

### 4.2 Session Startup Flow

```
1. Coach agent invoked

2. READ discovery-state.json
   → Calculate staleness_days

3. IF staleness_days >= 1:
   → Run Phase 1 discovery (quick check, ~30s)
   → If new discoveries found, briefly mention: "I found N updates since your last session"

4. READ strategies.md (evolved coaching approach)

5. READ outcomes.jsonl (last 10 entries for context)

6. READ assessments.jsonl (latest assessment)

7. PROCEED with coaching using:
   - Current knowledge base
   - Updated strategies
   - Awareness of user's level and patterns
   - Any new discoveries to potentially teach

8. AT SESSION END:
   → Append to outcomes.jsonl
   → Update discovery-state.json timestamps
```

### 4.3 File Write Permissions

The coach agent's permission scope:

```yaml
# Only writes to its own directory
allowed_write_paths:
  - .claude/coaching/**

# Reads project config for diagnostics (read-only)
allowed_read_paths:
  - .claude/**
  - CLAUDE.md
  - claude-progress.txt
  - package.json  # for project context

# Never reads
forbidden_paths:
  - .env*
  - **/credentials*
  - **/secrets*
  - **/*.key
  - **/*.pem
```

### 4.4 Context Budget Management

The coach itself must practice context engineering:

```markdown
## Coach's Context Budget Rules

1. Knowledge base: Load ONLY the knowledge files relevant to current coaching topic
   - Coaching Level 3? Load knowledge/features/context.md
   - NOT every knowledge file at once

2. History: Load only last 5-10 outcomes.jsonl entries
   - Full history is for retrospective analysis only

3. Discoveries: Load only pending discoveries + current level discoveries
   - Not the entire discoveries.jsonl

4. Strategies: Always load strategies.md (small file, high value)

5. Discovery digest: Load only if user asks "what's new"

6. Total coach overhead target: <3,000 tokens of coaching context per session
   - This is the coach's own context hygiene — practice what you preach
```

### 4.5 Error Handling and Graceful Degradation

```markdown
## What happens when things fail

1. Web search unavailable (network restricted):
   → Skip discovery, log "discovery_blocked: network"
   → Coach from existing knowledge base
   → Suggest user run discovery manually when network is available

2. Knowledge base files missing or corrupted:
   → Rebuild from curriculum document (the source of truth)
   → Log the gap for investigation

3. JSONL files corrupted:
   → Start fresh JSONL, don't crash
   → Log: "History reset due to corruption — starting fresh"

4. Discovery finds contradictory information:
   → Prefer official sources (Anthropic docs/changelog) over community
   → Flag contradiction in discoveries.jsonl for human review
   → Don't update knowledge base until resolved

5. Version detection fails:
   → Fall back to date-based staleness instead of version-based
   → Still run discovery on schedule
```

---

## Part 5: What Good Looks Like (Success Metrics)

### For Self-Learning

| Metric | Target | How to Measure |
|--------|--------|---------------|
| Coaching application rate | >60% of teachings applied within 3 sessions | outcomes.jsonl applied/total |
| Level progression pace | Average 2-3 sessions per level | assessments.jsonl timestamps |
| Repeated topics declining | Same topic coached <2x after initial teaching | outcomes.jsonl topic frequency |
| Strategy accuracy | Coach predictions match user behavior | strategies.md experiments vs. outcomes |

### For Discovery

| Metric | Target | How to Measure |
|--------|--------|---------------|
| Knowledge freshness | <3 days stale on average | discovery-state.json |
| Curriculum coverage | >90% of new features classified within 7 days | discoveries.jsonl vs. changelog |
| False positive rate | <20% of discoveries are actually noise | discoveries.jsonl dismissed/total |
| Integration speed | Coaching-relevant discoveries taught within 2 sessions | discovery → outcome gap |

### Combined

| Metric | Target | How to Measure |
|--------|--------|---------------|
| User doesn't discover features before coach | Coach mentions new features before user asks | First mention in outcomes.jsonl |
| Teaching quality improves over time | Application rate trends upward | Rolling 30-day outcomes average |
| Knowledge base grows without bloat | Knowledge files stay under 500 lines each | Line counts |
| Coach overhead stays lean | <3,000 tokens of coaching context per session | /cost delta with/without coach |

---

## Part 6: Practical Implementation Notes

### What to Build First (Priority Order)

1. **Discovery Phase 1 only** (quick version check + changelog scan)
   → Highest value, lowest complexity. Just `claude --version` + `web_fetch` CHANGELOG.md

2. **Outcome logging** (basic JSONL append on each coaching session)
   → Foundation for everything else. No analysis yet, just data collection.

3. **Knowledge base seed files** (extract from existing curriculum document)
   → One-time setup, gives the coach structured reference material

4. **Discovery state tracking** (staleness calculation)
   → Enables "your knowledge is N days old" awareness

5. **Discovery Phase 2** (deep scan with web search)
   → More comprehensive but more complex. Add after Phase 1 works.

6. **Retrospective protocol** (pattern analysis)
   → Needs ~20 outcomes before it's meaningful. Build after a few weeks of data.

7. **Strategy file auto-update** (self-learning loop closes)
   → The payoff step. Now the coach evolves its own teaching approach.

8. **Discovery Phase 3** (community scanning)
   → Nice-to-have. Official sources cover 90% of what matters.

### What NOT to Over-Engineer

- **Don't build a database.** JSONL files are sufficient for a single user. A solo developer doesn't need SQLite for coaching logs.
- **Don't build a scheduler.** The coach checks staleness on startup. That's enough. No cron, no background processes.
- **Don't scrape websites.** Use web_search and web_fetch. Don't build custom scrapers for Anthropic's site.
- **Don't version the knowledge base in git.** It's ephemeral derived data. The curriculum document IS the source of truth. Knowledge base can always be rebuilt.
- **Don't aim for 100% discovery coverage.** 80% of what matters comes from the CHANGELOG.md. Diminishing returns after that.

### The Bootstrapping Problem

When the coach first runs, it has no history. It needs to:

1. Seed knowledge base from the curriculum document (one-time extraction)
2. Run an initial environment scan (Level 0 assessment)
3. Run an initial discovery (establish baseline versions and timestamps)
4. Start logging outcomes from session 1

After ~10 sessions, the self-learning system has enough data to start pattern detection.
After ~20 sessions, retrospectives become meaningful.
After ~30 sessions, the strategy file should reflect real learning about the user.

---

*This architecture document is the blueprint. The actual agent implementation (coach.md) will reference these protocols but implement them as agent behaviors, not as code.*
