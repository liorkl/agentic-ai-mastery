<!-- file: knowledge/commands/commands-ref.md -->
<!-- last-updated: 2026-06-21 -->
<!-- source: https://code.claude.com/docs/en/best-practices -->
<!-- curriculum_level: All -->

# Slash Commands Reference

## Current State

Claude Code provides built-in slash commands for session management, context control, and workflow optimization. These are available in both CLI and IDE integrations.

## Essential Commands

### Session Management

| Command | Purpose | Notes |
|---------|---------|-------|
| `/help` | Show available commands | Lists built-ins + installed skills |
| `/clear` | Reset context window | Keeps CLAUDE.md, loses conversation |
| `/compact` | Summarize and continue | Preserves key context, frees space |
| `/rewind` | Roll back conversation and/or code | Restore an earlier checkpoint of the session |
| `/resume` | Continue a previous session | Pick from saved session history |

### Context Control

| Command | Purpose | Notes |
|---------|---------|-------|
| `/context` | Show context usage breakdown | See what's consuming tokens |
| `/memory` | Manage persistent facts | Add/remove cross-session memory |
| `/config` | View/edit settings | Model, permissions, preferences |
| `/permissions` | View/edit tool permission rules | Allow/deny rules; add/move scope |
| `/mcp` | Manage MCP servers | List, authenticate, inspect tools |

### Development Workflow

| Command | Purpose | Notes |
|---------|---------|-------|
| `/commit` | Commit staged changes | Generates conventional commit message |
| `/pr` | Create pull request | Generates title, description from changes |
| `/review` | Review code changes | Analyzes diff for issues |
| `/test` | Run tests | Executes test suite, analyzes failures |

### Agent & Team Commands

| Command | Purpose | Notes |
|---------|---------|-------|
| `/agent <name>` | Invoke specific agent | Uses agent from .claude/agents/ |
| `/agents` | List available agents | Shows built-in + custom agents |
| `/tasks` | Manage task list | View/update structured tasks |
| `/team` | Team management (L9) | Create, monitor, message teammates |

### Plugin Commands

| Command | Purpose | Notes |
|---------|---------|-------|
| `/plugin list` | Show installed plugins | Lists active plugin commands |
| `/plugin install` | Install from marketplace | `plugin install <name>@<source>` |
| `/skill <name>` | Run skill manually | Forces skill activation |
| `/skills` | List available skills | Shows auto-trigger conditions |

## Command Patterns

### Context-Efficient Usage

**Before complex task**:
```
/clear
```
Start fresh to maximize available context.

**Mid-session cleanup**:
```
/compact
```
Summarize conversation, keep working.

**Check context health**:
```
/context
```
See breakdown of context usage.

### Workflow Integration

**After implementing feature**:
```
/test
/commit
/pr
```
Test → commit → create PR.

**Code review flow**:
```
/review
```
Analyzes staged or specified changes.

### Entering Plan Mode

Plan mode is a permission mode (Claude researches and proposes a plan but makes no edits until you approve), not a slash command. Cycle permission modes with **Shift+Tab** until the prompt shows plan mode. See the [interactive-mode docs](https://code.claude.com/docs/en/interactive-mode) for the exact keys and the full mode list.

## IDE-Specific Commands

### VS Code Integration

- Commands available via Command Palette
- `/inline` for inline code suggestions
- `/explain` for code explanations
- `/fix` for quick fixes

### JetBrains Integration

- Tool window commands
- Context menu integration
- `/refactor` command

## Custom Commands

Commands can be added via:
- Skills (auto-triggered)
- Plugins (namespaced like `/plugin-name:command`)
- CLAUDE.md (document workflows for manual reference)

## Why It Matters

**Most commands are client-side** — `/clear`, `/compact`, `/context`, `/help` act on the session directly without invoking Claude.

**Some commands drive Claude to produce work**:
- `/commit` — generates a commit message from staged changes
- `/pr` — drafts a PR title and description
- `/review` — runs a full code analysis over the diff

**Context-management commands keep answers sharp**:
- `/clear` resets the window so a new task starts focused
- `/compact` distills the conversation to its key decisions and current state
- `/context` shows what's consuming the window so you can prune

(For the token/cost angle, use the opt-in `/coach:cost` command.)

## Mastery Checks

- [ ] Do you use `/clear` between unrelated tasks?
- [ ] Do you use `/compact` when context fills?
- [ ] Have you checked `/context` to understand token usage?
- [ ] Do you know which commands trigger LLM responses?

## Official Resources

- [Claude Code Commands Reference](https://code.claude.com/docs/en/cli/commands)
- [IDE Integration Guides](https://code.claude.com/docs/en/ide/)
