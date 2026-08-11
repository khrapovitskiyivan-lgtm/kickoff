#!/usr/bin/env bash
# Context-usage status line for Claude Code (free context-management aid).
# Shows model + a usage bar + %/tokens, and a "prepare to /clear" hint near the limit.
# Reads the JSON Claude pipes on stdin (no transcript parsing, no jq — uses node).
#
# Install:
#   1. Copy this file to ~/.claude/statusline.sh
#   2. Add to ~/.claude/settings.json:
#        "statusLine": { "type": "command", "command": "bash \"<abs path>/statusline.sh\"" }
#   3. Restart Claude Code.
# The 95% hint maps to ~950k on a 1M-context model, ~190k on a 200k one.
node -e '
let s="";
process.stdin.on("data", d => s += d).on("end", () => {
  let j = {}; try { j = JSON.parse(s); } catch {}
  const cw = j.context_window || {};
  const model = (j.model && j.model.display_name) || "?";
  const pct  = Math.round(cw.used_percentage || 0);
  const used = cw.total_input_tokens || 0;
  const size = cw.context_window_size || 0;
  const usedK = Math.round(used / 1000);
  const sizeK = Math.round(size / 1000);
  const filled = Math.max(0, Math.min(10, Math.round(pct / 10)));
  const bar = "█".repeat(filled) + "░".repeat(10 - filled);
  let line = `[${model}] ${bar} ${pct}% ${usedK}k/${sizeK}k`;
  if (pct >= 95)      line += "  ⚠ near limit → /clear or switch task";
  else if (pct >= 85) line += "  ▲ high — wrap up soon";
  process.stdout.write(line);
});
'
