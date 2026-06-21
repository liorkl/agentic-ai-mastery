<!-- file: knowledge/features/mcp.md -->
<!-- last-updated: 2026-06-21 -->
<!-- source: https://code.claude.com/docs/en/best-practices -->
<!-- curriculum_level: L6 -->

# MCP Integration

## Current State

Model Context Protocol (MCP) is an **open standard** for connecting AI to external services. MCP servers expose tools that Claude can invoke.

## Key Concepts

### Adding MCP Servers

```bash
# Add a server
claude mcp add <name> -- <command>

# Example: Add GitHub server
claude mcp add github -- npx @modelcontextprotocol/server-github

# Example: Add database server
claude mcp add postgres -- npx @modelcontextprotocol/server-postgres
```

### Configuration Locations

MCP servers are configured in:
- `.mcp.json` (project-level)
- `.claude/settings.local.json`
- `~/.claude.json` (user-level)

Example `.mcp.json`:
```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-github"]
    },
    "postgres": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-postgres"],
      "env": {
        "DATABASE_URL": "${DATABASE_URL}"
      }
    }
  }
}
```

### Essential MCP Servers

| Server | Purpose | Value |
|--------|---------|-------|
| **Context7 / docs fetcher** | Up-to-date library docs | Prevents hallucinated APIs |
| **Browser automation** (Puppeteer, Playwright) | UI testing | Claude sees console logs |
| **Chrome DevTools** | Inspect DOM, network | Debug real browser |
| **Sentry** | Error tracking | Diagnose production errors |
| **PostgreSQL / SQLite** | Database access | Query and analyze data |
| **GitHub** | Issues, PRs, repos | Manage development workflow |
| **Excalidraw** | Diagrams | Generate architecture visuals |

### Tool Search (Late 2025)

When MCP tools exceed 10% of your context window, Tool Search activates:
- Dynamically loads only relevant MCP tools
- Critical for users with many servers configured
- Can be disabled if you prefer upfront loading

```json
{
  "toolSearch": {
    "enabled": true
  }
}
```

### Context Cost & Progressive Disclosure

**MCP tool definitions load into the context window at session start.** Every connected server carries a standing context cost before you've issued a single prompt — so more servers is not better. Prune servers a task doesn't need; treat MCP's context footprint as a first-class design concern (this ties directly to the "manage context" cross-cutting practice).

Anthropic's [Code execution with MCP](https://www.anthropic.com/engineering/code-execution-with-mcp) (Nov 2025) showed that naively loading all tool definitions upfront is an anti-pattern. Presenting MCP servers as code APIs the agent calls — with **progressive disclosure** of tool definitions, loaded only when needed — cut a real workflow from ~150,000 to ~2,000 tokens (~98.7% reduction).

**Practical guidance**:
- Connect only the servers the current task needs
- For tool-heavy workflows, prefer progressive disclosure / code-execution patterns over upfront loading of every definition
- Use `/context` to see what's actually loaded, and prune

### Building Custom MCP Servers

**When to build vs. use existing**:
- Build: Proprietary internal tools, specific workflow needs
- Use existing: Standard integrations (GitHub, databases, etc.)

**Frameworks**:
- **FastMCP** (Python) — Quick development
- **MCP SDK** (TypeScript) — Full control

**Design principles**:
- Clear tool names that Claude will understand
- Minimal overlap between tools
- Good descriptions for auto-selection

### Security Considerations

MCP servers have access to:
- Whatever credentials you provide
- Network resources
- Local filesystem (if configured)

**Before adding a server**:
- Review what access it needs
- Check the source code if open source
- Use environment variables for secrets

### Vetting & Trust

MCP servers are **third-party code and integrations** — adding one is a supply-chain decision. Don't connect a server you don't trust: a server you rely on can be updated to behave maliciously ("rug-pull" risk).

- Sandbox or scope untrusted servers before giving them real access
- Use server scopes (local / project / user) deliberately — grant the narrowest scope that works
- For sandboxing and deny-rule mechanics, see [`permissions.md`](permissions.md) — that file owns the details; don't duplicate them here

## Mastery Checks

- [ ] Have you added at least one MCP server?
- [ ] Do you understand what access each server has?
- [ ] Have you enabled Tool Search if you have 5+ servers?
- [ ] Can you evaluate whether a new server adds real value?

## Why It Matters

**Each MCP server injects its tool definitions into the system prompt.** More tools is not better — a crowded toolset makes Claude's selection less reliable, because near-duplicate or rarely-used tools muddy which one fits the task.

**Fewer, well-chosen servers mean sharper tool use**:
- Clear, non-overlapping tool names and good descriptions drive correct auto-selection
- Tool Search dynamically surfaces only the relevant tools when your set grows large, keeping the active choices focused
- Curate to the servers you actually use — most developers who install 10+ rely on only 3-4 daily

> "Went overboard with 15 MCP servers — ended up using only 4 daily."

**Check what's loaded** with `/context` and prune servers that add tools without adding value.

(For the token/cost angle, use the opt-in `/coach:cost` command.)

## Official Resources

- [MCP Protocol Specification](https://modelcontextprotocol.io)
- [DeepLearning.AI: MCP course](https://www.deeplearning.ai/short-courses/mcp-build-rich-context-ai-apps-with-anthropic/) (free)
- [Anthropic Academy: MCP Getting Started + Advanced](https://anthropic.skilljar.com/introduction-to-model-context-protocol) (free, 2 courses)
