---
globs: ["knowledge/**/*.md"]
---

# Knowledge File Rules

## Line Limit

Every knowledge file must stay under 500 lines.

Before saving any knowledge file, run `wc -l <filename>` to verify the line count.
If a file would exceed 500 lines, split it by subtopic instead. Each split file must use
the same base name with a descriptive suffix (e.g., `agents.md` → `agents-basics.md` and
`agents-advanced.md`).

## Metadata Header

All knowledge files must start with a metadata comment header as the very first lines:

```markdown
<!-- file: knowledge/<category>/<filename>.md -->
<!-- last-updated: YYYY-MM-DD -->
<!-- source: <upstream doc URL or "internal"> -->
```

No content may appear before this header block.

## Formatting

- Use ATX headers (`#`, `##`, `###`) — never underline-style (Setext) headers.
- No trailing whitespace on any line.
- One blank line before and after every header.
- File must end with a single newline.
