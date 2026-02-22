# Environment Diagnostic Framework
## Passive Skill Assessment via Environment Scanning

**Version:** 1.1 — February 2026
**Purpose:** Enable the coaching agent to objectively assess a developer's Claude Code proficiency by scanning their project and global configuration.

**Philosophy:** Your environment is your resume. What you've configured, what you haven't, and how you've configured it tells the coach exactly where you are.

---

## Scan Targets & What They Reveal

### 1. Project-Level Scan (`.claude/` directory)

```
.claude/
├── commands/          → Level 4 (Slash Commands — legacy, still supported)
├── skills/            → Level 4 (Skills — current open standard, Dec 2025)
├── agents/            → Level 5 (Custom Agents)
├── hooks/             → Level 6 (Deterministic Quality Gates)
├── rules/             → Level 2 (Modular Rules)
├── settings.json      → Level 2 (Project Configuration)
├── settings.local.json→ Level 2 (Personal overrides, output style persistence)
├── tasks/             → Level 9 (Agent Teams)
├── output-styles/     → Level 1 (Custom Output Styles, Feb 2026)
└── .mcp.json          → Level 7 (MCP Integration)
```

#### What to check and what it means:

| Path | Exists? | Quality Signal | Level Indicator |
|------|---------|---------------|-----------------|
| `.claude/` directory | No | Never configured project | Level 0 |
| `.claude/settings.json` | No | Using defaults only | Level 0-1 |
| `.claude/settings.json` | Yes, minimal | Basic awareness | Level 2 |
| `.claude/settings.json` | Has permission wildcards + deny rules | Understands safety model | Level 2+ |
| `.claude/rules/*.md` | No | Everything in CLAUDE.md or nothing | Level 0-2 |
| `.claude/rules/*.md` | Yes, path-scoped via frontmatter | Modular thinking | Level 2-3 |
| `.claude/commands/` | Yes, has files | Building reusable workflows (legacy) | Level 4 |
| `.claude/skills/` | Yes, has files | Current best practice (open standard) | Level 4+ |
| `.claude/skills/*/evals/` | Yes | Testing skills with structured evals | Level 4+ (advanced) |
| `.claude/agents/` | Yes, has files | Custom agent design | Level 5 |
| `.claude/agents/` | Agents have tool restrictions | Mature agent design | Level 5+ |
| `.claude/agents/` | Agents specify model (e.g., Haiku) | Cost-conscious design | Level 5+ |
| `.claude/hooks/` | Yes, has scripts | Quality automation | Level 6 |
| `.claude/output-styles/` | Yes, has custom styles | Advanced personalization | Level 1+ (awareness) |
| `.mcp.json` | Yes | External tool integration | Level 7 |
| `.claude/tasks/` | Yes | Agent teams usage | Level 9 |

---

### 2. Project Root Scan

| File | Exists? | Quality Signal | Level Indicator |
|------|---------|---------------|-----------------|
| `CLAUDE.md` | No | No project context | Level 0 |
| `CLAUDE.md` | Yes, < 10 lines | Minimal / auto-generated (`/init`) | Level 0-1 |
| `CLAUDE.md` | Yes, 10-50 lines, well-structured | Good project context | Level 2 |
| `CLAUDE.md` | Yes, 50-150 lines, sections | Comprehensive configuration | Level 2-3 |
| `CLAUDE.md` | Yes, > 150 lines | Possibly over-stuffed (anti-pattern — recommend splitting into rules/) | Level 2 (needs coaching) |
| `CLAUDE.md` | Multiple files (root + subdirs) | Architecture-aware config | Level 3+ |
| `AGENTS.md` | Yes (symlinked to CLAUDE.md) | Cross-tool compatibility awareness | Level 4+ |
| `CLAUDE.local.md` | Yes | Personal preferences separated | Level 2+ |
| `claude-progress.txt` | Yes | Using harness pattern for long-running agents | Level 8 |

#### CLAUDE.md Quality Heuristics

Scan the contents of CLAUDE.md and score for:

