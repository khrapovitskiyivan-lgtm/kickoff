#!/usr/bin/env bash

# Prime Claude to proactively offer the kickoff flow — no /kickoff:start needed.
# Emitted silently as additionalContext. The text tells Claude to engage ONLY when
# the user is actually starting or setting up a project, and not to nag otherwise,
# so the every-session firing stays non-intrusive.

# Opt out of the proactive primer (the /kickoff:* commands keep working either way):
# set KICKOFF_QUIET=1 globally, or create a .kickoff/quiet marker in the project.
if [ -n "${KICKOFF_QUIET:-}" ] || [ -f ".kickoff/quiet" ]; then
  exit 0
fi

cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "The `kickoff` kit is installed. Be proactive: if the user is starting, planning, or scaffolding a new project, or wants to set up or strengthen an existing project's tooling, offer and run the kickoff flow yourself — do NOT wait for the `/kickoff:start` command. New project, an empty folder, or just an idea -> be PROACTIVE: if there is no code and no design yet, ASK what they are building and offer to shape it with superpowers:brainstorming (do NOT stay silent, and do NOT recommend tooling before a stack exists). Once the idea is shaped and a stack chosen -> spec-first (track selector + 6-block spec), THEN equip via project-setup. Existing project -> analyze needs across EVERY dimension and recommend the best-fit tools from the whole ecosystem (your own knowledge + skills.sh + claude-code-setup), NOT just a fixed list; vet before install. Keep it lightweight: skip the ceremony for one-off or throwaway scripts, and do NOT nag when the work is unrelated to project setup."
  }
}
EOF

exit 0
