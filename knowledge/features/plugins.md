<!-- file: knowledge/features/plugins.md -->
<!-- last-updated: 2026-06-19 -->
<!-- source: https://code.claude.com/docs/en/plugins -->
<!-- curriculum_level: L10 -->

# Plugins — Packaging & Sharing Claude Code Setups

## Current State

A **plugin** bundles skills, slash commands, subagents, hooks, and MCP server configs into one installable unit. It's how you take a setup that gets the best out of Claude in *your* repo and hand it to your whole team — or the community — without anyone copy-pasting config. Plugins install from a **marketplace** (a git repo that lists one or more plugins).

This is the natural endpoint of "a repo built to get the best out of Claude": once your skills, agents, and gates are good, a plugin makes them portable and consistent across everyone.

## Key Concepts

### Anatomy

```
my-plugin/
├── .claude-plugin/
│   ├── plugin.json        → manifest: name, description, version, author
│   └── marketplace.json   → marketplace listing (if this repo is also a marketplace)
├── commands/*.md          → slash commands (/plugin-name:command)
├── skills/<name>/SKILL.md → auto-triggered skills
├── agents/*.md            → subagents
├── hooks/                 → lifecycle hook scripts
└── knowledge/ or any dir  → supporting content your components read
```

Components are **auto-discovered by directory convention** — `commands/`, `skills/`, `agents/`, `hooks/`. You don't enumerate them in the manifest. Keep `.claude-plugin/` to `plugin.json` (and `marketplace.json` if it's a marketplace); nothing else belongs there.

### `plugin.json` (the manifest)

Minimal and sufficient:

```json
{
  "name": "coach",
  "description": "One line shown in the install dialog.",
  "version": "1.0.1",
  "author": { "name": "Your Name" }
}
```

### Install flow (what your team runs)

```bash
# Add the marketplace (a GitHub owner/repo, or a local path)
claude plugin marketplace add <owner>/<repo>

# Install a plugin from it
claude plugin install <plugin-name>@<marketplace-name>

# Update after the marketplace repo changes
claude plugin update <plugin-name>@<marketplace-name>
```

Local dev loop — load without installing, picked up each launch:

```bash
claude --plugin-dir /abs/path/to/plugin     # then /reload-plugins to refresh mid-session
```

### Validation

```bash
claude plugin validate .                     # structure + manifest check
python3 -m json.tool .claude-plugin/plugin.json   # JSON sanity
```

Validate before every release. A passing validate with warnings is fine; read the warnings.

### Permissions model — the important gotcha

You scope what a plugin's components may do with a **`permissions` block in `.claude/settings.json`** (allow/deny tool rules), e.g.:

```json
{ "permissions": {
    "allow": ["Read", "Write(~/.claude/coaching/**)", "Bash(git *)"],
    "deny":  ["Read(**/.env*)", "Read(**/*.key)"] } }
```

**Do NOT put a `permissions` key in `plugin.json`** — the plugin schema doesn't support it, and it breaks install ("Unrecognized key: permissions"). For a human-readable trust statement, use a `trust` block in `marketplace.json` (Claude Code ignores it at load time, so it's documentation only) and/or a Security section in the README. Scoping that actually takes effect lives in `settings.json`.

Subagent frontmatter `tools:` takes plain tool **names** (`Read`, `Bash`, `WebFetch`) — not scoped `Bash(...)` patterns. Scope with `settings.json`; the agent list just selects which tools it can reach.

### When to build a plugin

- **Skill / command / agent** — solve it once for yourself in `.claude/`.
- **Plugin** — when a setup is good enough that the *team* (or community) should get it consistently, with versioned updates. If only you use it, you don't need the packaging.

## Mastery Checks

- [ ] Can you turn a working `.claude/` setup into an installable plugin?
- [ ] Does `claude plugin validate .` pass before you publish?
- [ ] Do you scope permissions in `settings.json` (not `plugin.json`)?
- [ ] Can a teammate install it with two commands and get your setup verbatim?

## Why It Matters

A plugin is how "this repo gets the best out of Claude" becomes "*every* repo on the team does." It removes the gap between your best-configured project and everyone else's — the same skills, gates, and agents, versioned and one command away. That consistency is what turns individual expertise into team capability.

## Official Resources

- [Plugins (Claude Code docs)](https://code.claude.com/docs/en/plugins)
- [Discover plugins](https://code.claude.com/docs/en/discover-plugins)
- [Extend Claude Code](https://code.claude.com/docs/en/features-overview)
