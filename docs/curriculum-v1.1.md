# Claude Code Mastery Curriculum
## The Path to Agentic AI Development Mastery

**Version:** 1.1 — February 2026
**Purpose:** Foundation curriculum for the Claude Code Coaching Agent
**Last reviewed:** February 20, 2026

---

## Curriculum Philosophy

Mastery is not about memorizing commands. It's about developing **engineering judgment** for when and how to delegate work to AI agents. Each level builds a mental model, not just a skill set.

**Progression principle:** At each level, the developer should be able to _explain why_ they do things a certain way — not just _how_. This is what separates a power user from someone following a tutorial.

**Key terminology shift (Sep 2025):** Anthropic formally introduced **context engineering** as the successor to prompt engineering. The curriculum reflects this — prompting is Level 1, but context engineering is a discipline that pervades Levels 2-10. As Anthropic defines it: "the set of strategies for curating and maintaining the optimal set of tokens during LLM inference."

---

## Level 0: Foundations — "First Contact"
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

#### 0.4 The Safety Model
- Permission modes: default, `--allowlist`, `--dangerously-skip-permissions`
- Understanding what Claude asks permission for and why
- Reading permission prompts carefully — not just hitting "yes"
- Sandboxing basics for safe experimentation (`/sandbox`)
- Permission wildcards: `Bash(npm run *)`, `Edit(/docs/**)`

#### 0.5 Model Selection Basics
- **Opus 4.6** — Most advanced, complex reasoning, 1M context, agent teams
- **Sonnet 4.5** — Best coding model, preferred 70% over previous version, fast
- **Haiku 4.5** — 90% of Sonnet's agentic performance at 2x speed and 3x cost savings
- When each model is appropriate (cost vs. capability tradeoff)
- Switching models: `--model` flag

#### 0.6 When NOT to Use Claude Code
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

## Level 1: Effective Prompting — "Speaking the Language"
**Goal:** Learn to communicate intent clearly and get reliable results.
**Mindset shift:** From "type and hope" → "precise delegation with success criteria"

### Topics

