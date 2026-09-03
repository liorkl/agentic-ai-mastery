# Security Policy

## Reporting a Vulnerability

**Do not open a public issue for a security problem.**

Use GitHub's private vulnerability reporting for this repository:
[Report a vulnerability](https://github.com/liorkl/agentic-ai-mastery/security/advisories/new).
Only the maintainer sees the report until a fix is published.

Please include:

- What the problem is and where in the repo it lives (file and line if you have it)
- How to reproduce it
- What an attacker could actually do with it

You can expect an acknowledgement within a few days. This is a personal, MIT-licensed
project with no paid support and no bug bounty.

## Scope

This repository ships a Claude Code plugin: Markdown commands, a skill, a subagent, a
knowledge base, and templates. It has no server, no database, and no runtime service.
The security surface is therefore:

- **What the plugin reads.** The coach scans configuration to assess an environment. It
  must never read `.env` files, credentials, keys, or secrets. A path that causes it to
  do so is a valid report.
- **What the plugin writes.** State writes belong under `~/.claude/coaching/**` only. A
  path that writes elsewhere — especially one that modifies a user's config without
  their go-ahead — is a valid report.
- **What the plugin tells you to run.** Knowledge files and templates contain commands,
  hooks, and permission rules that readers copy into their own setup. Guidance that is
  actively unsafe — a permission rule broader than it looks, a hook that fails open, a
  snippet that leaks a secret into a log — is a valid report, and worth more than a
  theoretical one.

Note that a plugin's `allowed-tools` and hooks execute on a user's machine. Review them
before installing this or any other plugin.

## Out of Scope

- Vulnerabilities in Claude Code itself — report those to
  [Anthropic](https://code.claude.com/docs/en/overview), not here
- Vulnerabilities in a dependency of a tool this plugin merely mentions
- Findings that require the user to have already granted `bypassPermissions`
