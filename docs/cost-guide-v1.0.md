# Claude Code Cost Optimization Guide
## Consolidated Reference + Cross-Cutting Curriculum Annotations

**Version:** 1.0 — February 2026
**Purpose:** Companion to the Claude Code Mastery Curriculum v1.1
**Audience:** Solo developers, engineering managers, team leads managing AI tooling spend

---

## Part 1: Consolidated Cost Reference

### 1.1 The Fundamental Cost Model

Claude Code costs are driven by **tokens** — the atomic units of text processing. Every interaction has two cost components:

- **Input tokens**: Everything Claude reads (your prompt + conversation history + files read + system prompt + CLAUDE.md + MCP tool definitions)
- **Output tokens**: Everything Claude writes (responses + code + tool calls + extended thinking)

**The compounding problem**: Conversation history is resent with every message. A 10,000-token conversation history after 20 exchanges means you've paid for ~200,000 tokens of history alone. This is the single biggest cost driver most developers don't understand.

**Key insight**: Input tokens are cheap. Output tokens are 3-5x more expensive. But input tokens compound because history accumulates. The cheapest token is the one never sent.

### 1.2 Pricing Quick Reference (February 2026)

#### API Token Pricing (per million tokens)

| Model | Input | Output | Cache Write (5min) | Cache Read | Relative Cost |
|-------|-------|--------|-------------------|------------|---------------|
| **Opus 4.6** | $5.00 | $25.00 | $6.25 | $0.50 | 5x baseline |
| **Sonnet 4.5/4.6** | $3.00 | $15.00 | $3.75 | $0.30 | 3x baseline |
| **Haiku 4.5** | $1.00 | $5.00 | $1.25 | $0.10 | 1x baseline |

**Cost multipliers that stack:**
- Long context (>200K input tokens): ~1.5-2x on all token prices
- Fast mode (Opus 4.6): 6x standard rates ($30/$150 per MTok)
- US-only inference (inference_geo): 1.1x multiplier
- Extended thinking tokens: Billed as output tokens (the expensive kind)

**Cost reducers:**
- Prompt caching (cache reads): 90% cheaper than base input
- Batch API: 50% discount on both input and output
- These stack: Batch + caching can yield 90%+ savings for suitable workloads

#### Subscription Plans (February 2026)

| Plan | Monthly Cost | Usage Multiplier | Opus Access | Best For |
|------|-------------|------------------|-------------|----------|
| **Free** | $0 | Baseline | No (Sonnet only) | Evaluation |
| **Pro** | $20 | 1x | Yes (limited) | Light/learning use |
| **Max 5x** | $100 | 5x Pro | Yes | Daily professional use |
| **Max 20x** | $200 | 20x Pro | Yes | Heavy/multi-instance use |
| **Team** | $30/user (min 5) | Team-pooled | Yes | Organizations |

**Subscription vs. API decision framework:**

| Your Pattern | Recommended | Why |
|-------------|-------------|-----|
| Learning/exploring, <2 hrs/day | Pro ($20) | Predictable, includes all features |
| Daily coding, single project | Max 5x ($100) | Rarely hits limits, Opus access |
| Multi-instance, agent teams, CI/CD | Max 20x ($200) or API | Need headroom for parallel work |
| Building a SaaS product (API calls) | API pay-per-token | Only way to serve end users |
| Hybrid: personal dev + product API | Max 5x + API key | Best of both worlds |

**The hidden truth about subscriptions**: Anthropic doesn't surface exact token counts or cost-equivalents for subscription users. The community tool `ccusage` reads local JSONL files to calculate what your usage *would* cost on API pricing — essential for evaluating whether you're over- or under-paying.

### 1.3 The 80/20 Cost Reduction Strategies

Listed in order of impact-to-effort ratio:

#### Strategy 1: Model Selection (saves 60-80%)

The highest-leverage single action. Most developers default to Opus for everything.

