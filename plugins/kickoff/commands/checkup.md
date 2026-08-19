---
description: On-demand health pass on the current project — what to strengthen, honoring past decisions.
---

Run a strengthening **checkup** on the current project. Do NOT install anything without the user's confirmation.

1. Read the project context: `CLAUDE.md` (stack, conventions, roadmap / open tasks), stack & config files (`package.json`, `requirements.txt`, `pyproject.toml`, `go.mod`, `.git`, CI files, `Dockerfile`, tests dir), and **inventory installed tooling** by running `claude plugin list` + `claude mcp list` and noting the available skills — so nothing already present gets re-recommended. If house **conventions** aren't documented, sample them (lint/format config, naming, layout) and offer to record them in `CLAUDE.md` so recommendations match the existing style.
2. Read the ledger `.kickoff/notes.md` if it exists — do NOT re-recommend anything already **installed** or explicitly **declined**; surface still-**open** items. **Verify, don't trust:** for entries claiming a concrete artifact (file, config, hook, backup, enabled setting), confirm it still exists — a decayed `done` item outranks any new recommendation; report it and move it back to `open`. Optionally skim **sibling projects'** ledgers too (see the `project-setup` roll-up rules) to reuse decisions you already made next door — tooling verdicts only, never another project's content.
3. Follow the `project-setup` skill: analyze needs across **every** dimension, and for each gap find the best-fit tool from the **whole ecosystem** (your own knowledge, `npx skills find`, marketplaces, `claude-code-setup`) — the examples table is orientation, NOT the menu. Run the official `claude-code-setup` for a deep pass if available.
4. Report a concise, prioritized "what to strengthen" — each item tagged (baseline vs discovered) and vetted (skills are lower-risk than plugins/MCP; flag anything account-backed). Render it as a per-dimension **coverage scorecard** (`dimension | status (covered/gap/n-a) | tool | priority`) and persist it in the ledger so the next checkup **diffs against the last** and shows movement. Present this **full plan for one approval** before writing or installing anything — don't act item-by-item.
5. Update the ledger: append a dated entry for what was recommended, installed (on confirmation), or declined. Create `.kickoff/notes.md` if it's absent.

**Security stays one line here.** Report its status like any other dimension — don't expand it into a 15-item audit mid-sweep, which unbalances the report. If the project is web-facing, flag that it needs a deep pass and point at **`/kickoff:security`** (a focused, fresh-session walk of the security baseline with `file:line` evidence).

Keep it lightweight; skip the ceremony for one-off / throwaway projects.
