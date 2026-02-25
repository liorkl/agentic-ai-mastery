## Type of Change

- [ ] Bug fix
- [ ] New command
- [ ] Knowledge file (new or updated)
- [ ] Curriculum improvement
- [ ] Documentation
- [ ] Chore (CI, tooling, manifest)

## Description

What does this PR do and why?

## Related Issue

Closes # (if applicable)

## Checklist

- [ ] `claude plugin validate .` passes
- [ ] All knowledge files under 500 lines (`wc -l knowledge/**/*.md`)
- [ ] Total knowledge base under 5,000 lines (`cat knowledge/**/*.md | wc -l`)
- [ ] JSON files valid (`python3 -m json.tool .claude-plugin/plugin.json`)
- [ ] `CHANGELOG.md` updated under `## [Unreleased]`
- [ ] No `.env`, credentials, secrets, or key files touched or referenced
- [ ] Branch targets `master`
- [ ] Tested locally with `claude plugin install coach@agentic-ai-mastery`