```
# Default to Sonnet — handles 80-90% of tasks
/model sonnet

# Opus ONLY for: architecture decisions, complex debugging, multi-file refactoring
/model opus

# Haiku for: simple edits, quick questions, linting, classification
/model haiku

# Best of both worlds: Opus plans, Sonnet executes
/model opusplan
```

**The opusplan strategy**: Uses Opus for planning (read-only, high-reasoning) and automatically switches to Sonnet for execution (file writes, code generation). You get Opus-quality architectural thinking at Sonnet execution prices. This is the recommended default for experienced users.

**Effort levels** (Opus 4.6 only): Low/Medium/High control adaptive thinking depth. Lower effort = fewer thinking tokens = cheaper. Use low for routine tasks, high only for genuinely complex reasoning.

**Agent-level model routing**: When building custom agents (Level 5), specify cheaper models for agents that do simple work:

```yaml
# .claude/agents/reviewer.md frontmatter
model: haiku
```

A review agent reading code and reporting findings doesn't need Opus. A Haiku agent costs 1/5th as much per token.

#### Strategy 2: Context Hygiene (saves 30-50%)

Every token in your context window is re-processed with every message. Stale context is pure waste.

```
# Clear between unrelated tasks (most important habit)
/clear

# Rename before clearing so you can resume later
/rename "auth-refactor-session"
/clear

# Compact when context is growing but you need continuity
/compact

# Custom compaction: tell Claude what matters
/compact Focus only on the API endpoints and test results
```

**When to /clear vs /compact:**

| Situation | Action | Why |
|-----------|--------|-----|
| Switching to unrelated task | `/clear` | Zero wasted tokens |
| Long session, still on same task | `/compact` | Preserves essential context |
| After completing a sub-task | `/clear` + git commit | Clean slate, work is saved |
| Debugging session going in circles | `/clear` + fresh prompt | Stale wrong-turns waste tokens |

**Auto-compaction**: Claude Code auto-compacts at 95% context capacity. This is too late — by then you've been paying premium rates on bloated context for many messages. Manually compact earlier.

**The commit-and-clear pattern**: The single most cost-effective workflow habit.

```
1. Work on a focused task
2. Git commit when done
3. /clear
4. Start next task with fresh context
```

#### Strategy 3: Prompt Precision (saves 20-40%)

Vague prompts cause Claude to explore, read unnecessary files, ask clarifying questions, and over-engineer solutions. Every unnecessary action costs tokens.

```
# Expensive (vague → exploration → wasted tokens)
"make this better"
"fix the auth"
"refactor the codebase"

# Cheap (precise → direct action)
"In src/auth.js, extract the JWT validation into a separate function called validateToken"
"Add error handling to the /api/users endpoint for 404 and 500 cases"
"Run the test suite and fix any failing tests in tests/auth.test.js"
```

