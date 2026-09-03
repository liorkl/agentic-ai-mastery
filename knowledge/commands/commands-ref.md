<!-- file: knowledge/commands/commands-ref.md -->
<!-- last-updated: 2026-09-03 -->
<!-- source: https://code.claude.com/docs/en/commands -->
<!-- curriculum_level: All -->

# Slash Commands Reference

## Current State

Claude Code ships built-in slash commands for session management, context control, and configuration — plus **bundled skills** that are also invoked with a slash (`/code-review`, `/debug`, `/doctor`). Anything you add yourself (a project skill, a plugin) appears in the same `/` menu.

`/help` is the source of truth for your install. The tables below cover the commands worth knowing by heart.

## Essential Commands

### Session Management

| Command | Purpose | Notes |
|---------|---------|-------|
| `/help` | Show help and available commands | Lists built-ins, bundled skills, and your own |
| `/clear` | Start a new conversation with empty context | Aliases: `/reset`, `/new` |
| `/compact` | Free up context by summarizing the conversation | Takes optional instructions |
| `/rewind` | Roll back code and/or conversation to a checkpoint | The real "undo" |
| `/resume` | Return to an earlier conversation | Pick from saved history |
| `/export` | Export the conversation as plain text | Optional filename |

### Context & Configuration

| Command | Purpose | Notes |
|---------|---------|-------|
| `/context` | Visualize context usage as a colored grid | `all` shows everything |
| `/memory` | Edit CLAUDE.md files and manage auto memory | Both memory systems |
| `/config` | Open settings — theme, model, output style, preferences | Alias: `/settings` |
| `/permissions` | Manage allow / ask / deny rules | Alias: `/allowed-tools` |
| `/mcp` | Manage MCP server connections | Interactive list; text summary under `-p` |
| `/autocompact` | Set the auto-compact window | `auto` or a token count |

### Model & Effort

| Command | Purpose | Notes |
|---------|---------|-------|
| `/model` | Switch model and save as default | |
| `/effort` | Set effort level, or check status | `low`–`max`, or `auto` |
| `/fast` | Toggle fast mode | Same model, faster output |

### Quality & Workflow (bundled skills)

| Command | Purpose | Notes |
|---------|---------|-------|
| `/code-review` | Review the current diff or a PR for bugs and cleanups | **Alias: `/review`.** Takes an effort level, `--fix`, `--comment`, or a PR/branch/path |
| `/debug` | Enable debug logging and troubleshoot | |
| `/doctor` | Setup checkup that diagnoses issues and can fix them | Alias: `/checkup`. Also proposes CLAUDE.md trims |
| `/init` | Initialize the project with a CLAUDE.md guide | Suggests improvements if one exists |
| `/plan` | Enter plan mode from the prompt | Plan mode is also a permission mode (Shift+Tab) |
| `/goal` | Set a goal for Claude to work towards | Persists across turns |
| `/loop` | Run a prompt repeatedly while the session stays open | Alias: `/proactive` |

### Agents, Tasks & Plugins

| Command | Purpose | Notes |
|---------|---------|-------|
| `/agents` | Reminder on creating/managing subagents | No longer an interactive editor — edit `.claude/agents/` directly |
| `/list-agents` | List subagents and sessions Claude can message | Alias: `/peers` |
| `/tasks` | List background work | |
| `/plugin` | Manage plugins | `/plugin install`, `/plugin list`, … |
| `/background` | Detach the session to run as a background agent | Alias: `/bg` |
| `/fork` | Copy the conversation into a new background session | |

### Diagnostics

| Command | Purpose | Notes |
|---------|---------|-------|
| `/hooks` | View hook configurations for tool events | Fastest way to check a hook registered |
| `/usage` | Show token usage | Alias: `/cost` |
| `/status` | Show session status | Account, model, connectivity — *not* context usage |
| `/insights` | HTML report analyzing recent sessions | |

## Commands That Do Not Exist

These get invented constantly — by people and by models. None of them are Claude Code commands:

| Not real | What to use instead |
|----------|--------------------|
| `/commit`, `/pr` | Ask Claude in plain language, or install a plugin that adds them |
| `/test` | Ask Claude to run the suite, or enforce it with a `Stop` hook |
| `/review` as its own thing | It's an **alias for `/code-review`** — same command |
| `/undo` | `/rewind` |
| `/agent <name>` | Mention the agent — `@"reviewer (agent)"` — or let Claude delegate |
| `/skills` | `/help` lists skills; `/skill-doctor` reports on usage |
| `/output-style`, `/statusline` | `/config` (output style); the `statusLine` setting |
| `/team` | Agent teams are gated by `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` |
| `/inline`, `/explain`, `/fix`, `/refactor` | Not commands in any IDE integration — just ask |
| `/mcp list` | `/mcp` (in-session) or `claude mcp list` (shell) |

**Why this matters more than it looks**: a command that doesn't exist fails silently into "unknown command" — but a *documented* command that doesn't exist wastes real time and teaches the wrong mental model. When in doubt, check `/help` rather than trusting a reference (including this one).

## Command Patterns

### Context-Efficient Usage

**Before a complex task** — `/clear`. Start fresh to maximize available context.

**Mid-session cleanup** — `/compact`. Summarize the conversation, keep working.

**Check context health** — `/context`. See the breakdown of what's consuming the window.

### Entering Plan Mode

Plan mode is a permission mode — Claude researches and proposes a plan but makes no edits until you approve. Enter it with `/plan`, or cycle permission modes with **Shift+Tab** until the prompt shows plan mode. See the [interactive-mode docs](https://code.claude.com/docs/en/interactive-mode) for the full mode list.

## Custom Commands

You add commands three ways:

- **Skills** — `.claude/skills/<name>/SKILL.md` creates `/<name>`. Claude can also invoke them automatically unless you set `disable-model-invocation: true`.
- **Command files** — `.claude/commands/<name>.md` creates `/<name>` too. Custom commands were **merged into skills**: both forms work identically, and skills add a directory for supporting files plus frontmatter control over who invokes them.
- **Plugins** — namespaced as `/plugin-name:command`.

## Why It Matters

**Most commands are client-side** — `/clear`, `/compact`, `/context`, `/help` act on the session directly without invoking Claude. They cost nothing.

**Bundled skills do drive real work** — `/code-review` runs a multi-pass analysis; `/doctor` inspects and repairs your setup. These consume tokens like any other turn.

**Context-management commands keep answers sharp**:
- `/clear` resets the window so a new task starts focused
- `/compact` distills the conversation to its key decisions and current state
- `/context` shows what's consuming the window so you can prune

## Mastery Checks

- [ ] Do you use `/clear` between unrelated tasks?
- [ ] Do you use `/compact` when context fills?
- [ ] Have you checked `/context` to understand token usage?
- [ ] Do you know which commands trigger LLM responses and which are free?
- [ ] Do you reach for `/rewind` instead of hunting for an undo?

## Official Resources

- [Claude Code commands reference](https://code.claude.com/docs/en/commands)
- [Interactive mode](https://code.claude.com/docs/en/interactive-mode)
