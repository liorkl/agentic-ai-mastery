# Claude Code Mastery Curriculum
## The Path to Agentic AI Development Mastery

**Version:** 1.1 — June 2026
**Purpose:** Foundation curriculum for the Claude Code Coaching Agent
**Last reviewed:** June 19, 2026

> **Sync status (2026-06-19):** Reconciled to the shipped plugin — verification-first / five cross-cutting practices spine, cost coaching off by default (opt-in via /coach:cost), current June-2026 models. Levels are a feature scaffold, not a score.

---

## Curriculum Philosophy

Mastery is not about memorizing commands. It's about developing **engineering judgment** for when and how to delegate work to AI agents. Each level builds a mental model, not just a skill set.

**North star:** Coaching exists to (a) get the best work out of Claude and (b) build repos where Claude does its best work — not to "collect features." The L0–L10 ladder below is a **feature-progression scaffold**, not a proxy for skill and not a score. A developer who has only touched L0–L3 features but applies the five cross-cutting practices well is more skilled than one who has wired up agent teams and MCP servers but never gives Claude a way to verify its own work.

**The five cross-cutting practices (verification first) outrank feature breadth.** They are coached at *every* level and matter more than how far up the ladder a developer has climbed:

1. **Verification first** — give Claude a check it can run itself (tests, build, lint, a script, a screenshot). This is the #1 lever on output quality.
2. **Explore → plan → code** — separate research and planning from execution; use plan mode before writing code.
3. **Ground the prompt** — point at specific files, an example pattern to follow, and the concrete symptom.
4. **Course-correct early** — stop and redirect on drift rather than letting it compound; `/clear` and re-prompt when needed.
5. **Manage context** — keep CLAUDE.md short, `/clear` between tasks, push investigation into subagents.

**Progression principle:** At each level, the developer should be able to _explain why_ they do things a certain way — not just _how_. This is what separates a power user from someone following a tutorial.

**Key terminology shift (Sep 2025):** Anthropic formally introduced **context engineering** as the successor to prompt engineering. The curriculum reflects this — prompting is Level 1, but context engineering is a discipline that pervades Levels 2-10. As Anthropic defines it: "the set of strategies for curating and maintaining the optimal set of tokens during LLM inference."