| Element | Present? | What It Means | Weight |
|---------|----------|---------------|--------|
| Project description / tech stack | ✓/✗ | Basic orientation | 1 |
| Build/test/lint commands | ✓/✗ | Essential — most impactful content | 2 |
| Code style / conventions | ✓/✗ | Quality consciousness | 1 |
| Architecture overview | ✓/✗ | Structural thinking | 1 |
| File organization docs | ✓/✗ | Helps Claude navigate | 1 |
| Testing instructions | ✓/✗ | Quality-first mindset | 2 |
| Environment setup notes | ✓/✗ | Onboarding awareness | 1 |
| Negative constraints ("do NOT...") | ✓/✗ | Mature prompting (knows what to prevent) | 1 |
| `@imports` from other files | ✓/✗ | Modular configuration (context engineering) | 1 |
| References to rules/ or skills/ | ✓/✗ | Ecosystem awareness | 1 |

**Scoring:** Weighted sum. 0-3 = beginner, 4-6 = intermediate, 7-9 = advanced, 10-12 = expert.

---

### 3. Global Configuration Scan (`~/.claude/`)

```
~/.claude/
├── CLAUDE.md           → Global preferences
├── settings.json       → Global settings
├── settings.local.json → Personal overrides
├── commands/           → Personal reusable commands
├── skills/             → Personal reusable skills
├── agents/             → Personal reusable agents
├── output-styles/      → Custom output styles (Feb 2026)
└── .credentials.json   → Auth (don't read — just check exists)

~/.claude.json          → Global MCP server config (separate location)
```

| Path | Signal |
|------|--------|
| `~/.claude/CLAUDE.md` exists | User-level preferences (Level 2+) |
| `~/.claude/CLAUDE.md` has coding style prefs | Consistent cross-project standards (Level 3) |
| `~/.claude/commands/` has files | Personal workflow library (Level 4) |
| `~/.claude/skills/` has files | Portable skill library across projects (Level 4+) |
| `~/.claude/agents/` has files | Portable agents across projects (Level 5+) |
| `~/.claude/output-styles/` has files | Custom output styles (Level 1+ awareness) |
| `~/.claude/settings.json` customized | Global defaults configured (Level 2) |
| `~/.claude.json` has MCP servers | Global MCP integration (Level 7) |

---

### 4. Output Style Detection (Feb 2026 — New)

Check `.claude/settings.local.json` for output style configuration:

```json
// Level 0: No output style set (using default)
{}

// Level 1: Using built-in explanatory or learning style
{ "outputStyle": "explanatory" }
{ "outputStyle": "learning" }

// Level 1+: Custom output style created
// Check ~/.claude/output-styles/ or .claude/output-styles/ for .md files
```

| Signal | What It Reveals |
|--------|----------------|
| No output style set | Using default — may not know the feature exists |
| `explanatory` active | Learning mindset — wants to understand choices |
| `learning` active | Hands-on learner — wants to practice alongside Claude |
| Custom output style exists | Advanced personalization — understands system prompt mechanics |
| Multiple custom styles | Power user — different styles for different contexts |

**Coaching relevance:** The Learning output style is essentially a built-in coaching interface. If a developer hasn't discovered it, the coach should recommend it immediately.

---

### 5. Git History Scan (Usage Patterns)

If the coaching agent has read access to git:

| Signal | How to Detect | What It Means |
|--------|--------------|---------------|
| Claude-attributed commits | `git log --author="Claude"` or commit trailers | Uses Claude Code for real work |
| Commit frequency with Claude | Count Claude commits over time | Adoption trajectory |
| Commit message quality | Scan for descriptive vs. generic messages | Follows commit hygiene practices |
| `.claude/` files in git history | `git log --all -- .claude/` | Evolving configuration over time |
| CLAUDE.md revisions | `git log -p CLAUDE.md` | Iterates on project context |
| Progress files in repo | `find . -name "claude-progress.txt"` | Using harness pattern (Level 8) |
| Feature list JSON | `find . -name "features.json" -path "*claude*"` | Structured long-running work (Level 8) |

---

### 6. Settings.json Deep Scan

Parse `settings.json` for sophistication signals:

