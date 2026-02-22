<!--
topic: Output Styles
last_updated: February 2026
source_docs: curriculum-v1.1.md
curriculum_level: L1
-->

# Output Styles

## Current State

Claude Code offers configurable output styles that change how Claude communicates during coding sessions. As of February 2026:

| Style | Behavior | Best For |
|-------|----------|----------|
| **Default** | Concise task completion, minimal explanation | Production work, experienced users |
| **Explanatory** | Educational "Insights" blocks explaining implementation choices | New codebases, learning patterns |
| **Learning** | Collaborative mode with `TODO(human)` markers | Skill-building, hands-on practice |
| **Custom** | User-defined via `/output-style:new` | Project-specific needs |

## Key Concepts

### Default Style

Minimal overhead. Claude completes tasks without explaining why. Use when you know what you want and just need execution.

### Explanatory Style

Adds "Insights" blocks explaining:
- Why Claude chose a particular implementation
- Patterns being used
- Trade-offs considered

Example output:
```
[Implementation code here]

💡 Insights:
- Used the Repository pattern here because your codebase follows this in other modules
- Chose async/await over callbacks for consistency with src/api/
- Added error boundary to prevent cascading failures
```

### Learning Style

Designed for skill development:
- Leaves `TODO(human)` markers for you to complete
- Explains the "why" more thoroughly
- Asks reflective questions

Example:
```javascript
// TODO(human): Implement the validation logic here
// Hint: Check the pattern in src/validators/user.ts
function validateInput(data) {
  // Your implementation
}
```

### Custom Output Styles

Create project-specific styles:

```
/output-style:new
```

Then define:
- Tone (formal, casual, technical)
- Verbosity level
- Whether to include explanations
- Code comment preferences

### Persistence

Output style preferences can be saved per project:
- `.claude/settings.local.json` for personal preferences
- Project-level settings for team consistency

## Mastery Checks

- [ ] Have you tried each output style to understand the differences?
- [ ] Do you switch to Explanatory when exploring unfamiliar code?
- [ ] Have you used Learning mode for deliberate skill practice?
- [ ] Can you create a custom output style for your project?

## Cost Implications

**Explanatory and Learning modes generate more output tokens** — the expensive kind.

- Default: Minimal output, lowest cost
- Explanatory: ~20-40% more output tokens
- Learning: ~30-50% more output tokens

**When it's worth the extra cost:**
- Onboarding to a new codebase (Explanatory)
- Deliberate skill-building sessions (Learning)
- Teaching team members (Explanatory)

**When to switch to Default:**
- Production coding where you know what you want
- High-volume tasks
- Budget-constrained sessions

## Official Resources

- [Claude Code Output Styles](https://code.claude.com/docs/en/output-styles)
- [Customizing Claude's Behavior](https://code.claude.com/docs/en/customization)
