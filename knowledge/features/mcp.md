<!--
topic: MCP Integration
last_updated: February 2026
source_docs: curriculum-v1.1.md, cost-guide-v1.0.md
curriculum_level: L7
-->

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

## Mastery Checks

- [ ] Have you added at least one MCP server?
- [ ] Do you understand what access each server has?
- [ ] Have you enabled Tool Search if you have 5+ servers?
- [ ] Can you evaluate whether a new server adds real value?

## Cost Implications

**Each MCP server injects tool definitions into your system prompt**:
- Typically 200-1,000 tokens per server
- 10 servers × 500 tokens = 5,000 tokens every message
- That's potentially 10-20% of your context budget

**Tool Search is the solution**:
- Dynamically loads only relevant tools
- Dramatically reduces context overhead
- Enable it if you have many servers

**Community wisdom**:
> "Went overboard with 15 MCP servers — ended up using only 4 daily."

Most developers who install 10+ servers use only 3-4 regularly. The rest are pure context waste.

**Check your context**:
```bash
/context
```

If MCP tool definitions are more than 5%, you have servers consuming tokens without providing value.

## Official Resources

- [MCP Protocol Specification](https://modelcontextprotocol.io)
- [DeepLearning.AI: MCP course](https://www.deeplearning.ai/short-courses/mcp-build-rich-context-ai-apps-with-anthropic/) (free)
- [Anthropic Academy: MCP Getting Started + Advanced](https://anthropic.skilljar.com/introduction-to-model-context-protocol) (free, 2 courses)