```json
// Level 0-1: Default or minimal
{}

// Level 2: Basic permissions
{
  "permissions": {
    "allow": ["Bash(npm run *)"]
  }
}

// Level 2-3: Thoughtful permissions with denials
{
  "permissions": {
    "allow": ["Bash(npm run *)", "Edit(src/**)"],
    "deny": ["Read(.env*)", "Read(~/.aws/**)"]
  }
}

// Level 5: Model selection for agents
{
  // Detected in agent files, not settings
}

// Level 6: Hooks configured
{
  "hooks": {
    "PreToolUse": [{ "hooks": [{"type": "command", "command": "..."}] }],
    "PostToolUse": [{ "hooks": [{"type": "command", "command": "..."}] }],
    "Stop": [{ "hooks": [{"type": "command", "command": "..."}] }]
  }
}

// Level 7: MCP servers
{
  "mcpServers": { "github": {...}, "playwright": {...} }
}

// Level 8: Sandbox configuration
{
  "sandbox": {
    "enabled": true,
    "network": { "allowedDomains": ["github.com"] }
  }
}

// Level 9: Agent teams enabled
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  }
}
```

---

### 7. Agent File Quality Scan (Level 5+ Deep Dive)

If `.claude/agents/` exists, scan each `.md` file for:

| Element | Present? | Maturity Signal |
|---------|----------|----------------|
| YAML frontmatter | ✓/✗ | Basic structure |
| `name` field | ✓/✗ | Properly defined |
| `description` field | ✓/✗ | Enables auto-delegation |
| Description is specific (not generic) | ✓/✗ | Claude can route correctly |
| Tool restrictions defined | ✓/✗ | Security-conscious design |
| Read-only agents exist | ✓/✗ | Separation of concerns |
| `model` specified (not default) | ✓/✗ | Cost-conscious (Haiku for simple tasks) |
| `color` specified | ✓/✗ | Visual organization |
| System prompt > 50 words | ✓/✗ | Detailed instructions |
| System prompt has examples | ✓/✗ | High-quality prompt engineering |
| System prompt has constraints | ✓/✗ | Defensive design |
| Multiple agents with different roles | ✓/✗ | Team-of-specialists thinking |
| Builder + Validator pair exists | ✓/✗ | Advanced pattern awareness |

---

### 8. Skill File Quality Scan (Level 4+ Deep Dive)

If `.claude/skills/` exists:

| Element | Signal | Maturity |
|---------|--------|----------|
| SKILL.md has frontmatter with `name` and `description` | Proper open standard structure | Basic |
| Description is clear and specific | Triggers correctly | Intermediate |
| Step-by-step instructions in body | Reliable execution | Intermediate |
| Examples of good/bad output | Quality guidance | Advanced |
| Supporting files in skill folder | Modular design, progressive disclosure | Advanced |
| Has `evals/` directory with `evals.json` | Testing skills systematically | Expert |
| Skills reference each other | Composition patterns | Expert |
| Skills include executable scripts | Code execution without context loading | Expert |

**Key check:** Are they using skills/ (current standard) or only commands/ (legacy)?

| State | Assessment |
|-------|-----------|
| Only `commands/` | Functional but outdated — recommend migration |
| Both `commands/` and `skills/` | Transitioning — good trajectory |
| Only `skills/` | Current best practice |

---

### 9. Hook Quality Scan (Level 6+ Deep Dive)

If `.claude/hooks/` exists or hooks are defined in `settings.json`:

| Element | Signal |
|---------|--------|
| Number of hook scripts | Breadth of automation |
| Hook event types covered | Which lifecycle events (Pre/Post/Stop/Teammate/Task) |
| Scripts are executable | Basic correctness |
| Scripts handle exit codes properly | Understands hook protocol (0/1/2) |
| Uses exit code 2 for feedback | Advanced — sends output back to Claude |
| Security hooks present | Secret detection, sensitive file protection |
| Quality hooks present | Linting, formatting, test runners |
| Logging hooks present | Observability thinking |
| Status line hooks present | Real-time monitoring |
| Scripts are < 100 lines | Appropriate complexity |
| Scripts have comments | Maintainability |
| TeammateIdle/TaskCompleted hooks | Agent teams quality gates (Level 9) |

---

### 10. Long-Running Agent Pattern Detection (Level 8 — New)

