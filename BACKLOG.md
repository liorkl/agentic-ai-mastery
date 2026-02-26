# Backlog

## Todo

- [ ] Trust: create SECURITY.md documenting what plugin reads, writes, never touches, and network calls made
- [ ] Trust: add explicit tool permissions to plugin.json manifest — auditable by anyone. NOTE: `"permissions"` key is NOT currently supported by the Claude Code plugin schema (causes install to fail with "Unrecognized key: permissions"). Need to wait for schema support or find an alternative (marketplace.json + README "Security" section as documentation-only approach).
- [ ] Cost/UX: narrow the coaching skill trigger scope to reduce unwanted activations (not opt-in — just more precise triggers)
- [ ] UX: improve SKILL.md Rule 4 to support proactive mid-task warnings (e.g., "before you add that 5th MCP server...")
- [ ] UX: refactor /coach:next to lead with actionable fix (actual code/config), explanation second
- [ ] UX: /coach:next and skill responses should generate the actual config/code fix, not just describe it
- [ ] New command: /coach:recap — weekly progress summary from assessment and outcome history
- [ ] New command: /coach:compare — before/after environment diff showing concrete improvement
- [ ] Adoption: make /coach:assess output shareable as a standalone markdown summary
- [ ] Legal: add credits for knowledge sources used + add credits going forward when using new sources
- [ ] Plan how to make this plugin usage efficient
- [ ] Security: plan security actions we can take and how to communicate them to users to increase trust
- [ ] Marketplace readiness: plan what is needed to meet the highest standards for eligibility in official plugin marketplaces
- [ ] Testing: plan an automatic testing strategy for this type of Claude Code plugin
- [ ] Import best practices
- [ ] Marketing: plan README page and webpage that demonstrate value and drive installs/adoption
- [ ] Architecture: consider omitting per-user discovery and instead bundling latest Claude Code feature updates with plugin version upgrades — reduces user spend and avoids redundant scans

## In Progress

## Done

- [x] Trust: add scan receipt at end of /coach:assess output (PR #12)
- [x] Cost: add token usage estimate footer to every /coach:* command output (PR #13)
- [x] UX: refactor /coach:next to lead with actionable fix — actual code/config, explanation second (PR #14)
