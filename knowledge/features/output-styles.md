<!-- file: knowledge/features/output-styles.md -->
<!-- last-updated: 2026-06-21 -->
<!-- source: https://code.claude.com/docs/en/best-practices -->
<!-- curriculum_level: L1 -->

# Output Styles

## Current State

Claude Code offers configurable output styles that change how Claude communicates during coding sessions. The built-in styles:

| Style | Behavior | Best For |
|-------|----------|----------|
| **Default** | Standard engineering — concise task completion | Most production work |
| **Proactive** | Acts immediately, asks fewer clarifying questions | When you trust the direction and want momentum |
| **Explanatory** | Adds educational asides while it works | Onboarding to unfamiliar code |
| **Learning** | Collaborative — shares insights and asks YOU to implement marked `TODO(human)` sections | Skill-building, hands-on practice |

Custom styles live in `~/.claude/output-styles/` (create one with `/output-style:new`).

The **Learning style is directly useful for skill-building and coaching** — it keeps you in the loop as the implementer rather than handing you finished code, which is exactly the muscle this plugin is built to grow.

## Key Concepts

### Default Style

Standard engineering communication. Claude completes tasks concisely without unprompted explanation. Use when you know what you want and just need execution.

### Proactive Style

Acts immediately and asks fewer clarifying questions, favoring momentum over confirmation. Use when the direction is clear and you'd rather review the result than answer questions mid-task.

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

Create project-specific styles with `/output-style:new`. Custom styles are stored as files in `~/.claude/output-styles/`, where you can define tone, verbosity, whether to include explanations, and code-comment preferences.

### Persistence

The active output style can be saved per project via `.claude/settings.local.json` (personal) or project-level settings (team consistency).

## Mastery Checks

- [ ] Have you tried each output style to understand the differences?
- [ ] Do you switch to Explanatory when exploring unfamiliar code?
- [ ] Have you used Learning mode for deliberate skill practice?
- [ ] Can you create a custom output style for your project?

## Why It Matters

The right output style matches Claude's communication to what you're trying to get out of the session:

- **Default**: fastest path to a finished change when you already know what you want
- **Proactive**: keeps momentum by acting on a clear direction instead of pausing to confirm
- **Explanatory**: surfaces the "why" behind each choice — ideal when onboarding to an unfamiliar codebase or teaching teammates
- **Learning**: leaves `TODO(human)` markers and asks reflective questions, so you build the skill rather than just receive the answer
- **Custom**: encodes a project's tone and conventions so every session speaks the same language

Picking the wrong style isn't a cost problem so much as a fit problem: Default during exploration hides reasoning you need, while Learning during high-volume production work slows you down.

(For the token/cost angle, use the opt-in `/coach:cost` command.)

## Official Resources

- [Claude Code Output Styles](https://code.claude.com/docs/en/output-styles)
- [Customizing Claude's Behavior](https://code.claude.com/docs/en/customization)
