#!/usr/bin/env bash
# Stop hook — this repo's verification gate.
#
# The plugin classifies "no verification gate" as a HIGH-severity anti-pattern.
# It shipped without one for its own repo. This is the fix, built from
# templates/hooks/verify.sh — the same template the plugin hands to users.
#
# Deliberately does NOT run `claude plugin validate`: that spawns another
# claude process from inside a session. Pre-push and CI own that check.
#
# exit 2 blocks the stop and returns stderr to Claude. exit 1 would not block.
set -uo pipefail

cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0

failures=""

# 1. Manifests and template config must be parseable.
for f in .claude-plugin/plugin.json .claude-plugin/marketplace.json \
         .claude/settings.json templates/settings.json; do
  [ -f "$f" ] || continue
  if ! python3 -m json.tool "$f" >/dev/null 2>&1; then
    failures+="invalid JSON: $f\n"
  fi
done

# 2. Line limits the repo sets for itself.
while IFS= read -r f; do
  n=$(wc -l < "$f")
  if [ "$n" -gt 500 ]; then
    failures+="$f is $n lines (max 500) — split it\n"
  fi
done < <(find knowledge commands skills agents -name '*.md' 2>/dev/null)

if [ -d knowledge ]; then
  total=$(find knowledge -name '*.md' -exec cat {} + | wc -l | tr -d ' ')
  if [ "$total" -gt 5000 ]; then
    failures+="knowledge base is $total lines (max 5000)\n"
  fi
fi

# 3. The templates must still work.
if [ -f scripts/test-templates.sh ]; then
  if ! out=$(bash scripts/test-templates.sh 2>&1); then
    failures+="template suite failed:\n$(printf '%s' "$out" | grep FAIL)\n"
  fi
fi

if [ -n "$failures" ]; then
  printf 'Verification gate failed. Fix before finishing.\n\n%b' "$failures" >&2
  exit 2
fi

exit 0
