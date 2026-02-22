<!--
topic: Cowork Overview
last_updated: February 2026
source_docs: curriculum-v1.1.md
curriculum_level: All
-->

# Cowork Overview

## Current State

**Cowork** is Anthropic's managed cloud environment for AI-assisted development. It provides the Claude Code experience without local setup, with integrated VS Code-based IDE.

## Key Features

### Cloud Development Environment

- **Instant workspace**: No local installation required
- **VS Code in browser**: Full IDE experience
- **Persistent storage**: Workspaces saved across sessions
- **Pre-configured tools**: Git, Node.js, Python, common CLI tools

### Claude Integration

- Same Claude Code capabilities as CLI
- Same commands, skills, plugins
- Same CLAUDE.md conventions
- Unified experience across local and cloud

### Plugin Compatibility

**Plugins work identically in Cowork**:
- Install via `/plugin install`
- Same command namespacing
- Same skill triggers
- Same agent invocation

**This plugin is designed for both environments**.

## When to Use Cowork

### Good Fit

| Scenario | Why Cowork |
|----------|------------|
| Quick prototyping | No setup time |
| Workshops/training | Consistent environment |
| Client demos | Clean, reproducible |
| Machine switching | Access from anywhere |
| Onboarding new devs | Skip environment setup |

### Better Local

| Scenario | Why Local |
|----------|-----------|
| Large codebases | Better performance |
| Custom toolchains | Full control |
| Offline work | No network dependency |
| Sensitive code | Data stays local |
| Heavy compute | Use local resources |

## Cowork Architecture

```
┌─────────────────────────────────────┐
│           Browser                   │
│  ┌─────────────────────────────┐   │
│  │    VS Code Web IDE          │   │
│  │  ┌───────────────────────┐  │   │
│  │  │   Claude Code Panel   │  │   │
│  │  └───────────────────────┘  │   │
│  └─────────────────────────────┘   │
└────────────────┬────────────────────┘
                 │
┌────────────────▼────────────────────┐
│        Cowork Cloud                 │
│  ┌─────────────┐ ┌──────────────┐  │
│  │  Workspace  │ │ Claude API   │  │
│  │  Container  │ │  Connection  │  │
│  └─────────────┘ └──────────────┘  │
└─────────────────────────────────────┘
```

### Workspace Persistence

- Files saved to cloud storage
- Git integration for version control
- Export/import workspaces

### Limitations

- **Compute**: Shared resources, not for heavy builds
- **Network**: Requires internet connection
- **Storage**: Workspace size limits
- **Custom tools**: Limited to pre-installed software

## Getting Started

### Access Cowork

1. Visit [cowork.claude.ai](https://cowork.claude.ai)
2. Sign in with Anthropic account
3. Create or open workspace

### Install Plugins

```
/plugin marketplace list
/plugin install coach@agentic-ai-mastery
```

### Configure CLAUDE.md

Same conventions as local:
```markdown
# Project Name

## Purpose
Brief description

## Conventions
...
```

## Plugin Development for Cowork

### Compatibility Checklist

- [ ] No local filesystem dependencies outside workspace
- [ ] No shell scripts requiring local tools
- [ ] All paths relative to workspace
- [ ] State writes to `~/.claude/` (available in Cowork)

### Testing in Both Environments

1. Develop locally with Claude Code CLI
2. Test in Cowork before publishing
3. Verify commands work identically

## Cowork + Teams

### Shared Workspaces

- Team workspaces for collaboration
- Shared plugin configurations
- Consistent environments

### Use Cases

- Pair programming with Claude
- Training sessions
- Code reviews

## Cost Considerations

**Cowork pricing**:
- Included with Claude Pro/Team subscriptions
- API usage billed separately

**Same Claude API costs** whether local or Cowork.

## Mastery Checks

- [ ] Have you tried Cowork for quick prototyping?
- [ ] Do your plugins work in both environments?
- [ ] Do you know when to use local vs. Cowork?

## Official Resources

- [Cowork Documentation](https://cowork.claude.ai/docs)
- [Getting Started Guide](https://cowork.claude.ai/docs/getting-started)
