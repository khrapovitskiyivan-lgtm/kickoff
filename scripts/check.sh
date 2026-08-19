#!/usr/bin/env bash
# Self-check for the kickoff plugin. Nothing here compiles on its own — a broken
# JSON manifest, a dead reference path or a missing frontmatter only shows up when
# a user's session silently misbehaves. Two identical path bugs shipped before this
# existed; that's what it's for.
#
# Usage: bash scripts/check.sh   (from the repo root)

cd "$(dirname "$0")/.." || exit 1
fail=0
note() { printf '  %s\n' "$1"; }
bad() { printf '  FAIL: %s\n' "$1"; fail=1; }

echo "== JSON manifests =="
for f in .claude-plugin/marketplace.json plugins/kickoff/.claude-plugin/plugin.json \
         plugins/kickoff/hooks/hooks.json; do
  if python -c "import json,sys;json.load(open(sys.argv[1],encoding='utf-8'))" "$f" 2>/dev/null; then
    note "ok   $f"
  else
    bad "$f is not valid JSON"
  fi
done

echo "== shell scripts =="
for f in $(find plugins scripts -name '*.sh' 2>/dev/null); do
  if bash -n "$f" 2>/dev/null; then note "ok   $f"; else bad "$f has a syntax error"; fi
done

echo "== SessionStart hook behaviour =="
if bash plugins/kickoff/hooks-handlers/session-start.sh |
   python -c "import json,sys;d=json.load(sys.stdin);assert d['hookSpecificOutput']['additionalContext']" 2>/dev/null; then
  note "ok   emits valid additionalContext JSON"
else
  bad "hook did not emit valid JSON"
fi
if [ -z "$(KICKOFF_QUIET=1 bash plugins/kickoff/hooks-handlers/session-start.sh)" ]; then
  note "ok   KICKOFF_QUIET=1 silences it"
else
  bad "KICKOFF_QUIET=1 did not silence the primer"
fi
# The marker is the fragile opt-out (path resolution), so it is the one that must be tested:
# it must work from a directory OTHER than the project root.
_tmp=$(mktemp -d) && mkdir -p "$_tmp/.kickoff" && touch "$_tmp/.kickoff/quiet"
if [ -z "$(cd / && CLAUDE_PROJECT_DIR="$_tmp" bash "$OLDPWD/plugins/kickoff/hooks-handlers/session-start.sh" 2>/dev/null)" ]; then
  note "ok   .kickoff/quiet marker silences it from any cwd"
else
  bad ".kickoff/quiet marker ignored when cwd is not the project root"
fi
rm -rf "$_tmp"

echo "== frontmatter =="
for f in plugins/kickoff/skills/*/SKILL.md plugins/kickoff/commands/*.md; do
  if head -1 "$f" | grep -q '^---$' && grep -q '^description:' "$f"; then
    note "ok   $f"
  else
    bad "$f is missing frontmatter or description:"
  fi
done

echo "== reference paths resolve =="
# Every `foo/bar.md`-looking reference inside a skill/command must exist relative to
# that file's own directory — this is the check that would have caught statusline.sh
# and security-baseline.md.
while IFS=: read -r src ref; do
  [ -z "$ref" ] && continue
  dir=$(dirname "$src")
  if [ -e "$dir/$ref" ]; then
    note "ok   $src -> $ref"
  else
    bad "$src references '$ref', which does not exist relative to $dir/"
  fi
done < <(
  grep -rhoE '^|`(\.\./)*(reference|scripts)/[A-Za-z0-9_.-]+\.(md|sh)`' \
    plugins/kickoff/skills plugins/kickoff/commands 2>/dev/null >/dev/null
  grep -rnoE '`(\.\./)*(reference|scripts)/[A-Za-z0-9_.-]+\.(md|sh)`' \
    plugins/kickoff/skills plugins/kickoff/commands 2>/dev/null |
    sed 's/:[0-9]*:/:/' | tr -d '`' | sort -u
)

echo
if [ "$fail" -eq 0 ]; then echo "ALL CHECKS PASSED"; else echo "SOME CHECKS FAILED"; fi
exit "$fail"
