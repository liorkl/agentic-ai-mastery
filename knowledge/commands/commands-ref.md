<!--
topic: Slash Commands Reference
last_updated: February 2026
source_docs: curriculum-v1.1.md
curriculum_level: All
-->

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
| `/undo` | Revert last file change | Works on Write/Edit operations |
| `/resume` | Continue previous session | Restores from session storage |

### Context Control

| Command | Purpose | Notes |
|---------|---------|-------|
| `/context` | Show context usage breakdown | See what's consuming tokens |
| `/memory` | Manage persistent facts | Add/remove cross-session memory |
| `/config` | View/edit settings | Model, permissions, preferences |

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

## Cost Implications

**Commands themselves are free** — they're client-side operations.

**Commands that trigger Claude responses**:
- `/commit` — generates commit message (cheap)
- `/pr` — generates PR description (moderate)
- `/review` — full code analysis (varies with diff size)

**Context-saving commands**:
- `/clear` — immediately frees context
- `/compact` — preserves key info, frees ~60-80%

**Use `/context` regularly** to understand where tokens go.

## Mastery Checks

- [ ] Do you use `/clear` between unrelated tasks?
- [ ] Do you use `/compact` when context fills?
- [ ] Have you checked `/context` to understand token usage?
- [ ] Do you know which commands trigger LLM responses?

## Official Resources

- [Claude Code Commands Reference](https://code.claude.com/docs/en/cli/commands)
- [IDE Integration Guides](https://code.claude.com/docs/en/ide/)