#### 1.1 Anatomy of a Good Prompt
- Specificity: what, where, how, and constraints
- Including success criteria ("the tests should pass", "match the existing code style")
- Providing examples of desired output
- Negative constraints: what NOT to do
- Using XML tags for structure (Anthropic's recommended practice)

#### 1.2 Context is Everything
- Why Claude's output quality depends on what it knows
- Pointing Claude to relevant files explicitly
- Using `@path` references to pull in specific context
- The difference between "fix the bug" and "fix the null check in src/auth/validate.ts line 42"

#### 1.3 Iterative Prompting
- Breaking large tasks into steps
- Reviewing output before asking for the next step
- Correcting course: "That's not what I meant — instead, do X"
- When to `/clear` and start fresh vs. continuing the conversation

#### 1.4 Plan Before Execute (Plan Mode)
- Activating Plan Mode (`Shift+Tab` twice)
- Why "plan first, code second" produces better results
- Reviewing and approving plans before execution
- The spec-based workflow: write spec → have Claude interview you via AskUserQuestionTool → execute spec in new session

#### 1.5 Output Styles (Feb 2026)
- **Default** — Concise task completion, minimal explanation
- **Explanatory** — Educational "Insights" blocks explaining implementation choices and patterns
- **Learning** — Collaborative mode with `TODO(human)` markers for hands-on practice
- **Custom output styles** — Creating your own via `/output-style:new`
- When to use each: Explanatory for new codebases, Learning for skill-building
- Relevance to coaching: the Learning output style IS a coaching interface

#### 1.6 Extended & Adaptive Thinking (Claude 4.x)
- Extended thinking: asking Claude to reason before answering
- Adaptive thinking: Claude adjusts reasoning depth based on task complexity
- When extended thinking adds value vs. when it wastes tokens
- Vision optimization for image-based tasks

### Mastery Check
> Given a feature request, can you write a prompt that produces correct code on the first try 80%+ of the time — and choose the appropriate output style for your current needs?

### Official Resources
- [Prompt Engineering Guide](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/overview)
- [Claude 4.x Prompting Best Practices](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/claude-4-best-practices)
- [Interactive Prompt Engineering Tutorial (9 chapters)](https://github.com/anthropics/prompt-eng-interactive-tutorial)

---

## Level 2: Project Configuration — "Teaching Claude About Your Project"
**Goal:** Set up persistent context so Claude understands your project deeply.
**Mindset shift:** From "one-off prompts" → "a configured development environment"

### Topics

#### 2.1 CLAUDE.md — Your Project's Brain
- What CLAUDE.md is and when Claude reads it (loaded into system prompt at startup)
- Five essential sections: project description, build commands, code style, architecture, testing
- What NOT to include: don't exceed ~150 lines; keep it focused
- Multiple CLAUDE.md files: root-level + subdirectory-specific (e.g., `/frontend/CLAUDE.md`)
- Priority hierarchy: module-level > project-level > user-level (~/.claude/CLAUDE.md)
- AGENTS.md symlink for cross-tool compatibility (Copilot, Cursor)
- `/init` generates a starter; treat it as a starting point, not the final version
- Using `@imports` to pull in other files modularly

#### 2.2 Memory System
- How Claude Code's memory works across sessions
- `/memory` command for checking and editing
- Auto-memory: Claude builds context automatically
- CLAUDE.local.md for personal preferences (git-ignored)
- The 200-line entrypoint limit and why it matters
- Strategic use of memory for persistent preferences

#### 2.3 Rules Files
- `.claude/rules/*.md` — modular topic-specific instructions
- Path-scoped rules via frontmatter (apply only to certain directories)
- When rules are better than CLAUDE.md entries (separation of concerns)

#### 2.4 Settings & Configuration
- `settings.json` hierarchy: managed → project shared → project local → user
- Permission wildcards (e.g., `Bash(npm run *)`, `Edit(/docs/**)`)
- Deny rules for sensitive files (`.env*`, `~/.aws/**`)
- Model selection per context
- Output style persistence per project (`.claude/settings.local.json`)
- Environment variables: `CLAUDE_ENV_FILE`, `CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR`

### Mastery Check
> Can you set up a project from scratch so that a _new team member_ using Claude Code would get high-quality results immediately, without any verbal instructions from you?

### Official Resources
- [Using CLAUDE.md Files (Anthropic Blog)](https://claude.com/blog/using-claude-md-files)
- [Claude Code Settings Reference](https://code.claude.com/docs/en/settings)
- [Manage Claude's Memory](https://code.claude.com/docs/en/memory)

---

## Level 3: Context Engineering — "The Most Critical Discipline"
**Goal:** Master the #1 constraint in agentic development: the context window.
**Mindset shift:** From "infinite conversation" → "context is a finite resource with diminishing returns that I actively engineer"

**Why this level matters most:** Anthropic's own research shows that LLM performance degrades as context fills — a phenomenon called **context rot**. Every token introduced depletes an "attention budget." This level teaches you to think in context — considering the holistic state available to the LLM at any given time.

### Topics

#### 3.1 Understanding the Context Window
- What goes into context: system prompt, CLAUDE.md, messages, file reads, tool results, MCP tool definitions
- How context fills up (it happens faster than you think)
- The n² attention problem: every token attends to every other token
- Performance degradation past ~50% context fill: forgetting instructions, increased errors
- Monitoring context usage with custom status line

#### 3.2 Context Hygiene
- `/clear` — when and why to use it aggressively
- `/compact` — automatic summarization when approaching limits (Anthropic's built-in compaction)
- Starting new sessions for new tasks (not continuing indefinitely)
- The "context rot" problem: why AI gets worse the longer you chat
- `/resume` to restart conversations with prior context

#### 3.3 Strategic Context Loading
- **Just-in-time retrieval** vs. upfront loading (Anthropic's recommended approach)
- Maintaining lightweight identifiers (file paths, stored queries, links) over full file contents
- Using the Explore subagent for read-only codebase discovery
- Progressive disclosure: loading information only when the task requires it
- The metadata advantage: folder hierarchies and naming conventions as implicit signals

#### 3.4 Token-Efficient Workflows
- Commit-and-clear pattern: complete a unit of work, commit, clear, move on
- Using scratchpads and intermediate files to persist state between sessions
- Reducing verbose tool outputs (e.g., trimming test output, filtering logs)
- Recognizing when context is degraded: signs and recovery strategies
- Tool Search feature: dynamic MCP tool loading when tools exceed 10% of context

#### 3.5 The Right Altitude (Anthropic's Framework)
- System prompts should be neither too specific (brittle) nor too vague (unguided)
- The "Goldilocks zone" for instructions: specific enough to guide, flexible enough for heuristics
- Minimal viable context: the smallest set of high-signal tokens for the desired outcome
- Testing: start with minimal prompt on best model, then add based on failure modes

### Mastery Check
> Can you complete a complex multi-file feature implementation without context degradation, and explain your context strategy to another developer?

### Official Resources
- [Context Engineering for AI Agents (Anthropic Engineering)](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)
- [Claude Code Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices)
- [Effective Harnesses for Long-Running Agents](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)

---

## Level 4: Skills & Slash Commands — "Reusable Workflows"
**Goal:** Stop repeating yourself. Encode proven workflows using the Agent Skills open standard.
**Mindset shift:** From "ad-hoc instructions each time" → "workflow engineering with progressive disclosure"

### Topics

#### 4.1 Slash Commands (Legacy, Still Supported)
- What they are: prompt templates stored as `.claude/commands/*.md`
- Creating project-level vs. user-level commands
- Parameterized commands with `$ARGUMENTS`
- Frontmatter for allowed tools and descriptions
- Note: Skills are now recommended over commands for new work

#### 4.2 Agent Skills — The Open Standard (Dec 2025)
- `.claude/skills/` — the current best practice
- Skills as an **open standard**: portable across Claude.ai, Claude Code, Cowork, and the API
- Anatomy of a SKILL.md: name + description in frontmatter (scanned at startup), body loaded on demand
- Supporting files: scripts, resources, reference docs bundled in the skill folder
- Partner skills: Atlassian, Canva, Figma, Notion, Cloudflare, Stripe, Zapier
- Built-in skills: PDF, DOCX, XLSX, PPTX (power Claude.ai's file creation)

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

## Level 5: Custom Agents — "Specialized Team Members"
**Goal:** Create focused AI agents that handle specific types of work.
**Mindset shift:** From "one general assistant" → "a team of specialists I designed"

### Topics

#### 5.1 What Custom Agents Are
- Markdown files with YAML frontmatter in `.claude/agents/`
- Own context window, system prompt, tool access, permissions, model, and visual color
- **Automatic delegation**: Claude routes tasks based on description — like tool invocation
- Project-level vs. user-level agents (`~/.claude/agents/`)

#### 5.2 Agent Design Principles
- One agent, one job (code reviewer ≠ code writer ≠ test writer)
- Constraining tool access (read-only agents can't use Write, Edit, NotebookEdit)
- Model selection per agent (Haiku 4.5 for fast/cheap — 90% of Sonnet's performance at 3x savings)
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

### Topics

#### 6.1 What Hooks Are
- Scripts that run on specific lifecycle events, _outside_ the agentic loop
- Not AI — deterministic code (shell scripts, Python) that enforces rules
- The critical distinction: hooks are reliable because they don't involve LLM judgment
- Hooks are typically under 100 lines, with clear comments

#### 6.2 Hook Events
- `PreToolUse` — before Claude uses a tool (intercept, modify, block)
- `PostToolUse` — after Claude uses a tool (validate, log, alert)
- `Stop` — when Claude finishes responding (enforce quality checks)
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

## Level 7: MCP Integration — "Extending Claude's Reach"
**Goal:** Connect Claude Code to external tools and data sources via the Model Context Protocol.
**Mindset shift:** From "Claude works with my files" → "Claude works with my entire toolchain"

### Topics

#### 7.1 What MCP Is
- Model Context Protocol: an **open standard** for connecting AI to external services
- MCP servers expose tools that Claude can invoke
- Adding MCP servers: `claude mcp add <name> -- <command>`
- MCP configuration locations: `.mcp.json` (project), `.claude/settings.local.json`, `~/.claude.json`

#### 7.2 Essential MCP Servers
- **Context7 / docs fetcher** — Up-to-date library docs, prevents hallucinated APIs
- **Browser automation** (Puppeteer, Playwright) — Claude tests your UI, sees console logs
- **Chrome DevTools** — Claude inspects DOM, network, console in your real browser
- **Error tracking** (Sentry) — Claude diagnoses production errors
- **Database access** (PostgreSQL, SQLite) — Claude queries and analyzes data
- **GitHub** — Claude manages issues, PRs, repos
- **Excalidraw** — Claude generates architecture diagrams

#### 7.3 Tool Search — Dynamic Tool Loading (Late 2025)
- When MCP tools exceed 10% of your context window, Tool Search activates
- Dynamically loads only relevant MCP tools instead of all at once
- Critical for users with many MCP servers configured
- Can be disabled if you prefer upfront loading (increases context usage)

#### 7.4 When MCP is Worth the Complexity
- Don't add servers you won't use regularly
- Community wisdom: "Went overboard with 15 MCP servers — ended up using only 4 daily."
- Evaluating MCP server quality, reliability, and maintenance
- Security considerations: what access are you granting?

#### 7.5 Building Custom MCP Servers
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

## Level 8: Headless, CI/CD & Long-Running Agents — "Claude in Your Pipeline"
**Goal:** Run Claude Code programmatically and across multiple context windows.
**Mindset shift:** From "interactive assistant" → "programmable component in my engineering system"

### Topics

#### 8.1 Headless Mode
- `claude -p "prompt"` — non-interactive execution
- Output formats: plain text, JSON (`--output-format json`), streaming JSON
- Use cases: pre-commit hooks, CI checks, automated code review, documentation generation

#### 8.2 CI/CD Integration Patterns
- PR review bot: Claude reviews every pull request
- Automated test generation on new files
- Documentation sync: regenerate docs when code changes
- Release notes generation from commit history
- Cost management for automated usage

#### 8.3 The Harness Pattern for Long-Running Agents (Nov 2025)
- **The problem:** Complex projects can't be completed in one context window
- **Initializer agent:** First session sets up environment — init.sh, feature list, progress file, initial git commit
- **Coding agent:** Every subsequent session makes incremental progress, then leaves structured updates
- **Progress file** (`claude-progress.txt`): log of what agents have done, readable by next session
- **Feature list in JSON** (not Markdown — less likely to be improperly modified): tracks pass/fail per feature
- **Incremental progress:** One feature at a time, commit with descriptive messages
- **Clean state principle:** Every session ends in a merge-ready state
- This pattern bridges the gap between context windows like shift handoffs between engineers

#### 8.4 The Claude Agent SDK (Sep 2025)
- Renamed from Claude Code SDK — now a general agent platform
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

## Level 9: Agent Teams — "Multi-Agent Orchestration"
**Goal:** Coordinate multiple Claude instances working in parallel.
**Mindset shift:** From "one agent, one task" → "orchestrating a team of autonomous agents"

### Topics

#### 9.1 When to Use Agent Teams
- Tasks that benefit from parallel independent work
- The cost-benefit analysis: teams consume more tokens but finish faster
- Not everything needs a team — solo agents are often better
- **Experimental status:** Requires `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` in settings
- Fast Mode: 2.5x speed on Opus 4.6 responses for interactive team work

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

## Level 10: Mastery — "Engineering with AI Agents"
**Goal:** Integrate everything into a professional engineering practice.
**Mindset shift:** From "using a tool" → "designing AI-augmented engineering systems"

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

#### 10.3 Cost & Efficiency Engineering
- Understanding token costs: Haiku 4.5 ($1/$5) vs. Sonnet 4.5 ($3/$15) vs. Opus
- Model routing: right model for the right task (Haiku for subagents, Opus for orchestration)
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

## Cross-Cutting Themes (Woven Into Every Level)

| Theme | What It Means |
|-------|---------------|
| **Context Engineering** | Not just prompting — curating the optimal set of tokens across all context components |
| **Accountability** | You own the output. AI assists, you decide. |
| **Progressive Disclosure** | Load information only when needed — applies to skills, context, and learning itself |
| **Quality Gates** | Trust but verify. Automate verification where possible. |
| **Cost Consciousness** | Tokens cost money. Choose the right model for each task. |
| **Security Discipline** | AI has access to your code and tools. Treat it accordingly. |
| **Iterative Improvement** | Every workflow can be improved. Measure, adjust, repeat. |

---

## Suggested Learning Timeline

| Week | Levels | Focus |
|------|--------|-------|
| 1 | 0-1 | Get productive. Start using Claude Code daily. Take Claude 101 on Anthropic Academy. |
| 2-3 | 2-3 | Configure your project. Master context engineering. Read Anthropic's context engineering article. |
| 4-5 | 4-5 | Build skills using the open standard. Create your first custom agent. |
| 6-7 | 6-7 | Add hooks and MCP integrations. Take the MCP course on DeepLearning.AI. |
| 8-10 | 8-9 | Implement the harness pattern for long-running work. Try agent teams. |
| Ongoing | 10 | System design, team leadership, product thinking. |

---

## Notes for the Coaching Agent

This curriculum is the backbone of the coaching agent's knowledge. The agent should:

1. **Diagnose level** by scanning the environment AND observing prompt quality
2. **Never skip levels** — foundations matter. If gaps are detected, address them
3. **Teach through real work** — challenges should use the developer's actual codebase
4. **Leverage Output Styles** — recommend Explanatory for exploration, Learning for skill-building
5. **Track patterns** — note recurring mistakes and strengths in the JSONL progress log
6. **Celebrate progress** — but with substance ("Your context management improved — you cleared 3x more often")
7. **Adapt pacing** — experienced developers may skip Level 0-1 but still need Level 3 (context engineering catches everyone)
8. **Reference official sources** — point to Anthropic Academy courses, engineering blog posts, and official docs
9. **Stay current** — the ecosystem evolves monthly; curriculum should be reviewed regularly

---

*This is a living document. The Claude Code ecosystem evolves rapidly. Curriculum should be reviewed monthly.*
*Last updated: February 20, 2026*
