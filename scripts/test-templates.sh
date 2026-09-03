#!/usr/bin/env bash
# Exercises the files in templates/ as real files.
#
# Run by .githooks/pre-push and by .github/workflows/templates.yml, so local and
# CI check the same thing. This exists because the bug that motivated templates/
# was a hook config in prose that could never load, with exit codes reversed.
# Prose cannot fail a test.
set -uo pipefail

cd "$(dirname "$0")/.." || exit 1

FAILED=0
pass() { echo "  PASS  $1"; }
fail() { echo "  FAIL  $1"; FAILED=1; }

echo "--- templates: JSON and hook config shape ---"
if python3 - <<'PY'
import json, sys
cfg = json.load(open("templates/settings.json"))
hooks = cfg.get("hooks", {})
if not hooks:
    sys.exit("templates/settings.json declares no hooks")
for event, groups in hooks.items():
    if not isinstance(groups, list):
        sys.exit(f"{event}: must be a list of matcher groups")
    for g in groups:
        # The failure this guards: a flat {matcher, command} group is valid JSON,
        # looks correct, and never fires.
        if "command" in g:
            sys.exit(f"{event}: flat 'command' on the matcher group — a hook needs a "
                     "nested 'hooks': [{'type','command'}] array or it silently never runs")
        if "hooks" not in g:
            sys.exit(f"{event}: matcher group missing its 'hooks' array")
        for h in g["hooks"]:
            if h.get("type") != "command":
                sys.exit(f"{event}: hook needs type 'command'")
            cmd = h.get("command")
            if not cmd:
                sys.exit(f"{event}: hook needs a command")
            # A bare ${CLAUDE_PROJECT_DIR} breaks on any path containing a space,
            # which is common on macOS. The documented form quotes it.
            if "CLAUDE_PROJECT_DIR" in cmd and '"$CLAUDE_PROJECT_DIR"' not in cmd:
                sys.exit(f"{event}: quote it as \"$CLAUDE_PROJECT_DIR\" so the hook "
                         "survives a path containing a space")
print("hook config shape OK for: " + ", ".join(hooks))
PY
then pass "settings.json valid, hook shape correct"; else fail "settings.json / hook shape"; fi

echo "--- templates: hooks are runnable ---"
for f in templates/hooks/*.sh; do
  bash -n "$f" 2>/dev/null && pass "syntax: $f" || fail "syntax: $f"
  [ -x "$f" ] && pass "executable: $f" || fail "not executable: $f"
done

echo "--- templates: block-secrets.sh behaviour ---"
run_hook() { echo "$1" | bash templates/hooks/block-secrets.sh >/dev/null 2>&1; echo $?; }

rc=$(run_hook '{"tool_name":"Write","tool_input":{"content":"const API_KEY = \"sk-live-abc123def456\";"}}')
[ "$rc" = "2" ] && pass "blocks a hardcoded secret (exit 2)" || fail "expected exit 2, got $rc"

rc=$(run_hook '{"tool_name":"Write","tool_input":{"content":"const key = process.env.API_KEY;"}}')
[ "$rc" = "0" ] && pass "allows an env lookup (exit 0)" || fail "expected exit 0, got $rc"

rc=$(run_hook '{"tool_name":"Edit","tool_input":{"new_string":"function parseToken(token) { return token.trim(); }"}}')
[ "$rc" = "0" ] && pass "no false positive on ordinary code" || fail "false positive, exit $rc"

rc=$(run_hook '{"tool_name":"Edit","tool_input":{"new_string":"PASSWORD=\"hunter2hunter2\""}}')
[ "$rc" = "2" ] && pass "blocks via the Edit new_string path" || fail "expected exit 2, got $rc"

echo "--- templates: verify.sh (the verification gate) ---"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

mkdir -p "$TMP/fail" "$TMP/pass" "$TMP/none"
echo '{"name":"f","scripts":{"test":"echo boom && exit 1"}}' > "$TMP/fail/package.json"
echo '{"name":"p","scripts":{"test":"exit 0"}}'              > "$TMP/pass/package.json"

CLAUDE_PROJECT_DIR="$TMP/fail" bash templates/hooks/verify.sh >/dev/null 2>&1; rc=$?
[ "$rc" = "2" ] && pass "blocks the stop on failing tests (exit 2)" || fail "gate did not block, exit $rc"

CLAUDE_PROJECT_DIR="$TMP/pass" bash templates/hooks/verify.sh >/dev/null 2>&1; rc=$?
[ "$rc" = "0" ] && pass "allows the stop on passing tests (exit 0)" || fail "expected exit 0, got $rc"

CLAUDE_PROJECT_DIR="$TMP/none" bash templates/hooks/verify.sh >/dev/null 2>&1; rc=$?
[ "$rc" = "0" ] && pass "nothing to verify is not a failure (exit 0)" || fail "expected exit 0, got $rc"

echo "--- templates: skill and agent frontmatter ---"
if python3 - <<'PY'
import pathlib, sys, re
checks = {
  "templates/skills/run-migrations/SKILL.md": ["name", "description"],
  "templates/agents/reviewer.md":             ["name", "description"],
}
for f, required in checks.items():
    t = pathlib.Path(f).read_text()
    if not t.startswith("---"):
        sys.exit(f"{f}: frontmatter must start on line 1")
    fm = t.split("---")[1]
    for key in required:
        if not re.search(rf"^{key}:\s*\S", fm, re.M):
            sys.exit(f"{f}: missing or empty '{key}'")
    print(f"{f}: frontmatter OK")
PY
then pass "frontmatter declares required fields"; else fail "frontmatter"; fi

echo
if [ "$FAILED" -eq 0 ]; then
  echo "=== templates: all checks passed ==="
else
  echo "=== templates: FAILURES ABOVE ==="
fi
exit "$FAILED"
