#!/usr/bin/env bash

# Prime Claude to proactively offer the kickoff flow — no /kickoff:start needed.
# Emitted silently as additionalContext. The text tells Claude to engage ONLY when
# the user is actually starting or setting up a project, and not to nag otherwise,
# so the every-session firing stays non-intrusive.

cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "The `kickoff` kit is installed. Be proactive: if the user is starting, planning, or scaffolding a new project, or wants to set up or strengthen an existing project's tooling, offer and run the kickoff flow yourself — do NOT wait for the `/kickoff:start` command. New project -> apply the `spec-first` skill (track selector + 6-block spec), then recommend and vet tooling via `project-setup`. Existing project -> detect the stack, recommend what is missing from the baseline (vet before install), and suggest the official `claude-code-setup` for a deeper pass. Keep it lightweight: skip the ceremony for one-off or throwaway scripts, and do NOT nag when the work is unrelated to project setup."
  }
}
EOF

exit 0