**Phase-2 re-order (2026-06-21):** The structural re-order is now **done**. The ladder was reshaped to match how the work actually compounds, while keeping the verification-first spine and the five cross-cutting practices intact:
- **Old L2 (Project Configuration) + old L3 (Context Engineering) are merged into one L2 — "Project Memory & Context."** Configuration and context hygiene are the same discipline (curating the tokens Claude sees), so they now live together; overlapping `@path` / memory / context-rot material was deduped.
- **L4–L8 shifted down by one** after the merge: old L4 (Skills) → L3, old L5 (Subagents) → L4, old L6 (Hooks) → L5, old L7 (MCP) → L6, old L8 (Headless/SDK) → L7.
- **A new L8 — "Parallel Work: Worktrees & Dual-Instance"** is inserted **before** Agent Teams: git worktrees and the two-session (write/review) pattern are the simpler parallelism rung you reach for before a full team.
- **Permission modes (default/acceptEdits/plan/auto/dontAsk/bypassPermissions) + the `auto` safety classifier, and checkpoints/rewind** are folded into **L0** as the autonomy ↔ oversight dial and safe-exploration tools.
- **Agent Teams stays L9; Mastery stays L10** (reframed as distribution + operating at scale).
- **MCP was subsequently moved to L3 (external context & reach), with Skills/Subagents/Hooks shifting to L4/L5/L6** — because MCP is fundamentally a context mechanism and belongs adjacent to the context level (this also matches Anthropic's extension-priority ordering, which puts MCP before skills and hooks).

Context engineering still **pervades Levels 2-10**; verification-first still outranks feature breadth.

---

## Level 0: Foundations & Setup — "First Contact"
**Goal:** Get productive fast. Understand what Claude Code _is_ and _isn't_ — and where it sits in the broader Claude ecosystem.
**Mindset shift:** From "AI as autocomplete" → "AI as a junior developer I'm directing"

### Topics

#### 0.1 The Claude Ecosystem (Feb 2026)
- **Claude.ai** — Chat, Projects, Memory, Artifacts, Web Search, file creation
- **Claude Code** — Agentic coding in terminal, IDE, desktop, and browser
- **Cowork** (Jan 2026) — Desktop agent for non-coding tasks: file management, documents, presentations
- **Claude in Chrome** — Browser agent for navigation, form-filling, multi-tab workflows
- **Claude in Excel / PowerPoint** — Spreadsheet and presentation agents
- **Claude API & Agent SDK** — Programmatic access for building custom agents
- When to use which surface — choosing the right tool for the task

#### 0.2 Installation & Environment Setup
- Installing Claude Code (`npm install -g @anthropic-ai/claude-code`)
- Authentication: Claude Pro/Max subscription or API key
- Terminal integration basics
- IDE integration (VS Code, JetBrains)
- Understanding what Claude Code can access (file system, terminal, git)

#### 0.3 Your First Interaction
- Basic prompting: asking Claude Code to do a task
- Understanding the conversation loop
- Reading Claude's output (what it did, what it changed)
- Using `!` for quick shell commands
- Keyboard shortcuts (`Shift+?` to see all, `Escape` to interrupt)
- `/init` command: auto-generating your first CLAUDE.md

#### 0.4 The Safety Model — Permission Modes & the Autonomy Dial
- **Permission modes** — the autonomy ↔ oversight dial:
  - **default** — ask before each consequential action
  - **acceptEdits** — auto-accept file edits, still ask for the riskier stuff
  - **plan** — read/plan only, no edits or commands (see Level 1)
  - **auto** — let Claude decide, gated by the **`auto` safety classifier** that judges each action and still stops for genuinely risky ones
  - **dontAsk** — stop prompting for a known-safe allowlist
  - **bypassPermissions** (`--dangerously-skip-permissions`) — no prompts at all; only in a sandbox/throwaway env
- Understanding what Claude asks permission for and why
- Reading permission prompts carefully — not just hitting "yes"
- Sandboxing basics for safe experimentation (`/sandbox`)
- Permission wildcards: `Bash(npm run *)`, `Edit(/docs/**)`

#### 0.5 Checkpoints & Rewind — Safe Exploration
- Claude Code snapshots state so you can explore boldly and roll back if a direction is wrong
- `/rewind` to restore a previous checkpoint (conversation and/or file state)
- Why this lowers the cost of letting Claude try something: a bad attempt is one rewind away
- Pairs with course-correcting early — back out of drift instead of fighting it forward

#### 0.6 Model Selection Basics
- **Opus 4.8** (`claude-opus-4-8`) — Default model; strongest reasoning and coding, 1M context
- **Fable 5** (`claude-fable-5`) — Frontier model for the hardest, most open-ended work, 1M context
- **Sonnet 4.6** (`claude-sonnet-4-6`) — Fast, capable coding model, 1M context
- **Haiku 4.5** (`claude-haiku-4-5`) — Fastest/cheapest, great for subagents and high-volume work, 200K context
- When each model is appropriate (start with the default; reach for others by task fit, not habit)
- Switching models: `--model` flag

#### 0.7 When NOT to Use Claude Code
- Tasks where AI adds risk (security-critical, compliance, irreversible ops)
- Understanding hallucination risks in code generation
- The accountability principle: "You own the code in your PR, regardless of who wrote it"

### Mastery Check
> Can you explain to a colleague what Claude Code does, how it fits in the broader Claude ecosystem, and what the safety boundaries are?

### Official Resources
- [Anthropic Academy: Claude 101](https://anthropic.skilljar.com/claude-101) (free, certificate)
- [Claude Code Documentation](https://code.claude.com/docs/en/overview)
- [DeepLearning.AI: Claude Code course](https://www.deeplearning.ai/short-courses/claude-code-a-highly-agentic-coding-assistant/) (free)

---

## Level 1: Prompting & the Core Loop — "Speaking the Language"
**Goal:** Learn to communicate intent clearly, run the explore → plan → code → verify loop, and get reliable results.
**Mindset shift:** From "type and hope" → "precise delegation with success criteria, planned before executed and verified after"

### Topics

#### 1.1 The Core Loop: Explore → Plan → Code → Verify
- The single most important habit: research and plan _before_ writing code, then give Claude a way to check its own work
- **Explore** — read the relevant files / patterns first (use plan mode or the Explore subagent)
- **Plan** — turn intent into a reviewed plan before any edits (plan mode, see 1.5)
- **Code** — execute the approved plan
- **Verify** — Claude runs a check it can see the result of (tests, build, lint, a script, a screenshot); the verification loop is the #1 lever on quality and is coached from the very start
- Why doing this early beats bolting it on later: it shapes every habit above it on the ladder

#### 1.2 Anatomy of a Good Prompt
- Specificity: what, where, how, and constraints
- Including success criteria ("the tests should pass", "match the existing code style")
- Providing examples of desired output
- Negative constraints: what NOT to do
- Using XML tags for structure (Anthropic's recommended practice)

#### 1.3 Context is Everything
- Why Claude's output quality depends on what it knows
- Pointing Claude to relevant files explicitly
- Using `@path` references to pull in specific context
- The difference between "fix the bug" and "fix the null check in src/auth/validate.ts line 42"

#### 1.4 Iterative Prompting
- Breaking large tasks into steps
- Reviewing output before asking for the next step
- Correcting course: "That's not what I meant — instead, do X"
- When to `/clear` and start fresh vs. continuing the conversation

#### 1.5 Plan Before Execute (Plan Mode)
- Activating Plan Mode (`Shift+Tab` twice)
- Why "plan first, code second" produces better results
- Reviewing and approving plans before execution
- The spec-based workflow: write spec → have Claude interview you via AskUserQuestionTool → execute spec in new session

#### 1.6 Output Styles (Feb 2026)
- **Default** — Concise task completion, minimal explanation
- **Explanatory** — Educational "Insights" blocks explaining implementation choices and patterns
- **Learning** — Collaborative mode with `TODO(human)` markers for hands-on practice
- **Custom output styles** — Creating your own via `/output-style:new`
- When to use each: Explanatory for new codebases, Learning for skill-building
- Relevance to coaching: the Learning output style IS a coaching interface

#### 1.7 Adaptive Thinking & Effort (Claude 4.x)
- Adaptive thinking: Claude adjusts reasoning depth automatically based on task complexity
- `effort` levels (low / medium / high / xhigh / max) replace the old manual `budget_tokens` / "extended thinking budget" knob — you set how hard to think, not a token count
- When higher effort earns its keep (hard reasoning, tricky debugging) vs. when low effort is enough
- Vision optimization for image-based tasks

### Mastery Check
> Given a feature request, can you write a prompt that produces correct code on the first try 80%+ of the time — and choose the appropriate output style for your current needs?

### Official Resources
- [Prompt Engineering Guide](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/overview)
- [Claude 4.x Prompting Best Practices](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/claude-4-best-practices)
- [Interactive Prompt Engineering Tutorial (9 chapters)](https://github.com/anthropics/prompt-eng-interactive-tutorial)

---

## Level 2: Project Memory & Context — "Teaching Claude About Your Project"
**Goal:** Set up persistent project memory _and_ actively manage the context window — two halves of the same discipline: curating the tokens Claude sees.
**Mindset shift:** From "one-off prompts in an infinite conversation" → "a configured environment where context is a finite resource I engineer"

**Why this level matters most:** Configuration (what you give Claude up front) and context hygiene (what you let accumulate during a session) are the same problem from two ends. Anthropic's own research shows performance degrades as context fills — a phenomenon called **context rot** — because every token introduced depletes an "attention budget." A great CLAUDE.md that you then drown in 200k tokens of stale conversation helps no one. This level teaches both: persist the right context, and keep the live window clean.

### Topics

#### 2.1 CLAUDE.md — Your Project's Brain
- What CLAUDE.md is and when Claude reads it (loaded into system prompt at startup)
- Five essential sections: project description, build commands, code style, architecture, testing
- What NOT to include: don't exceed ~150 lines; keep it focused (a bloated CLAUDE.md is itself context rot you ship on every session)
- Multiple CLAUDE.md files: root-level + subdirectory-specific (e.g., `/frontend/CLAUDE.md`)
- Priority hierarchy: module-level > project-level > user-level (~/.claude/CLAUDE.md)
- AGENTS.md symlink for cross-tool compatibility (Copilot, Cursor)
- `/init` generates a starter; treat it as a starting point, not the final version
- Using `@path` references to pull in other files modularly — keep the entrypoint thin, load detail on demand

#### 2.2 Memory System & Auto-Memory
- How Claude Code's memory works across sessions
- `/memory` command for checking and editing
- Auto-memory: Claude builds persistent context automatically across conversations
- CLAUDE.local.md for personal preferences (git-ignored)
- The ~200-line entrypoint limit and why it matters
- Strategic, scoped use of memory for persistent preferences — store the durable, not the disposable

#### 2.3 Rules Files & Scoping
- `.claude/rules/*.md` — modular topic-specific instructions
- Path-scoped rules via frontmatter (apply only to certain directories)
- When rules are better than CLAUDE.md entries (separation of concerns)
- Scoping is a context tool: rules and module-level CLAUDE.md load only where relevant, so Claude isn't carrying frontend conventions while editing the backend

#### 2.4 Settings & Configuration
- `settings.json` hierarchy: managed → project shared → project local → user
- Permission wildcards (e.g., `Bash(npm run *)`, `Edit(/docs/**)`)
- Deny rules for sensitive files (`.env*`, `~/.aws/**`)
- Model selection per context
- Output style persistence per project (`.claude/settings.local.json`)
- Environment variables: `CLAUDE_ENV_FILE`, `CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR`

#### 2.5 Understanding the Context Window
- What goes into context: system prompt, CLAUDE.md, messages, file reads, tool results, MCP tool definitions
- How context fills up (it happens faster than you think)
- The n² attention problem: every token attends to every other token
- Performance degradation past ~50% context fill: forgetting instructions, increased errors
- Monitoring context usage with a custom status line

#### 2.6 Context Hygiene
- `/clear` — when and why to use it aggressively (start fresh for a new task, don't continue indefinitely)
- `/compact` — automatic summarization when approaching limits (Anthropic's built-in compaction)
- `/rewind` — drop back to a clean checkpoint when a session has gone off the rails (also a Level 0 safe-exploration tool)
- The **context rot** problem: why AI gets worse the longer you chat, and how the attention budget runs down
- `/resume` to restart conversations with prior context

#### 2.7 Strategic Context Loading
- **Just-in-time retrieval** vs. upfront loading (Anthropic's recommended approach)
- Maintaining lightweight identifiers (file paths, stored queries, links) over full file contents
- Using the Explore subagent for read-only codebase discovery (push investigation out of the main window)
- Progressive disclosure: loading information only when the task requires it
- The metadata advantage: folder hierarchies and naming conventions as implicit signals

#### 2.8 Token-Efficient Workflows
- Commit-and-clear pattern: complete a unit of work, commit, clear, move on
- Using scratchpads and intermediate files to persist state between sessions
- Reducing verbose tool outputs (e.g., trimming test output, filtering logs)
- Recognizing when context is degraded: signs and recovery strategies
- Tool Search feature: dynamic MCP tool loading when tools exceed 10% of context

#### 2.9 The Right Altitude (Anthropic's Framework)
- System prompts and CLAUDE.md should be neither too specific (brittle) nor too vague (unguided)
- The "Goldilocks zone" for instructions: specific enough to guide, flexible enough for heuristics
- Minimal viable context: the smallest set of high-signal tokens for the desired outcome
- Testing: start with minimal prompt on best model, then add based on failure modes

### Mastery Check
> Can you set up a project from scratch so a _new team member_ gets high-quality results immediately with no verbal instructions from you — AND complete a complex multi-file feature without context degradation, explaining your context strategy to another developer?

### Official Resources
- [Using CLAUDE.md Files (Anthropic Blog)](https://claude.com/blog/using-claude-md-files)
- [Claude Code Settings Reference](https://code.claude.com/docs/en/settings)
- [Manage Claude's Memory](https://code.claude.com/docs/en/memory)
- [Context Engineering for AI Agents (Anthropic Engineering)](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)
- [Claude Code Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices)
- [Effective Harnesses for Long-Running Agents](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)

---

## Level 3: MCP Integration — "Extend Claude's Context & Reach"
**Goal:** Connect Claude Code to external sources of context — and tools that act on them — via the Model Context Protocol.
**Mindset shift:** From "context lives in my repo and my conversation" → "context comes from my whole toolchain — git, Slack, Jira, Google Docs, logs, AWS — and Claude can act on it too"

**The natural extension of Level 2.** Level 2 was about _internal_ context — the tokens you curate from your own repo and session. MCP is how you reach _external_ context: it gathers from outside sources (git history, Slack threads, Jira tickets, Google Docs, production logs, AWS) **and acts on them** (driving a browser via Playwright, inspecting a page via Chrome DevTools, opening PRs via GitHub). It sits right here, immediately after the context level, so you learn it **cost-aware** from day one.

**Mind the context cost.** Every connected MCP server's tool definitions sit in the window from the first token — connecting all of them upfront is an anti-pattern (Level 2 again). Prefer **progressive disclosure** / code-execution loading: one real workflow dropped from ~150k to ~2k tokens by loading tool defs on demand instead of all at once. Tool Search (3.3) is how Claude Code does this automatically.

### Topics

#### 3.1 What MCP Is
- Model Context Protocol: an **open standard** for connecting AI to external sources of context and tools
- MCP servers expose tools that Claude can invoke — both to **pull context** (read git, Slack, Jira, Google Docs, logs, AWS) and to **act** (drive a browser, open PRs, query a DB)
- Adding MCP servers: `claude mcp add <name> -- <command>`
- MCP configuration locations: `.mcp.json` (project), `.claude/settings.local.json`, `~/.claude.json`

#### 3.2 Essential MCP Servers
- **Context7 / docs fetcher** — Up-to-date library docs, prevents hallucinated APIs
- **Browser automation** (Puppeteer, Playwright) — Claude tests your UI, sees console logs (acts on the browser)
- **Chrome DevTools** — Claude inspects DOM, network, console in your real browser
- **Error tracking** (Sentry) — Claude diagnoses production errors
- **Database access** (PostgreSQL, SQLite) — Claude queries and analyzes data
- **GitHub** — Claude manages issues, PRs, repos
- **Excalidraw** — Claude generates architecture diagrams

#### 3.3 Tool Search — Dynamic Tool Loading (Late 2025)
- When MCP tools exceed 10% of your context window, Tool Search activates
- Dynamically loads only relevant MCP tools instead of all at once
- Critical for users with many MCP servers configured
- Can be disabled if you prefer upfront loading (increases context usage)

#### 3.4 When MCP is Worth the Complexity
- Don't add servers you won't use regularly
- Community wisdom: "Went overboard with 15 MCP servers — ended up using only 4 daily."
- Evaluating MCP server quality, reliability, and maintenance
- Security considerations: what access are you granting? Vet and trust each server before connecting it

#### 3.5 Building Custom MCP Servers
- When to build vs. use existing
- FastMCP (Python) vs. MCP SDK (TypeScript)
- Designing tools Claude will actually use well (clear names, minimal overlap)
- Testing MCP servers independently

### Mastery Check
> Can you identify which MCP servers add real value to your workflow and integrate them without reliability issues?

### Official Resources
- [MCP Protocol Specification](https://modelcontextprotocol.io)
- [DeepLearning.AI: MCP course](https://www.deeplearning.ai/short-courses/mcp-build-rich-context-ai-apps-with-anthropic/) (free)
- [Anthropic Academy: MCP Getting Started + Advanced](https://anthropic.skilljar.com/introduction-to-model-context-protocol) (free, 2 courses)

---

## Level 4: Skills & Slash Commands — "Reusable Workflows"
**Goal:** Stop repeating yourself. Encode proven workflows using the Agent Skills open standard.
**Mindset shift:** From "ad-hoc instructions each time" → "workflow engineering with progressive disclosure"

### Topics

#### 4.1 Agent Skills — The Open Standard (Dec 2025)
- `.claude/skills/` — the current best practice; lead here, commands are legacy
- Skills as an **open standard**: portable across Claude.ai, Claude Code, Cowork, and the API
- Anatomy of a SKILL.md: name + description in frontmatter (scanned at startup), body loaded on demand
- Supporting files: scripts, resources, reference docs bundled in the skill folder
- Partner skills: Atlassian, Canva, Figma, Notion, Cloudflare, Stripe, Zapier
- Built-in skills: PDF, DOCX, XLSX, PPTX (power Claude.ai's file creation)

#### 4.2 Slash Commands (Legacy, Still Supported)
- What they are: prompt templates stored as `.claude/commands/*.md`
- Creating project-level vs. user-level commands
- Parameterized commands with `$ARGUMENTS`
- Frontmatter for allowed tools and descriptions
- Note: Skills are now recommended over commands for new work

#### 4.3 Progressive Disclosure Architecture
- **3-level loading**: metadata → core instructions → nested resources
- Why this matters: context efficiency by design
- Metadata (name + description) loaded at startup costs minimal tokens
- Body loaded only when task matches — no wasted context on irrelevant skills
- Skills can include executable code that Claude runs without loading into context

#### 4.4 Designing Good Skills
- Clear trigger descriptions (so Claude knows when to use them)
- Step-by-step procedures that produce consistent results
- Including examples of good and bad output
- Testing skills with the skill-creator workflow: draft → eval → iterate → improve
- Using the `evals/` directory for structured skill testing

#### 4.5 Skill Composition & Distribution
- Skills that invoke other skills or reference supporting documents
- Building a personal skill library (user-level `~/.claude/skills/`)
- Community skills: [Anthropic Skills Repository](https://github.com/anthropics/skills)
- [Skills Cookbook](https://github.com/anthropics/anthropic-cookbook/tree/main/skills) for recipes
- Organization-wide skill deployment

### Mastery Check
> Can you build a skill with progressive disclosure that works across Claude Code AND Claude.ai, test it with evals, and iterate to improve quality?

### Official Resources
- [Introducing Agent Skills (Anthropic)](https://www.anthropic.com/news/skills)
- [Equipping Agents with Agent Skills (Engineering)](https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills)
- [DeepLearning.AI: Agent Skills with Anthropic](https://www.deeplearning.ai/short-courses/agent-skills-with-anthropic/) (free)
- [The Complete Guide to Building Skills (PDF)](https://resources.anthropic.com/hubfs/The-Complete-Guide-to-Building-Skill-for-Claude.pdf)

---

## Level 5: Custom Agents (Subagents) — "Context Isolation as a Tool"
**Goal:** Create focused AI agents that handle specific types of work — and keep their context out of your main window.
**Mindset shift:** From "one general assistant in one context window" → "a team of specialists I designed, each with its own isolated context"

**Frame first:** A subagent is, above all, a **context-isolation tool**. Its own window does the noisy work — searching the codebase, reading dozens of files, churning through tool output — and returns only the conclusion to the parent. That keeps the main conversation clean (Level 2 made this matter). Specialization and tool restriction are the second benefit, not the first.

### Topics

#### 5.1 What Custom Agents Are
- Markdown files with YAML frontmatter in `.claude/agents/`
- Own context window, system prompt, tool access, permissions, model, and visual color
- **Context isolation**: a subagent's reads and tool output stay in _its_ window; only the result returns to the parent
- **Automatic delegation**: Claude routes tasks based on description — like tool invocation
- Project-level vs. user-level agents (`~/.claude/agents/`)

#### 5.2 Agent Design Principles
- One agent, one job (code reviewer ≠ code writer ≠ test writer)
- Constraining tool access (read-only agents can't use Write, Edit, NotebookEdit)
- Model selection per agent (Haiku 4.5 for fast, high-volume subagent work; Opus 4.8 for the orchestrating agent)
- Writing effective descriptions so auto-delegation works reliably
- Background color coding for visual identification in terminal

#### 5.3 Built-in Subagents
- **Explore** — Fast, read-only codebase search and analysis (uses Sonnet by default)
- **Plan** — Research and analysis without file changes
- **General-purpose** — Default delegation target
- When to use built-in vs. custom agents

#### 5.4 Creating Your First Agents
- Using `/agents` command → Create new agent → Generate with Claude (recommended)
- Manual creation: YAML frontmatter + system prompt
- The essential starter set: Reviewer (read-only), Planner, Implementer, Tester
- Iterating on agent prompts based on real results

#### 5.5 Subagent Patterns
- Task delegation: when Claude invokes an agent automatically
- Explicit invocation via `/agent` command
- Fan-out: multiple agents working on different aspects
- Builder-Validator pattern: implementation agent + read-only validation agent
- Context isolation: subagents don't inherit parent conversation history

#### 5.6 Designing the Coach Agent (Meta-Exercise)
- Building the coaching agent itself as a mastery exercise
- Persistence patterns (JSONL progress tracking)
- Diagnostic questioning techniques
- Adaptive difficulty based on observed performance

### Mastery Check
> Can you design a custom agent with appropriate tool restrictions, model selection, and descriptions that enable reliable automatic delegation?

### Official Resources
- [Create Custom Subagents (Claude Code Docs)](https://code.claude.com/docs/en/sub-agents)
- [Anthropic Academy: Claude Code in Action](https://anthropic.skilljar.com/claude-code-in-action) (free, certificate)

---

## Level 6: Hooks — "Deterministic Quality Gates"
**Goal:** Add automated guardrails that run outside the AI loop.
**Mindset shift:** From "trust but verify manually" → "automated enforcement at every step"

**The `Stop` hook is the verification gate.** It's where the Level 1 verification loop becomes non-optional: when Claude finishes responding, a deterministic check runs (tests, build, lint) and blocks "done" until it passes — no LLM judgment involved.

### Topics

#### 6.1 What Hooks Are
- Scripts that run on specific lifecycle events, _outside_ the agentic loop
- Not AI — deterministic code (shell scripts, Python) that enforces rules
- The critical distinction: hooks are reliable because they don't involve LLM judgment
- Hooks are typically under 100 lines, with clear comments

#### 6.2 Hook Events
- `PreToolUse` — before Claude uses a tool (intercept, modify, block)
- `PostToolUse` — after Claude uses a tool (validate, log, alert)
- `Stop` — when Claude finishes responding (enforce quality checks) — **the verification gate**
- `TeammateIdle` — when a team member finishes (reassign, redirect) — Level 9
- `TaskCompleted` — when a task is marked done (gate on tests, lint) — Level 9

#### 6.3 Essential Hook Patterns
- **Security hooks:** Block secrets before they reach your repo
- **Quality hooks:** Run linter/formatter after every file edit (ruff, prettier, eslint)
- **Logging hooks:** Track what Claude does for audit/debugging
- **Cost hooks:** Monitor token usage and alert on runaway sessions
- **Test hooks:** Require tests to pass before marking work complete
- **Status line hooks:** Custom status display showing context usage, DDD progress, etc.

#### 6.4 Writing Production Hooks
- Keep hooks fast (they block the workflow)
- Exit code conventions: 0 = pass, 1 = error, 2 = send feedback to Claude
- Exit code 2 is powerful: it sends the hook's output back as feedback
- Avoiding context pollution from verbose hook outputs
- Testing hooks independently before deploying
- Caveat: automatic formatting hooks can consume significant context tokens

### Mastery Check
> Can you implement a hook pipeline that catches 90%+ of quality issues before you ever review Claude's work?

### Official Resources
- [Skills and Hooks Starter Kit](https://github.com/DavidROliverBA/Daves-Claude-Code-Skills)
- [Claude Code Best Practices — Hooks section](https://www.anthropic.com/engineering/claude-code-best-practices)

---

## Level 7: Headless, SDK & CI — "Claude in Your Pipeline"
**Goal:** Run Claude Code programmatically and across multiple context windows.
**Mindset shift:** From "interactive assistant" → "programmable component in my engineering system"

### Topics

#### 7.1 Headless Mode
- `claude -p "prompt"` — non-interactive execution
- Output formats: plain text, JSON (`--output-format json`), streaming JSON
- Use cases: pre-commit hooks, CI checks, automated code review, documentation generation
- **Scheduled runs:** cron / CI triggers for unattended jobs (nightly review, doc sync)

#### 7.2 CI/CD & Fan-Out Patterns
- PR review bot: Claude reviews every pull request
- Automated test generation on new files
- Documentation sync: regenerate docs when code changes
- Release notes generation from commit history
- **Fan-out:** run many headless invocations in parallel over a batch of inputs (files, PRs, repos), then gather results
- Cost management for automated usage

#### 7.3 The Harness Pattern for Long-Running Agents (Nov 2025)
- **The problem:** Complex projects can't be completed in one context window
- **Initializer agent:** First session sets up environment — init.sh, feature list, progress file, initial git commit
- **Coding agent:** Every subsequent session makes incremental progress, then leaves structured updates
- **Progress file** (`claude-progress.txt`): log of what agents have done, readable by next session
- **Feature list in JSON** (not Markdown — less likely to be improperly modified): tracks pass/fail per feature
- **Incremental progress:** One feature at a time, commit with descriptive messages
- **Clean state principle:** Every session ends in a merge-ready state
- This pattern bridges the gap between context windows like shift handoffs between engineers

#### 7.4 The Claude Agent SDK (Sep 2025)
- **Claude Agent SDK** — renamed from "Claude Code SDK"; now a general agent platform
- Powers Claude Code, but also deep research, video creation, note-taking, and non-coding tasks
- Building standalone agents: Python and TypeScript SDKs
- Agent lifecycle, tool registration, state persistence, workflow orchestration
- Compaction: automatic context summarization for long-running agents
- When the SDK is appropriate vs. simple headless mode

### Mastery Check
> Can you set up a long-running agent workflow that completes a multi-day project across many context windows, with structured progress tracking?

### Official Resources
- [Effective Harnesses for Long-Running Agents (Anthropic)](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)
- [Agent SDK Documentation](https://docs.anthropic.com/en/docs/claude-code/sdk)
- [Autonomous Coding Quickstart (GitHub)](https://github.com/anthropics/claude-quickstarts/tree/main/autonomous-coding)

---

## Level 8: Parallel Work — Worktrees & Dual-Instance — "Two Hands Before a Team"
**Goal:** Get the speed of parallelism with almost none of the coordination cost — by running independent plain CLI sessions, not an orchestrated team.
**Mindset shift:** From "one session, one branch, one task at a time" → "isolated parallel checkouts and a write/review split, before you ever reach for Agent Teams"

**Why this rung exists:** Most "I need parallelism" moments don't need an orchestrated team (Level 9) with its message-passing, shared task lists, and token overhead. They need two ordinary sessions that don't step on each other. This is the simpler, cheaper, more predictable parallelism rung — master it first.

### Topics

#### 8.1 Git Worktrees — Isolated Checkouts
- `git worktree add ../feature-x feature-x` — a second working directory for a different branch off the same repo
- Each worktree is a real, isolated checkout: a Claude session in one can't collide with edits, builds, or test runs in another
- Run two (or more) Claude Code sessions, one per worktree, making parallel changes that never touch the same files
- Clean up with `git worktree remove` when the branch lands
- When to reach for it: two genuinely independent changes (two features, or a feature + a refactor) you want progressing at once

#### 8.2 The Dual-Instance Pattern — Writer + Reviewer
- Two plain CLI sessions on the **same** work: one **writes**, one **reviews**
- The writer implements; the reviewer runs read-only, critiques the diff, runs tests, and feeds findings back
- A lightweight, human-mediated version of the Builder–Validator pattern — no team machinery, no automatic message delivery
- Why it works: the reviewer session has fresh, uncontaminated context (Level 2) and isn't invested in the writer's approach
- Pairs naturally with worktrees: writer in one checkout, reviewer pointed at the same branch or a sibling worktree

#### 8.3 Choosing the Right Parallelism
- Worktrees + dual-instance: independent or write/review work, minimal coordination, predictable cost — start here
- Subagents (Level 5): parallel work whose results you want folded back into _one_ context, isolation handled for you
- Agent Teams (Level 9): many interdependent tasks needing shared state and coordination — the heaviest tool, reach for it last
- The guiding rule: add coordination machinery only when simpler parallelism actually fails

### Mastery Check
> Can you run two productive Claude Code sessions in parallel — via worktrees or a writer/reviewer split — and articulate why you chose this over a subagent or an agent team?

### Official Resources
- [Claude Code Best Practices — parallel sessions & worktrees](https://www.anthropic.com/engineering/claude-code-best-practices)
- [git worktree documentation](https://git-scm.com/docs/git-worktree)

---

## Level 9: Agent Teams — "Multi-Agent Orchestration"
**Goal:** Coordinate multiple Claude instances working in parallel.
**Mindset shift:** From "one agent, one task" → "orchestrating a team of autonomous agents"

**Start simple — earn the team.** This is the last rung for a reason. Per Anthropic's "Building effective agents": prefer **workflows before agents**, and the simplest thing that works before either. **Don't reach for a team until a single call + verification has actually failed**, then a subagent (Level 5), then worktrees / dual-instance (Level 8) — and only then a team. Teams trade latency and token cost for parallelism and can **compound errors** across agents; the coordination is a liability you take on deliberately, not a default.

### Topics

#### 9.1 When to Use Agent Teams
- **The gate:** only after a single call + verification fails, and a subagent or a worktree/dual-instance split (Level 8) won't do — escalate, don't start here
- Tasks that benefit from parallel _interdependent_ work needing shared state
- The cost-benefit analysis: teams consume more tokens, add latency, and risk compounding errors — but finish wide work faster
- Not everything needs a team — solo agents and the Level 8 patterns are often better
- **Experimental status:** Requires `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` in settings
- Fast Mode: higher-speed responses for interactive team work

#### 9.2 Team Architecture
- Team lead: coordinates, delegates, synthesizes
- Teammates: independent context windows, own tools, own permissions
- Communication: automatic message delivery, shared task lists, direct messages, broadcasts
- Task states: pending → in progress → completed (with dependencies)
- Teammates load project context (CLAUDE.md, MCP, skills) but NOT lead's conversation history

#### 9.3 Orchestration Patterns
- **Fan-out / Fan-in:** Scatter work, gather results (e.g., review 5 modules in parallel)
- **Batch processing:** Same task on different inputs
- **Triage-then-deep-process:** One agent categorizes, others handle specifics
- **Debate pattern:** Multiple agents investigate hypotheses and challenge each other
- **Builder-Validator:** Implementation agent + read-only validation agent

#### 9.4 Team Management
- **Delegate mode:** Force the lead to delegate instead of doing work itself
- **Plan approval:** Review team plans before execution starts
- **Quality gate hooks:** `TeammateIdle` (reassign) and `TaskCompleted` (gate on tests)
- Display modes: split-pane for monitoring, click into teammate pane for direct interaction
- Token cost management: broadcasts scale with team size
- Spawn backends: in-process (fastest), tmux (visible), iTerm2 (split panes)

#### 9.5 CLAUDE.md for Teams
- Defining module boundaries so agents don't edit the same files
- Team-aware instructions in project configuration
- Shared context vs. agent-specific context
- Standardized spawn prompt templates for consistency

### Mastery Check
> Can you design and run an agent team that completes a multi-component task faster and at higher quality than a single agent session?

### Official Resources
- [Orchestrate Teams of Claude Code Sessions](https://code.claude.com/docs/en/agent-teams)
- [Agent Teams Controls](https://claudefa.st/blog/guide/agents/agent-teams-controls)
- [Swarm Orchestration Skill (GitHub Gist)](https://gist.github.com/kieranklaassen/4f2aba89594a4aea4ad64d753984b2ea)

---

## Level 10: Distribution & Mastery — "Operating at Scale"
**Goal:** Integrate everything into a professional engineering practice — and distribute that practice so a whole team operates at this level, not just you.
**Mindset shift:** From "using a tool well myself" → "designing AI-augmented engineering systems and shipping them to others"

### Topics

#### 10.1 Architecture-Level Thinking
- Designing projects to be AI-friendly from the start
- Module boundaries, clear interfaces, comprehensive tests — all help AI work better
- Documentation as a first-class engineering artifact (AI reads your docs)
- The feedback loop: better project structure → better AI output → faster iteration

#### 10.2 Quality & Accountability
- Code review discipline: AI-generated code needs MORE review, not less
- Multi-model review pipelines (Claude writes → GPT reviews, or vice versa)
- Testing strategies: AI writes tests, but humans validate test quality
- The ownership principle: your name on the PR, your responsibility
- "Outputs are disposable; plans and prompts compound. Debugging at the source scales across every future task."

#### 10.3 Cost & Efficiency Engineering (Opt-In)
- **Off by default.** Cost/token coaching is not a cross-cutting theme — it lives only in the opt-in `/coach:cost` command and `knowledge/pricing/pricing-current.md`. Reach for it when a developer explicitly asks, not as a default lens on their work.
- Understanding token costs (June 2026, per million tokens, input/output): Haiku 4.5 $1/$5 · Sonnet 4.6 $3/$15 · Opus 4.8 $5/$25 · Fable 5 $10/$50
- Model routing: right model for the right task (Haiku for high-volume subagents, Opus for the orchestrating agent)
- Monitoring and budgeting AI usage across a team
- ROI measurement: time saved vs. tokens spent
- Fast Mode for interactive speed when cost is secondary

#### 10.4 The Broader Claude Ecosystem
- **Cowork** for non-coding automation (file management, research, presentations)
- **Claude in Chrome** for browser-based workflows
- **Claude in Excel/PowerPoint** for analyst-grade outputs
- **Claude in Slack** for team integration
- Combining surfaces: Claude Code for implementation, Cowork for documentation, Chrome for testing

#### 10.5 Team Adoption & Leadership
- How to introduce Claude Code to a development team
- Setting up shared configurations, skills, and agents for consistency
- **Packaging a Claude-ready setup as a plugin** — bundle your CLAUDE.md conventions, skills, agents, commands, and hooks into a single installable plugin so the whole team gets the same high-quality setup, not just you (see `knowledge/features/plugins.md`). This is the highest-leverage move at this level: you stop sharing a Claude-ready setup by word of mouth and start shipping it.
- Training patterns: pair programming with AI as the third participant
- Governance: permissions, audit trails, security policies
- The Anthropic Academy certification path as a team onboarding tool

#### 10.6 Staying Current
- Claude Code evolves rapidly — features from 3 months ago may be deprecated
- Community resources: r/ClaudeAI (450K+), awesome-claude-code, ClaudeLog
- Official resources: Anthropic Engineering blog, Claude Developer Newsletter
- Evaluating new features: experimental flags, beta capabilities

#### 10.7 Building Products with Agentic AI
- From engineering tool to product component
- The Claude Agent SDK for building user-facing agents
- Skills as portable product features across Claude surfaces
- Designing agentic features in your SaaS product
- Ethical considerations: transparency, reliability, user trust

### Mastery Check
> Can you design an end-to-end AI-augmented development workflow for a team, including tooling, quality gates, cost controls, and governance — and explain why you made each design choice?

---

## Cross-Cutting Practices (Coached at Every Level)

These five practices are the spine of the curriculum. They are coached at every level, **verification first**, and they outrank how far up the feature ladder a developer has climbed. The levels are a scaffold; these practices are the skill.

| Practice | What It Means |
|----------|---------------|
| **Verification First** | Give Claude a check it can run itself — tests, build, lint, a script, a screenshot. The #1 lever on output quality. |
| **Explore → Plan → Code** | Separate research and planning from execution. Use plan mode before writing code. |
| **Ground the Prompt** | Point at specific files, an example pattern to follow, and the concrete symptom — not "fix the bug." |
| **Course-Correct Early** | Stop and redirect on drift rather than letting it compound. `/clear` and re-prompt when needed. |
| **Manage Context** | Short CLAUDE.md, `/clear` between tasks, subagents for investigation. Context is a finite resource. |

Always-on supporting disciplines: **Accountability** (you own the output — AI assists, you decide), **Security** (AI has access to your code and tools; treat it accordingly), and **Iterative Improvement** (measure, adjust, repeat).

> **Cost/token coaching is off by default** and is *not* a cross-cutting theme. It is opt-in only, via the `/coach:cost` command and `knowledge/pricing/pricing-current.md`. Don't lead with cost; lead with verification.

---

## Suggested Learning Timeline

| Week | Levels | Focus |
|------|--------|-------|
| 1 | 0-1 | Get productive. Learn permission modes, plan mode, and the explore → plan → code → verify loop. Take Claude 101 on Anthropic Academy. |
| 2-3 | 2 | Configure project memory AND master context engineering (one level now). Read Anthropic's context engineering article. |
| 4-5 | 3-4 | Connect external context & reach via MCP (cost-aware — take the MCP course on DeepLearning.AI). Build skills using the open standard. |
| 6-7 | 5-6 | Create your first custom agent (a context-isolation tool). Add hooks (the Stop verification gate). |
| 8-9 | 7-8 | Run headless/SDK and CI workflows. Practice worktrees + dual-instance parallelism. |
| 9-10 | 9 | Earn the team: only when simpler parallelism fails, try agent teams. |
| Ongoing | 10 | Distribution: package a Claude-ready setup as a plugin; team leadership, governance, product thinking. |

---

## Notes for the Coaching Agent

This curriculum is the backbone of the coaching agent's knowledge. The agent should:

1. **Diagnose level** by scanning the environment AND observing prompt quality
2. **Never skip levels** — foundations matter. If gaps are detected, address them
3. **Teach through real work** — challenges should use the developer's actual codebase
4. **Leverage Output Styles** — recommend Explanatory for exploration, Learning for skill-building
5. **Track patterns** — note recurring mistakes and strengths in the JSONL progress log
6. **Celebrate progress** — but with substance ("Your context management improved — you cleared 3x more often")
7. **Adapt pacing** — experienced developers may skip Level 0-1 but still need Level 2 (project memory + context engineering catches everyone)
8. **Reference official sources** — point to Anthropic Academy courses, engineering blog posts, and official docs
9. **Stay current** — the ecosystem evolves monthly; curriculum should be reviewed regularly

**Coaching commands available to the developer:** `/coach:assess`, `/coach:next`, `/coach:execute`, `/coach:exercise`, `/coach:discover`, `/coach:status`, `/coach:help`, `/coach:whats-new`, and `/coach:recap` (a progress narrative of how far the developer has come) and `/coach:compare` (a before/after diff of a repo or workflow). Cost coaching is opt-in only via `/coach:cost`.

---

*This is a living document. The Claude Code ecosystem evolves rapidly. Curriculum should be reviewed monthly.*
*Last updated: June 19, 2026*
