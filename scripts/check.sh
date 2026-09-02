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
# Catches a reference to a file that does not exist. Two forms ship and BOTH must be scanned:
# a backticked path and a markdown link. The old check saw only backticked paths beginning with
# reference/ or scripts/, so nothing under commands/ was ever examined and two dead markdown
# links shipped for twenty releases while this script printed ALL CHECKS PASSED.
# Extraction is done in python: getting the two regexes and the tab-separated output right in
# sed cost more than it saved, and a mangled extractor fails silently, which is the whole bug.
_refout=$(python - <<'PYCHK'
import os, re, sys
root = "plugins/kickoff"
# A path naming a file in the USER's project at runtime is not something we ship. Not a defect.
runtime = re.compile(r"^(\.kickoff/|\.claude/|\.github/|CLAUDE\.md|CLAUDE\.local\.md|SPEC_CHANGELOG\.md|"
                     r"package\.json|package-lock\.json|requirements|pyproject\.toml|go\.mod|settings\.json|"
                     r"settings\.local\.json|\.mcp\.json|docker-compose|Dockerfile|conftest\.py|ruff\.toml|"
                     r"\.pre-commit-config\.yaml|examples/)")
pats = [re.compile(r"\]\(([A-Za-z0-9_./-]+\.(?:md|sh|json))\)"),
        # A backticked name immediately followed by "](" is the LABEL of a markdown link,
        # not a path - the link target right after it is what gets checked.
        re.compile(r"`((?:\.\./)*[A-Za-z0-9_/.-]*[A-Za-z0-9_.-]+\.(?:md|sh))`(?!\]\()")]
seen, per_file, scanned, bad = set(), {}, 0, []
for dirpath, _, files in os.walk(root):
    for fn in files:
        if not fn.endswith(".md"):
            continue
        src = os.path.join(dirpath, fn).replace("\\", "/")
        text = open(src, encoding="utf-8").read()
        for pat in pats:
            for ref in pat.findall(text):
                if runtime.match(ref) or (src, ref) in seen:
                    continue
                seen.add((src, ref))
                per_file[src] = per_file.get(src, 0) + 1
                scanned += 1
                if not (os.path.exists(os.path.join(os.path.dirname(src), ref))
                        or os.path.exists(os.path.join(root, ref))):
                    bad.append(f"{src} references '{ref}' - resolves neither from {os.path.dirname(src)}/ nor from {root}/")
# A check that silently matches nothing is indistinguishable from a passing check, so assert the
# denominator PER FILE: a broken pattern or a renamed directory then fails loudly and locally.
# Assert per DIRECTORY, not per file: a command may legitimately cite only paths in the user's
# project (checkup.md and start.md name .kickoff/notes.md and CLAUDE.md and nothing we ship),
# so "every file has a reference" is a false invariant. What must never be zero is a whole tree.
for area in (f"{root}/skills", f"{root}/commands"):
    if not any(src.startswith(area) for src in per_file):
        bad.append(f"no reference extracted anywhere under {area}/ - the pattern is broken")
print(f"COUNT {scanned}")
for b in bad:
    print(f"BAD {b}")
PYCHK
)
note "scanned $(printf '%s' "$_refout" | sed -n 's/^COUNT //p') shipped references"
while IFS= read -r _l; do
  [ -z "$_l" ] && continue
  bad "${_l#BAD }"
done < <(printf '%s\n' "$_refout" | grep '^BAD ')

echo "== installed copy matches this repo =="
# The repo and the installed plugin are independent: `claude plugin install` copies the
# files into a versioned cache dir. Editing here changes nothing in any session until the
# plugin is updated — which is how five releases of fixes sat unused while every session
# ran the old build. Verify, don't trust, applied to ourselves.
_repo_ver=$(python -c "import json;print(json.load(open('plugins/kickoff/.claude-plugin/plugin.json',encoding='utf-8'))['version'])" 2>/dev/null)
if ! command -v claude >/dev/null 2>&1; then
  note "skip claude CLI not on PATH — cannot compare (repo is $_repo_ver)"
else
  _inst_ver=$(claude plugin list 2>/dev/null | grep -A2 'kickoff@kickoff' | sed -n 's/.*Version: *//p' | head -1)
  if [ -z "$_inst_ver" ]; then
    note "skip kickoff is not installed here (repo is $_repo_ver)"
  elif [ "$_inst_ver" = "$_repo_ver" ]; then
    note "ok   installed $_inst_ver == repo $_repo_ver"
  else
    bad "installed kickoff is $_inst_ver but this repo is $_repo_ver — your edits are NOT live. Run: claude plugin update kickoff@kickoff (then restart Claude Code)"
  fi
fi

echo
if [ "$fail" -eq 0 ]; then echo "ALL CHECKS PASSED"; else echo "SOME CHECKS FAILED"; fi
exit "$fail"