**What precision buys you:**
- Fewer files read (Claude doesn't need to search for what you mean)
- Fewer tool calls (no exploratory `grep`, `find`, `ls` cycles)
- Fewer back-and-forth exchanges (no clarification needed)
- Less output (Claude doesn't hedge or over-explain)

**The plan-first pattern for complex tasks:**
```
1. Enter plan mode (Shift+Tab twice)
2. Describe the full task
3. Review Claude's plan (read-only, cheaper)
4. Approve or refine
5. Execute (now Claude knows exactly what to do)
```

Planning is cheaper than fixing. A 500-token plan that prevents a 10,000-token wrong implementation saves 95%.

#### Strategy 4: CLAUDE.md as Cost Control (saves 15-30%)

A well-structured CLAUDE.md prevents Claude from reading files it shouldn't, running commands unnecessarily, and making wrong assumptions that require correction.

```markdown
# CLAUDE.md cost-relevant sections

## Architecture
- Frontend: src/frontend/ (React, TypeScript)
- Backend: src/api/ (Node.js, Express)
- Tests: tests/ (Jest)
- DO NOT read or modify: node_modules/, dist/, .next/, coverage/

## Commands
- Build: npm run build
- Test: npm test
- Lint: npm run lint
- Test single file: npm test -- --testPathPattern="<filename>"

## Conventions
- All API responses use the ResponseWrapper type from src/types/api.ts
- Error handling follows the pattern in src/middleware/errorHandler.ts
- Do NOT create new utility files — check src/utils/ first
```

**Cost impact of each section:**
- **Architecture map**: Prevents exploratory file-reading (saves thousands of tokens)
- **Build/test commands**: Prevents Claude from guessing and failing (saves retry cycles)
- **Conventions**: Prevents over-engineering and rework (saves output tokens)
- **DO NOT patterns**: Explicit exclusions prevent the most wasteful reads

#### Strategy 5: Disable Unused MCP Servers (saves 5-15%)

Each enabled MCP server injects tool definitions into your system prompt. With 10+ servers, this can consume 10-20% of your context budget on every single message.

```
# Check what's consuming your context
/context

# Disable servers you're not actively using
# Or use Tool Search (Level 7) to load tools on-demand
```

**Community wisdom**: Most developers who install 15 MCP servers end up using only 4 daily. The other 11 are pure context waste.

### 1.4 Monitoring & Measurement Tools

#### Built-in Commands

| Command | What It Shows | When to Use |
|---------|--------------|-------------|
| `/cost` | Session token usage and estimated cost | During sessions, before/after expensive operations |
| `/stats` | Usage patterns over time | Weekly review of spending trends |
| `/context` | What's consuming your context window | When context feels bloated |
| `/status` | Current model and account info | Verify you're on the right model |

#### ccusage (Community Tool — Essential)

The most important third-party tool for cost management. Reads Claude's local JSONL logs to give you real visibility.

```bash
# Install and run (no global install needed)
npx ccusage@latest

# Key views
npx ccusage daily              # Daily token usage and costs
npx ccusage monthly            # Monthly aggregated report  
npx ccusage session            # Usage by conversation session
npx ccusage blocks             # 5-hour billing window usage
npx ccusage daily --breakdown  # Per-model cost breakdown

# For subscription users — compare against plan value
npx ccusage --plan max5        # See if you're over/under your plan's value

# Project-level analysis
npx ccusage daily --instances            # Group by project
npx ccusage daily --project myproject    # Filter specific project
```

**Why this matters**: Without ccusage, subscription users have no idea whether they're getting $50/month or $500/month of value from their plan. API users get this from the Anthropic Console, but ccusage adds per-session and per-project granularity.

**Also available:**
- `ccusage` MCP server — integrates usage data directly into Claude workflows
- `cctray` — macOS menu bar widget showing real-time usage
- `ccusage-widget` — desktop widget for continuous monitoring
- Raycast extension — usage stats in the Raycast launcher

#### Anthropic Console (API Users)

- Workspace spend limits and usage reporting
- Claude Code Analytics API for programmatic access
- Cost and usage dashboards per workspace

### 1.5 Cost Anti-Patterns (What Burns Money)

| Anti-Pattern | Why It's Expensive | Fix |
|-------------|-------------------|-----|
| Using Opus for everything | 5x Haiku's cost per token | Default to Sonnet, escalate selectively |
| Never clearing context | History compounds every message | Commit-and-clear after each task |
| Vague prompts | Exploration, clarification, rework | Be specific about file, function, action |
| Letting sessions run long | Context bloat degrades quality AND costs more | /compact proactively or /clear |
| 10+ MCP servers always-on | Tool definitions eat context budget | Disable unused, use Tool Search |
| Extended thinking on simple tasks | Thinking tokens = expensive output tokens | Lower effort level for routine work |
| Agent teams for simple tasks | Each agent has initialization overhead | Solo agent for single-focus work |
| Not monitoring usage | Can't optimize what you can't measure | Install ccusage, check /cost regularly |
| Over-engineering CLAUDE.md | 150+ lines loaded every session | Keep under 150 lines, use @imports |
| Auto-accept mode for complex tasks | No human checkpoint → expensive wrong turns | Use plan mode for costly operations |
| Debugging by trial-and-error with AI | Each attempt compounds context | Read the error yourself first, give Claude the specific error |
| Reading entire large files | Claude reads full files even when you need 3 lines | Point to specific line ranges or functions |

### 1.6 Cost by Task Type (Typical Ranges)

Based on community-reported averages with Sonnet as default:

| Task Type | Typical Session Cost | Token Pattern |
|-----------|---------------------|---------------|
| Quick question / syntax help | $0.01-0.05 | Low I/O, single exchange |
| Bug fix (known location) | $0.05-0.25 | Moderate reads, focused writes |
| Feature implementation | $0.25-1.00 | Many file reads, substantial output |
| Multi-file refactoring | $0.50-3.00 | Heavy reads, heavy writes, long sessions |
| Architecture planning | $0.10-0.50 | Heavy thinking, moderate output |
| Code review | $0.10-0.30 | Heavy reads, moderate output |
| Full-day development | $2.00-12.00 | Multiple sessions, varied complexity |
| Agent team task | $1.00-10.00+ | Multiplied by number of agents |

**Anthropic's published averages**: $6/developer/day average, <$12/day for 90% of users. $100-200/developer/month with Sonnet. These are API costs — subscription users pay flat rates.

---

## Part 2: Cross-Cutting Cost Annotations by Curriculum Level

These annotations should be integrated into each curriculum level as a "💰 Cost Awareness" section.

### Level 0: Foundations — Cost Awareness

**What to teach:**
- The token cost model (input vs. output, compounding history)
- Model tier pricing differences (Haiku: 1x, Sonnet: 3x, Opus: 5x)
- Subscription vs. API: which makes sense for your situation
- Install ccusage on day one: `npx ccusage@latest`
- Run `/cost` after your first session to see what it looks like

**Coaching prompt:**
> "Before you write your first prompt, understand what you're paying for. Run `/cost` after every few messages today. Notice how the number grows — that's context compounding."

**Diagnostic addition:**
> If user is on API: Check if they've set workspace spend limits in Console.
> If user is on subscription: Ask if they've ever run ccusage to compare actual usage against plan value.

### Level 1: Effective Prompting — Prompt Efficiency

**What to teach:**
- Vague prompts are expensive prompts (exploration tax)
- Specific prompts save 2-5x on token usage
- The "one clear task per message" principle
- Plan mode (Shift+Tab) as a cost control: think cheap, execute once
- Output Styles impact: Learning mode generates more output (more tokens) — worth it for skill-building, but switch to Default for production work

**Coaching prompt:**
> "Rewrite this prompt to be more cost-efficient. A $0.50 prompt that works on the first try beats a $0.05 prompt that takes 10 rounds of clarification ($0.50 + wasted time)."

**Key insight for coaching:**
> First-try success rate IS a cost metric. An 80% first-try rate means 20% of your spend is rework. Improving prompt quality has compounding returns.

### Level 2: Project Configuration — Configuration as Cost Control

**What to teach:**
- CLAUDE.md is loaded every session — keep it lean (<150 lines)
- Use @imports to split large configs (load only what's needed)
- Include "DO NOT read" directories (node_modules, dist, .next, build artifacts)
- Test commands prevent the most expensive failure: Claude guessing build/test patterns
- Rules files (`.claude/rules/*.md`) load contextually — cheaper than putting everything in CLAUDE.md

**Coaching prompt:**
> "Every line in CLAUDE.md is read on every message. Is everything in there earning its keep? Move infrequent context to rules files that load only when relevant."

**Diagnostic addition:**
> CLAUDE.md > 150 lines without @imports → Flag as cost issue
> Missing test commands → Flag: "Claude will guess, fail, retry — most expensive pattern"
> No excluded directories → Flag: "Claude may read node_modules or build outputs"

### Level 3: Context Engineering — The Cost-Critical Level

**What to teach:**
- Context is THE cost lever. Everything else is optimization at the margin.
- Token costs scale quadratically with attention (n² problem in transformer architecture)
- Performance AND accuracy degrade past ~50% context fill — you're paying more for worse results
- The /clear, /compact, /rename lifecycle as the core cost-management workflow
- Custom compaction instructions preserve what matters, discard what doesn't
- Just-in-time context retrieval: don't front-load entire codebases, reference files as needed
- Progressive disclosure: metadata first, details on demand
- The "right altitude" framework saves money by avoiding over-specification (too much context) and under-specification (too many retries)

**Coaching prompt:**
> "Context engineering IS cost engineering. Every token in your context window is re-read on every message. A 100K context window at message 20 has cost you 2M input tokens just in history re-reads."

**Diagnostic addition:**
> No evidence of /clear or /compact usage in session patterns → Flag as highest-priority cost issue
> Sessions consistently hitting auto-compact (95%) → "You're paying premium rates on bloated context for many messages before auto-compact kicks in"

### Level 4: Skills & Commands — Build Efficient Skills

**What to teach:**
- Progressive disclosure in skills is a cost feature: metadata loads at startup (small), core instructions load on demand (medium), nested resources load only when needed (targeted)
- Contrast with loading everything upfront: a 5,000-token skill file loaded every session vs. a 500-token metadata file + 4,500 tokens loaded only when the skill is invoked
- Eval workflows prevent the expensive cycle of deploy → discover problems → fix → redeploy

**Coaching prompt:**
> "A well-structured skill with progressive disclosure costs 1/10th the context budget of a monolithic instruction file. Structure skills like you'd structure a lazy-loading web app."

### Level 5: Custom Agents — Agent Cost Architecture

**What to teach:**
- Every agent gets its own context window — including its system prompt, CLAUDE.md, etc.
- Agent model selection: not every agent needs Sonnet. Haiku agents for simple tasks cost 1/3rd as much.
- Read-only agents (tool restrictions) can't accidentally trigger expensive write/execute operations
- The Builder-Validator pattern: builder uses Sonnet, validator can use Haiku
- Agent description quality affects auto-delegation accuracy — wrong delegation = wasted context windows

**Coaching prompt:**
> "Every agent spin-up has a fixed initialization cost (system prompt + CLAUDE.md + tool definitions). An agent that runs for one message and exits wasted most of its tokens on setup. Design agents for sustained work, not one-shot questions."

**Diagnostic addition:**
> Agents without model specification → Flag: "Defaulting to your session model. Could this agent use Haiku?"
> Agents without tool restrictions → Flag: "Unrestricted agents may read/write unnecessarily"

### Level 6: Hooks — Automated Cost Protection

**What to teach:**
- Hooks run OUTSIDE the agentic loop (deterministic, zero token cost)
- Cost monitoring hooks: track spend per session, alert at thresholds
- Quality gate hooks prevent expensive rework: lint before commit, test before merge
- PreToolUse hooks can block expensive operations (e.g., prevent reading entire directories)

**Example cost-monitoring hook:**
```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": ".*",
      "command": "python .claude/hooks/cost-monitor.py"
    }]
  }
}
```

**Coaching prompt:**
> "Hooks are free runtime cost controls. A $0 lint hook that catches errors before Claude sees them saves the $0.50 round-trip of Claude reading errors and fixing them."

**Diagnostic addition:**
> No hooks configured → Mention cost-monitoring hooks as a quick win
> No test/lint hooks → "Pre-commit quality gates are the highest-ROI hook pattern"

### Level 7: MCP Integration — Tool Economy

**What to teach:**
- Each MCP server injects tool definitions into context (typically 200-1,000 tokens per server)
- 10 servers × 500 tokens = 5,000 tokens loaded on every single message
- Tool Search dynamically loads tools only when needed — the cost-efficient approach at scale
- Audit tool usage: most developers use only 3-4 MCP servers daily despite having 10+ installed

**Coaching prompt:**
> "Run `/context` right now. How much of your context budget is MCP tool definitions? If it's more than 5%, you have servers consuming tokens without providing value."

**Diagnostic addition:**
> 10+ MCP servers in .mcp.json → Flag with: "Community consensus: most use only 4 daily. Disable or switch to Tool Search."
> Tool Search not enabled with many servers → Flag as cost optimization opportunity

### Level 8: Headless & Harness Pattern — Automation Cost Control

**What to teach:**
- Headless mode (`claude -p "prompt"`) enables batching, which is 50% cheaper
- The harness pattern (initializer + coding agent) is inherently cost-efficient: each session starts with clean context, progress file provides minimal but sufficient continuity
- Set `max_turns` and `timeout_minutes` in automated workflows to prevent runaway costs
- Git commits as session boundaries align with the commit-and-clear cost pattern
- The progress file (`claude-progress.txt`) is the cheapest possible inter-session state transfer — a few hundred tokens instead of an entire conversation history

**Coaching prompt:**
> "Automation without cost guardrails is a blank check. Always set max_turns and timeout_minutes. A runaway agent at Opus rates can burn through $50+ before anyone notices."

**Diagnostic addition:**
> Headless scripts without max_turns → Flag as critical: "No spending cap on automated runs"
> No progress file pattern → "Each automated session restarts from zero, re-reading and re-discovering what was already done"

### Level 9: Agent Teams — Multiplicative Cost Management

**What to teach:**
- Agent teams multiply costs: N agents × (system prompt + CLAUDE.md + tool defs + task context)
- Each teammate has an independent context window — no shared memory means some duplication
- Broadcast instructions go to ALL teammates (N× cost of a solo message)
- Delegate mode forces the lead to delegate rather than doing work itself (prevents lead from becoming an expensive bottleneck)
- Quality gate hooks (TaskCompleted, TeammateIdle) prevent agents from spinning on completed work
- The ROI calculation: agent teams are only cost-efficient when parallelization value exceeds the overhead

**When agent teams are cost-justified:**
- Tasks that are genuinely parallelizable (not sequential)
- Time savings outweigh the token cost premium
- Each agent has enough work to justify its initialization overhead
- The alternative (serial solo agent) would require many context resets anyway

**When agent teams waste money:**
- Simple tasks that don't benefit from parallelism
- Tasks requiring heavy coordination (coordination messages are expensive)
- When you're already near rate limits (agents compete for the same quota)

**Coaching prompt:**
> "Before spinning up a team, calculate: Does the time savings justify 3-5x the token cost? Often, a well-prompted solo agent with /clear between sub-tasks is cheaper AND faster."

### Level 10: Mastery — Cost as Engineering Discipline

**What to teach:**
- Cost per feature, cost per sprint, cost per developer — track as engineering metrics
- The "cost per accepted commit" metric: total tokens / merged commits. If this trends up, something is degrading.
- Build cost awareness into team culture: weekly ccusage reviews, model selection guidelines, context hygiene norms
- Ecosystem cost: Claude Code is the development tool, but Cowork, Chrome agent, and API calls for your product all contribute to total AI spend
- The build-vs-buy calculus for AI features in your SaaS product

**For the solo entrepreneur specifically:**
- Your AI tooling cost IS your development labor cost — budget accordingly
- $100-200/month for Claude Code is the equivalent of ~2-4 hours of developer time at market rates
- The question isn't "how do I minimize AI spend" but "how do I maximize output per dollar"
- Track ROI: features shipped / total AI spend. If you're shipping more per dollar over time, you're optimizing correctly

---

## Part 3: Diagnostic Framework Cost Additions

### New Scan Targets

```
# Check for cost monitoring tools
which ccusage || echo "ccusage not installed"
npx ccusage@latest monthly --compact 2>/dev/null

# Check for spend limits (API users)
# Look for ANTHROPIC_MAX_SPEND or workspace limits in settings

# Check for cost-relevant hooks
grep -r "cost\|budget\|spend\|token" .claude/hooks/ 2>/dev/null

# Check for model specifications in agents
grep -l "model:" .claude/agents/*.md 2>/dev/null

# Check MCP server count
cat .claude/.mcp.json 2>/dev/null | grep -c '"command"'

# Check CLAUDE.md size
wc -l CLAUDE.md 2>/dev/null
```

### Cost-Specific Anti-Patterns to Flag

| What to Check | Threshold | Flag Message |
|--------------|-----------|-------------|
| ccusage not installed | Missing | "Install ccusage — you can't optimize what you can't measure" |
| CLAUDE.md > 150 lines | >150 lines | "Loaded every message. Split into rules/ or use @imports" |
| No excluded directories in CLAUDE.md | Missing "DO NOT" | "Claude may read node_modules, dist/, etc." |
| No test commands in CLAUDE.md | Missing | "Claude will guess → fail → retry. Most expensive pattern." |
| 8+ MCP servers | >8 count | "Each server costs context tokens. Most use only 4 daily." |
| Agents without model: field | Any agent | "Defaulting to session model. Could this use Haiku?" |
| Headless scripts without max_turns | Any script | "No cost cap on automated runs — runaway risk" |
| No hooks at all | Empty hooks/ | "Free cost controls: lint gates, cost monitoring, security" |
| Using Opus as default model | Settings check | "Sonnet handles 80-90% of tasks at 60% lower cost" |

### New Combined Signals

| Scan Says | Prompt Says | Cost-Aware Coach Action |
|-----------|------------|------------------------|
| No ccusage, no /cost usage | "It seems expensive" | Teach measurement first — install ccusage |
| Opus default, no model switching | Good task quality | "Your work is great. Switch to Sonnet for 60% savings." |
| Long CLAUDE.md, many MCP servers | Frequent compaction | "Your baseline context is too heavy. Slim down before prompting." |
| Has agent teams | Simple task requests | "Agent teams for this? Solo agent is 3-5x cheaper." |
| Max 5x subscription | ccusage shows <$30/month equiv. | "Pro plan at $20 might be sufficient for your usage." |
| API user | ccusage shows >$150/month | "Max 5x at $100 might be cheaper than pay-per-token." |

---

## Part 4: Quick Reference Card

### The 5-Minute Cost Checkup

Run these at the start of each week:

```bash
# 1. What did I spend last week?
npx ccusage@latest daily --since $(date -v-7d +%Y%m%d)

# 2. Which model am I using most?
npx ccusage@latest daily --breakdown

# 3. What's my most expensive project?
npx ccusage@latest daily --instances

# 4. Am I on the right plan?
npx ccusage@latest monthly --plan max5  # or pro, max20
```

### The Cost-Conscious Workflow

```
1. Start session → /model sonnet (or opusplan for complex work)
2. Check /context → disable unused MCP servers
3. Work on ONE focused task
4. Git commit when done
5. /clear before next task
6. Check /cost periodically
7. Switch to Haiku for simple follow-ups
8. End of day: npx ccusage@latest daily
```

### Model Selection Cheat Sheet

| Task | Model | Why |
|------|-------|-----|
| Quick syntax question | Haiku | Instant, cheapest |
| Single-file edit | Haiku or Sonnet | Low complexity |
| Feature implementation | Sonnet | Sweet spot of capability/cost |
| Multi-file refactor | Sonnet or opusplan | Needs reasoning but also speed |
| Architecture decision | Opus (plan mode) | Worth the premium for correctness |
| Code review | Haiku | Read-heavy, judgment is sufficient |
| Debugging complex issue | opusplan | Opus reasons, Sonnet fixes |
| Writing tests | Sonnet | Moderate complexity, high output |
| Documentation | Haiku or Sonnet | Low reasoning requirement |

---

*This document is a living reference. Update pricing when models change. Review strategies quarterly as tooling evolves.*
