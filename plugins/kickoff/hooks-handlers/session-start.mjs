#!/usr/bin/env node
// Prime Claude to proactively offer the kickoff flow - no /kickoff:start needed.
// Emitted silently as additionalContext. The text tells Claude to engage ONLY when
// the user is actually starting or setting up a project, and not to nag otherwise,
// so the every-session firing stays non-intrusive.
//
// Node, not bash, and deliberately: in shell form Claude Code runs a hook through Git Bash on
// Windows and falls back to PowerShell when Git Bash is absent, where `bash` is not a command.
// `node` resolves in both, and Claude Code already runs on it. If node is somehow missing, both
// shells fail with a message naming it, which is a diagnosis rather than a puzzle.
//
// Opt out of the proactive primer (the /kickoff:* commands keep working either way):
// set KICKOFF_QUIET to any non-empty value globally, or create a .kickoff/quiet marker
// in the project. The marker is resolved against CLAUDE_PROJECT_DIR, not the cwd - hooks
// do not necessarily run from the project root (`cd src && claude`, monorepo subdirs,
// --add-dir), and a mute that silently fails open is worse than none.

import { existsSync } from "node:fs";
import { join } from "node:path";

if (process.env.KICKOFF_QUIET || existsSync(join(process.env.CLAUDE_PROJECT_DIR || ".", ".kickoff", "quiet"))) {
  process.exit(0);
}

console.log(JSON.stringify({
  hookSpecificOutput: {
    hookEventName: "SessionStart",
    additionalContext: "The `kickoff` kit is installed — offer it when the user's work is actually about setting up, planning, or strengthening a project. Stay silent otherwise: mid-task work in an established repo is NOT a cue, and repeating an offer the user passed on is worse than never making it. Route by what you can see, without asking: `.kickoff/notes.md` exists -> the repeat visit, `/kickoff:checkup`. No ledger and no code (empty folder or just an idea) -> ask what they are building, shape it with superpowers:brainstorming, then spec-first (track selector + 6-block spec), then equip via project-setup; do not recommend stack tooling before a stack exists. Code but no ledger -> `/kickoff:start` runs first contact: reverse-spec what exists, capture conventions, analyze every dimension, create the ledger. A web-facing project also warrants `/kickoff:security`, a focused walk of the security baseline. Recommend from a real needs analysis, never a fixed list; vet before installing, and write nothing without an explicit yes."
  }
}));