Scan for evidence of the harness pattern:

| Signal | How to Detect | What It Means |
|--------|--------------|---------------|
| `claude-progress.txt` or similar | `find . -name "*progress*" -o -name "*claude-log*"` | Progress tracking across sessions |
| Feature list JSON | Look for structured JSON with `passes: true/false` fields | Structured feature tracking |
| `init.sh` or initialization scripts | `find . -name "init.sh" -path "*claude*"` | Environment setup for agents |
| Git commits with "agent" or "session" references | `git log --grep="session" --oneline` | Multi-session workflow |
| Multiple `.claude/` scratchpad files | File count in `.claude/` | State persistence between sessions |

---

## Composite Scoring Algorithm

### Level Detection Logic

```
function detectLevel(scan_results):
    score = 0
    signals = []

    // Level 0-1 indicators
    if no CLAUDE.md:
        return { level: 0, reason: "No CLAUDE.md found" }
    
    if CLAUDE.md exists but < 10 lines:
        score = 1
        signals.add("CLAUDE.md exists but minimal")
    
    // Level 1+ awareness indicators
    if output_style is set (explanatory/learning/custom):
        signals.add("Uses output styles — learning-oriented")
    
    // Level 2 indicators
    if CLAUDE.md quality score >= 4:
        score = max(score, 2)
    if settings.json has custom permissions:
        score = max(score, 2)
    if rules/ directory has files:
        score = max(score, 2)
    if CLAUDE.local.md exists:
        score = max(score, 2)
    
    // Level 3 indicators
    if CLAUDE.md quality score >= 7:
        score = max(score, 3)
    if multiple CLAUDE.md files (root + subdirs):
        score = max(score, 3)
    if settings.json has both allow AND deny rules:
        score = max(score, 3)
    if CLAUDE.md uses @imports:
        score = max(score, 3)
    
    // Level 4 indicators
    if skills/ has files with proper SKILL.md frontmatter:
        score = max(score, 4)
    elif commands/ has files (legacy):
        score = max(score, 4)
        signals.add("Using commands/ (legacy) — recommend migrating to skills/")
    if skills have evals/:
        signals.add("Testing skills with structured evals — advanced practice")
    
    // Level 5 indicators
    if agents/ has files:
        score = max(score, 5)
    if agents have tool restrictions:
        score = max(score, 5)
    if agents specify non-default model:
        signals.add("Cost-conscious agent design")
    if multiple agents with different roles:
        score = max(score, 5)
    
    // Level 6 indicators
    if hooks/ has scripts OR hooks in settings.json:
        score = max(score, 6)
    if hooks cover multiple event types:
        score = max(score, 6)
    if hooks use exit code 2:
        signals.add("Advanced hook pattern — feedback to Claude")
    
    // Level 7 indicators
    if .mcp.json OR mcpServers in settings OR ~/.claude.json has servers:
        score = max(score, 7)
    
    // Level 8 indicators
    if evidence of headless usage (CI config, scripts with `claude -p`):
        score = max(score, 8)
    if progress files or feature list JSON found:
        score = max(score, 8)
        signals.add("Using harness pattern for long-running agents")
    
    // Level 9 indicators
    if CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS in settings:
        score = max(score, 9)
    if tasks/ directory exists:
        score = max(score, 9)
    if TeammateIdle or TaskCompleted hooks exist:
        signals.add("Agent teams quality gates configured")
    
    // Detect gaps
    gaps = detectGaps(score, scan_results)
    
    return { level: score, signals: signals, gaps: gaps }
```

### Gap Detection (Critical Feature)

A developer might have agents (Level 5) but a weak CLAUDE.md (Level 1 quality). The coach must detect these gaps:

```
function detectGaps(current_level, scan_results):
    gaps = []
    
    for level in range(0, current_level):
        if not levelFullyMet(level, scan_results):
            gaps.add({
                level: level,
                missing: whatsMissing(level, scan_results),
                priority: "HIGH"
            })
    
    return gaps
```

