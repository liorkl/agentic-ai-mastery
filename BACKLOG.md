# Backlog

## Todo

- [ ] UX: improve SKILL.md Rule 4 to support proactive mid-task warnings (e.g., "before you add that 5th MCP server...")
- [ ] Adoption: make /coach:assess output shareable as a standalone markdown summary
- [ ] Legal: add credits for knowledge sources used + add credits going forward when using new sources
- [ ] Plan how to make this plugin usage efficient
- [ ] Marketplace readiness: plan what is needed to meet the highest standards for eligibility in official plugin marketplaces
- [ ] Testing: extend the test strategy beyond templates — `claude plugin eval` (early access) can assert command *behaviour*, not just artifact shape
- [ ] Import best practices
- [ ] Marketing: plan README page and webpage that demonstrate value and drive installs/adoption
- [ ] UX: add cooldown check to /coach:assess — if last assessment is recent, prompt before re-running to avoid duplicate scans
- [ ] Mission 1: broaden the /coach:apply me catalogue — output styles, keybindings, statusline scripts
- [ ] Mission 2: a `/coach:apply repo` step that adds the verification gate to CI, not just a local hook

## In Progress

## Done

- [x] Trust: create SECURITY.md documenting what the plugin reads, writes, and never touches (2.0.0)
- [x] Trust: declare tool permissions. Resolved differently than planned — per-command `allowed-tools` frontmatter, plus honest README wording about what is instruction vs. enforcement. The old note here claimed a `permissions` key in plugin.json "causes install to fail"; that expired — validation now reports it as an unknown field Claude Code ignores at load time (2.0.0)
- [x] Cost/UX: narrow the coaching skill trigger scope — description now names Claude Code subjects with a `when_to_use` that excludes general programming questions (2.0.0)
- [x] UX: /coach:learn and /coach:apply generate the actual config/code fix rather than describing it — repo steps start from the tested `templates/` (2.0.0)
- [x] Architecture: omit per-user discovery and bundle knowledge refreshes with plugin releases. Removed /coach:discover and /coach:whats-new; freshness now ships with a version bump (2.0.0)
- [x] Security: plan security actions and communicate them — SECURITY.md, `permissions.deny` guidance, and a README section that states plainly where instruction ends and enforcement begins (2.0.0)
- [x] Testing: automatic testing strategy — `scripts/test-templates.sh` runs the shipped templates in pre-push and CI, with negative controls proving it catches the original hook bugs (2.0.0)
- [x] Eat our own dog food: this repo now has the Stop verification gate its own rubric demands, built from the template it ships (2.0.0)
- [x] Two missions made explicit: `me` | `repo` scopes, knowledge base reorganized, /coach:apply me closes the gap where mission 1 was scanned but never acted on (2.0.0)
- [x] Lean surface: 12 user-facing entry points reduced to 5 (2.0.0)
- [x] Content accuracy: corrected the hook config schema, inverted exit codes, 10 nonexistent slash commands, 2 fake settings keys, 2 wrong CLI flags, and refreshed to the Claude 5 family (2.0.0)
- [x] New command: /coach:progress week — progress recap from assessment + outcome history (led by repo-readiness, not level)
- [x] New command: /coach:progress previous — before/after assessment diff showing concrete improvement
- [x] Knowledge: create `knowledge/repo-ready/plugins.md` — anatomy, validation, marketplace/install flow, permissions model
- [x] UX: explain the passive coaching skill in help output
- [x] Re-center coaching on outcomes (verification-first) instead of feature collection; cost/token coaching off by default
- [x] Refresh models/pricing/best-practices; fix broken install (owner), manifest, agent tool frontmatter
- [x] Trust: add scan receipt at end of /coach:assess output (PR #12)
- [x] ~~Cost: add token usage estimate footer to every command output (PR #13)~~ — REVERTED when cost coaching was made off-by-default; the command that kept it was itself removed in 2.0.0
- [x] UX: refactor lessons to lead with the actionable fix — actual code/config, explanation second (PR #14)
