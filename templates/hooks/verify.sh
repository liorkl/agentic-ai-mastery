#!/usr/bin/env bash
# Stop hook — the verification gate.
#
# Runs the project's own checks before Claude is allowed to finish. This is the
# single highest-leverage thing in a Claude-ready repo: it turns "please verify
# your work" from a request into something that happens every time.
#
# Contract: exit 2 blocks the stop and sends stderr back to Claude as the reason.
#           exit 0 lets the turn end.
#           exit 1 would NOT block.
#
# Adapt the commands below to your project, and keep them quiet — verbose hook
# output crowds the context and buries the line Claude needs to act on.
set -uo pipefail

cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0

# Nothing to verify is not a failure — a hook that blocks in a repo with no
# test script would make the gate unusable.
[ -f package.json ] || exit 0
command -v npm >/dev/null 2>&1 || exit 0

has_script() {
  node -e "process.exit(require('./package.json').scripts?.['$1'] ? 0 : 1)" 2>/dev/null
}

failures=""

if has_script test; then
  if ! output=$(npm test --silent 2>&1); then
    failures+="tests failed:\n$(printf '%s' "$output" | tail -20)\n"
  fi
fi

if has_script lint; then
  if ! output=$(npm run lint --silent 2>&1); then
    failures+="lint failed:\n$(printf '%s' "$output" | tail -20)\n"
  fi
fi

if [ -n "$failures" ]; then
  printf 'Verification gate failed. Fix before finishing.\n\n%b' "$failures" >&2
  exit 2
fi

exit 0
