#!/usr/bin/env bash
# PreToolUse hook — matcher: Edit|Write
#
# Blocks a write that would put a secret into a file. Inspects the *proposed*
# content from tool_input, because the change is not on disk yet.
#
# Contract: input arrives as JSON on stdin (there is no $1).
#           exit 2 blocks the tool call; exit 0 allows it.
#           exit 1 would NOT block — it is a non-blocking error.
set -uo pipefail

input=$(cat)

# jq is optional: fall back to a grep over the raw payload if it is missing.
if command -v jq >/dev/null 2>&1; then
  payload=$(printf '%s' "$input" \
    | jq -r '[.tool_input.content, .tool_input.new_string] | map(select(. != null)) | join("\n")')
else
  payload="$input"
fi

# Assignments of a secret to a literal value. Deliberately narrow: matching
# every occurrence of the word "token" would block ordinary code.
SECRET_RE='(API_KEY|SECRET|PASSWORD|ACCESS_TOKEN|PRIVATE_KEY)[[:space:]]*[=:][[:space:]]*["'"'"']?[A-Za-z0-9/+_-]{8,}'

if printf '%s' "$payload" | grep -qE "$SECRET_RE"; then
  echo "Blocked: the proposed edit looks like it contains a hardcoded secret." >&2
  echo "Read it from the environment or a secret manager instead." >&2
  exit 2
fi

exit 0
