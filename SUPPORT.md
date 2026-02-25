# Support

## Getting Help

Open a [GitHub Issue](https://github.com/liorklibansky/agentic-ai-mastery/issues/new) with the `question` label. Include the output of `/coach:assess` so maintainers have context.

## Reporting Bugs

Use the [bug report template](https://github.com/liorklibansky/agentic-ai-mastery/issues/new?template=bug_report.md). A good report includes what you did, what you expected, what happened, and your `/coach:assess` output.

## Feature Requests

Use the [feature request template](https://github.com/liorklibansky/agentic-ai-mastery/issues/new?template=feature_request.md). Check [existing issues](https://github.com/liorklibansky/agentic-ai-mastery/issues) first — add a thumbs-up reaction to an existing one rather than opening a duplicate.

## Security Issues

See [SECURITY.md](SECURITY.md). Do not open a public issue for security disclosures.

## Before Opening an Issue

1. Run `/coach:assess` and copy the output into your issue
2. Check [existing open and closed issues](https://github.com/liorklibansky/agentic-ai-mastery/issues?q=is%3Aissue)
3. Confirm you are on a recent version: `claude --version`

## Response Time

This is an open source project maintained on a best-effort basis. No SLA guarantees.

## Plugin Not Working?

Quick self-diagnosis steps:

1. **Check Claude Code version**
   ```bash
   claude --version
   ```

2. **Re-run assess to reinitialize state**
   ```bash
   /coach:assess
   ```

3. **Check the state directory exists**
   ```bash
   ls ~/.claude/coaching/state/
   ```

4. **Reinstall the plugin**
   ```bash
   claude plugin install coach@agentic-ai-mastery
   ```

5. **Validate plugin structure**
   ```bash
   claude plugin validate .
   ```

If none of the above resolves the issue, open a [bug report](https://github.com/liorklibansky/agentic-ai-mastery/issues/new?template=bug_report.md) with the output of each step.
