---
description: "List all available coaching commands and what they do"
---

# Coach Help

Display the following command reference to the user:

## Available Commands

| Command | Description |
|---------|-------------|
| `/coach:assess` | Scan your Claude Code environment and report your skill level, gaps, and anti-patterns |
| `/coach:next` | Learn the next concept for your level — best for greenfield projects or building new skills |
| `/coach:execute` | Fix the gaps in an existing project step by step, with the why explained inline |
| `/coach:exercise` | Get a hands-on exercise for your current skill level |
| `/coach:status` | Show current coaching level, last assessment date, and discovery staleness |
| `/coach:whats-new` | Show recent Claude Code changes that affect your learning |
| `/coach:discover` | Check for new Claude Code features and updates |
| `/coach:cost` | Get cost optimization coaching for your current level |
| `/coach:help` | Show this help message |

## Which Command Should I Use?

| | `/coach:next` | `/coach:execute` |
|--|--------------|-----------------|
| **Context** | New project / greenfield | Existing project with gaps |
| **Approach** | Learn → then apply yourself | Apply → learn the why inline |
| **Driven by** | Curriculum level | Assessment findings |
| **Feeling** | "Teach me the next thing" | "Fix my actual setup with me" |
| **Resumable** | No | Yes — picks up where you left off |

**Start with `/coach:next`** if you're setting up a new project or want to work through the curriculum.

**Start with `/coach:execute`** if you've run `/coach:assess` and want to close the gaps on an existing project.

## Getting Started

If this is your first time, start with `/coach:assess` to scan your environment and determine your current skill level.

## How It Works

The coach scans your Claude Code configuration (CLAUDE.md, .claude/ directory, settings, and more) to detect your current skill level on an 11-level scale (L0–L10). It then delivers targeted coaching, identifies gaps in your setup, flags anti-patterns, and tracks your progress over time.

The coaching skill also activates automatically when you ask learning-related questions — no command needed.
