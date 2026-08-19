# kickoff

A shareable Claude Code starter kit. Run /kickoff:start to plan a project spec-first, or audit an existing one and equip it with vetted tooling matched to your stack — across every dimension (testing, security incl. LLM risks, delivery…). On your OK it writes a scoped permissions allowlist + quality-gate config. A calmer alternative to "install this, install that" tutorials.

## Install (one time)

> **Prerequisite — [Superpowers](https://github.com/obra/superpowers).** kickoff's planning
> and build flow (`spec-first`, `/kickoff:start`) is an **overlay** on the Superpowers
> brainstorm → plan → build → verify skills — install it too, or those steps will call skills
> that aren't there. (The equip side — `/kickoff:checkup` and tooling recommendations — works
> without it.)

```bash
# Prerequisite: Superpowers (powers brainstorm → plan → build → verify)
claude plugin marketplace add obra/superpowers-marketplace
claude plugin install superpowers@superpowers-marketplace

# kickoff
claude plugin marketplace add https://github.com/khrapovitskiyivan-lgtm/kickoff
claude plugin install kickoff@kickoff
```

Restart Claude Code so both load.

## How it activates

- **On its own** — a SessionStart primer makes Claude proactively offer the flow when
  you're starting or strengthening a project (and stays quiet on unrelated work).
- **Or explicitly** — `/kickoff:start` (set up), `/kickoff:checkup` (strengthen), `/kickoff:security` (deep security pass).
- **Mute the primer** — set `KICKOFF_QUIET=1` (global) or drop a `.kickoff/quiet` file in a
  project to silence the proactive nudge; the `/kickoff:*` commands keep working.

## What it does

**`/kickoff:start` — set up**
- **Just an idea (no stack yet)?** It shapes the idea first (via brainstorming) and helps
  you choose a stack — *before* any tooling.
- **New project (stack chosen)?** A spec-first plan (Spec vs Spike, a 6-block spec), then
  the right tooling.
- **Existing project?** Detects your stack and recommends what's missing.

**`/kickoff:checkup` — strengthen (any time)**
- Reads your `CLAUDE.md` + stack + installed tooling + the ledger, analyzes gaps across
  every dimension, and reports what to strengthen. Honors past decisions (won't re-suggest
  what you installed or declined; re-surfaces an item whose decline reason has changed).

**`/kickoff:security` — deep security pass (web projects)**
- Walks the 15-item web-app security baseline **one item at a time** — brute-force, IDOR,
  server-side authz, datastore RLS, injection, uploads, secrets, webhook forgery, race
  conditions, paid-API cost, CORS — and reports a scorecard with `file:line` evidence per item.
- Focused by design: `checkup` sweeps every dimension broadly, this one goes deep on security.
  Best run in a **fresh session** — whoever wrote the code will defend it. Composes with the
  built-in `/security-review` and dependency/secret scanners rather than replacing them.

**How it recommends**
- **Analyzes real needs**, not just your stack — the built-in baseline is a fast prior,
  not a ceiling; for anything beyond it, it actively discovers (skills.sh, marketplaces,
  the official `claude-code-setup`).
- **Vets before install** — flags what executes code (hooks / MCP servers) vs plain
  instructions (skills), and never installs without your confirmation.
- **Tracks progress** via a per-project ledger (`.kickoff/notes.md`).
- **Reuses what you decided next door** — optionally skims sibling projects' ledgers so a tool
  you already vetted (or declined) isn't re-litigated from scratch. Tooling verdicts only:
  no project content, business detail, or secrets ever cross between projects.

## What's inside

- `spec-first` skill — methodology overlay (track selector, 6-block spec, reverse-spec for
  legacy code, living-spec / drift control).
- `project-setup` skill — analysis-first tooling recommendation by project dimension +
  vetting + the ledger; includes a 15-item web-app **security baseline**.
- `/kickoff:start`, `/kickoff:checkup`, `/kickoff:security` — commands.
- A SessionStart primer for proactive, non-naggy activation.

## Examples

Worked outputs on one running example (a small Leads-intake API) — a filled 6-block spec, a
checkup coverage scorecard + ledger, and the config kickoff writes on confirmation. See
[`examples/`](examples/README.md).

## Fork it

To republish under a different account, update `owner` in `.claude-plugin/marketplace.json`,
`author` in `plugins/kickoff/.claude-plugin/plugin.json`, and the marketplace URL above.

MIT — see `LICENSE`.
