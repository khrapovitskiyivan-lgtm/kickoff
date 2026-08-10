---
description: On-demand health pass on the current project — what to strengthen, honoring past decisions.
---

Run a strengthening **checkup** on the current project. Do NOT install anything without the user's confirmation.

1. Read the project context: `CLAUDE.md` (stack, conventions, roadmap / open tasks), stack & config files (`package.json`, `requirements.txt`, `pyproject.toml`, `go.mod`, `.git`, CI files, `Dockerfile`, tests dir), and the tooling already installed.
2. Read the ledger `.kickoff/notes.md` if it exists — do NOT re-recommend anything already **installed** or explicitly **declined**; surface still-**open** items.
3. Follow the `project-setup` skill: analyze needs across **every** dimension, and for each gap find the best-fit tool from the **whole ecosystem** (your own knowledge, `npx skills find`, marketplaces, `claude-code-setup`) — the examples table is orientation, NOT the menu. Run the official `claude-code-setup` for a deep pass if available.
4. Report a concise, prioritized "what to strengthen" — each item tagged (baseline vs discovered) and vetted (skills are lower-risk than plugins/MCP; flag anything account-backed).
5. Update the ledger: append a dated entry for what was recommended, installed (on confirmation), or declined. Create `.kickoff/notes.md` if it's absent.

Keep it lightweight; skip the ceremony for one-off / throwaway projects.