**Example gap report:**
```json
{
  "detected_level": 5,
  "gaps": [
    {
      "level": 2,
      "gap": "CLAUDE.md is only 8 lines — missing build commands, testing instructions, architecture overview",
      "impact": "Your agents inherit poor project context. This undermines everything above Level 2.",
      "priority": "HIGH",
      "recommendation": "Expand CLAUDE.md with the 5 essential sections before creating more agents"
    },
    {
      "level": 1,
      "gap": "No output style configured — using default",
      "impact": "Missing the Learning output style which provides built-in coaching via TODO(human) markers",
      "priority": "MEDIUM",
      "recommendation": "Try /output-style learning for hands-on skill building"
    },
    {
      "level": 4,
      "gap": "Using commands/ (legacy) but not skills/ (open standard)",
      "impact": "Commands aren't portable across Claude.ai, Cowork, and API",
      "priority": "LOW",
      "recommendation": "Migrate key commands to skills/ using the SKILL.md format"
    }
  ]
}
```

---

## Scan Implementation Details

### What the Coach Agent Reads

```bash
# Project-level (current working directory)
ls -la .claude/
cat CLAUDE.md
wc -l CLAUDE.md
cat .claude/settings.json
cat .claude/settings.local.json  # includes output style
ls .claude/commands/
ls .claude/skills/
ls .claude/agents/
ls .claude/hooks/
ls .claude/rules/
ls .claude/output-styles/
cat .mcp.json
find . -name "CLAUDE.md" -maxdepth 3
find . -name "AGENTS.md" -maxdepth 2
find . -name "CLAUDE.local.md" -maxdepth 2
find . -name "claude-progress*" -maxdepth 2  # Harness pattern

# Global-level
ls -la ~/.claude/
cat ~/.claude/CLAUDE.md
cat ~/.claude/settings.json
ls ~/.claude/commands/
ls ~/.claude/skills/
ls ~/.claude/agents/
ls ~/.claude/output-styles/
cat ~/.claude.json  # Global MCP servers (separate path!)

# Git history (if available)
git log --oneline -20
git log --all --oneline -- .claude/
git log --all --oneline -- CLAUDE.md

# Agent file quality (if agents exist)
for f in .claude/agents/*.md; do head -30 "$f"; done

# Skill quality (if skills exist)
for f in .claude/skills/*/SKILL.md; do head -20 "$f"; done
ls .claude/skills/*/evals/ 2>/dev/null  # Check for eval directories

# Hook quality (if hooks exist)
for f in .claude/hooks/*; do head -20 "$f"; done

# Long-running agent patterns
find . -name "claude-progress.txt" -o -name "features.json" 2>/dev/null
```

### Scan Frequency

| Trigger | What to Scan | Why |
|---------|-------------|-----|
| **Session start** | Full scan | Establish baseline on first interaction |
| **On demand** ("assess me") | Full scan | Developer requests evaluation |
| **After coaching exercise** | Targeted scan of relevant area | Verify the developer applied what they learned |
| **Weekly (if persistent)** | Diff against last scan | Track progression over time |

### Scan Output Format (JSONL Progress Log)

Each scan appends to `.claude/coaching/assessments.jsonl`:

```jsonl
{"timestamp":"2026-02-20T10:00:00Z","scan_type":"full","detected_level":3,"claude_md_score":5,"claude_md_lines":42,"has_skills":false,"has_agents":false,"has_hooks":false,"has_mcp":false,"has_teams":false,"output_style":"default","uses_commands_legacy":true,"has_progress_files":false,"gaps":[{"level":2,"gap":"No deny rules in settings","priority":"LOW"},{"level":1,"gap":"No output style set","priority":"MEDIUM"}],"recommendations":["Try /output-style learning for hands-on coaching","Create your first skill from a workflow you repeat","Add deny rules for .env files"]}
```

---

## Scan vs. Prompt Feedback: How They Work Together

| Dimension | Environment Scan | Prompt Feedback |
|-----------|-----------------|-----------------|
| **What it measures** | Configuration maturity, tooling adoption | Prompting skill, task delegation quality |
| **When it runs** | Periodically / on demand | Every interaction |
| **Evidence type** | Objective (files exist or they don't) | Subjective (prompt quality assessment) |
| **Blind spots** | Can't see if developer uses features well | Can't see what's configured but unused |
| **Combined insight** | "Has agents but prompts them poorly" → coaching opportunity |

**Combined signal examples:**

| Scan Says | Prompt Says | Coach Action |
|-----------|------------|-------------|
| Level 5 (has agents) | Poor delegation | Coach agent design, not creation |
| Level 1 (no config) | Good task decomposition | Coach configuration — developer thinks well already |
| Level 6 (has hooks) | Hooks are broken/empty | Coach hook implementation quality |
| No output style | Asking for explanations often | Recommend Explanatory or Learning output style |
| Has skills but no evals | Skills produce inconsistent results | Coach the eval → iterate → improve cycle |
| Has progress files | Sessions still lose context | Coach the harness pattern more deeply |

---

## Privacy & Safety Considerations

The coaching agent MUST:

1. **Never read** `.env`, `.credentials.json`, API keys, or secrets
2. **Never write** outside `.claude/coaching/` directory
3. **Never modify** existing configuration files (read-only diagnostic)
4. **Inform the developer** what it scanned and what it found (transparency)
5. **Store assessments locally only** — no cloud sync without explicit consent
6. **Skip scanning** anything the developer marks as off-limits

---

## Anti-Patterns to Detect

| Anti-Pattern | How to Detect | Coach Response |
|-------------|---------------|----------------|
| CLAUDE.md > 150 lines | Line count | "Consider splitting into .claude/rules/ files for modularity" |
| `dangerouslySkipPermissions: true` | Settings scan | "Running without safety checks. Risky for production." |
| 10+ MCP servers configured | MCP config count | "Most users only need 3-4 daily. Tool Search helps but check usage." |
| Agents with no tool restrictions | Agent file scan | "Restrict the reviewer to read-only tools." |
| No test commands in CLAUDE.md | Content scan | "Without test commands, Claude can't verify its own work. #1 quality lever." |
| Commands/ used instead of skills/ | Directory check | "Migrate to skills/ — it's the open standard, portable across surfaces." |
| Hooks with no error handling | Script analysis | "Broken hooks block your workflow. Add error handling." |
| No deny rules in settings | Permission scan | "Add deny rules for .env, credentials, and sensitive directories." |
| No output style explored | settings.local.json | "Try /output-style explanatory or learning — they're designed for skill building." |
| Skills without progressive disclosure | Skill file analysis | "Put supporting files in subfolders — Claude loads them only when needed." |
| Long CLAUDE.md with no @imports | Content + structure | "Use @imports to modularize. Keeps the entrypoint under 200 lines." |
| Agent teams without delegate mode | Settings + agent config | "The lead keeps doing work itself. Enable delegate mode." |

---

## New Feature Awareness Checks (Feb 2026)

These checks identify whether the developer is aware of recent features:

| Feature | Release | How to Detect Awareness | Coach Prompt if Missing |
|---------|---------|------------------------|------------------------|
| Output Styles | Feb 2026 | output-styles/ dir or outputStyle in settings | "Claude Code has 3 output styles including a Learning mode — try it" |
| Agent Skills (open standard) | Dec 2025 | skills/ with proper SKILL.md frontmatter | "Skills are now an open standard portable across Claude surfaces" |
| Agent Teams | Late 2025 | AGENT_TEAMS env var | "Experimental but powerful for parallel work" |
| Harness Pattern | Nov 2025 | progress files, feature JSONs | "For multi-day projects, use the initializer + coding agent pattern" |
| Tool Search | Late 2025 | Many MCP servers + not disabled | "Tool Search dynamically loads MCP tools to save context" |
| Cowork | Jan 2026 | Not detectable via Claude Code scan | "Cowork handles non-coding tasks — file management, presentations, research" |
| Claude in Chrome | Jan 2026 | Not detectable | "Browser agent for UI testing and web automation" |
| Fast Mode | Feb 2026 | Not easily detectable | "2.5x speed on Opus 4.6 for interactive agent team work" |

---

*This framework is the "eyes" of the coaching agent. Combined with the curriculum (the "brain") and the prompt feedback cycle (the "ears"), it creates a complete diagnostic system.*
*Last updated: February 20, 2026*
