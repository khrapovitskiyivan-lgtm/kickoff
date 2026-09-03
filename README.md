# kickoff

A shareable Claude Code starter kit for people shipping fast. It walks your project against a
**32-item web-app and Telegram Mini App security baseline** — the holes quickly-built apps actually have — and keeps a
**ledger** of what you installed, declined, and why, so nothing gets re-litigated and nothing
silently rots. Around that: spec-first planning for new work, and a vetted tooling pass for the
rest. A calmer alternative to "install this, install that" tutorials.

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

**Platform.** The SessionStart primer runs on `node`, which Claude Code already runs on, so it
works on Windows with or without Git Bash. The greppable checks inside the reference files assume
a POSIX shell (Git Bash on Windows); everything else is plain markdown.

## How it activates

- **On its own** — a SessionStart primer makes Claude proactively offer the flow when
  you're starting or strengthening a project (and stays quiet on unrelated work).
- **Or explicitly** — `/kickoff:security` (deep security pass), `/kickoff:start` (once per project), `/kickoff:checkup` (repeat visit).
- **Mute the primer** — set `KICKOFF_QUIET=1` (global) or drop a `.kickoff/quiet` file in a
  project to silence the proactive nudge; the `/kickoff:*` commands keep working.

## What it does

**`/kickoff:security` — the deep security pass (start here for a live web app)**
- Walks the **32-item security baseline** one item at a time: password storage, sessions
  and JWTs, IDOR, server-side authz, datastore RLS, CSRF, SSRF, injection, uploads, secret
  exposure, webhook forgery, race conditions, paid-API cost abuse, CORS, and more.
- Every verdict carries evidence: a **quoted line** for a guard that exists, or the **search that
  came back empty** for one that doesn't — so a scorecard can't be padded with plausible-looking
  citations. Nothing gets changed without your approval.
- Best run in a **fresh session** — whoever wrote the code will defend it. Composes with the
  built-in `/security-review` and dependency/secret scanners rather than replacing them.

**`/kickoff:start` — the once-per-project pass**
- It routes itself from what it sees, rather than asking: no code yet → shapes the idea and the
  stack choice first (via brainstorming), then a spec-first plan; existing codebase → a
  **first-contact pass** that reverse-specs what's there, captures your conventions, analyzes
  every dimension and creates the ledger.

**`/kickoff:checkup` — the repeat visit**
- Reads the ledger and **verifies it**: anything recorded as done that names a file, config or
  backup gets checked for still doing its job, not merely still existing — a guard that rotted
  outranks any new suggestion.
  Then reports what to strengthen, honoring what you already installed or declined.

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
  vetting + the ledger; includes a 32-item web-app and Mini App **security baseline**.
- `/kickoff:start`, `/kickoff:checkup`, `/kickoff:security` — commands.
- A SessionStart primer for proactive, non-naggy activation.

## The ledger

kickoff keeps its memory in `.kickoff/notes.md` inside each project — plain markdown you can
read and edit by hand. A dated entry per pass, plus the latest scorecard:

```markdown
## 2026-08-13
- installed: gitleaks (security & privacy)
- open: github-actions (delivery) — no CI yet
- declined: sentry (observability) — no DSN yet; revisit at launch
```

`installed` and `declined` items aren't suggested again (a `declined` one comes back only if
its reason stops holding), and `open` ones resurface next pass. Never put secrets in it.

## Examples

Worked outputs on one running example (a small Leads-intake API) ship **inside the skills**, so
the model reads them as it works rather than them sitting in a folder nothing loads:

- [a filled 6-block spec](plugins/kickoff/skills/spec-first/reference/example-spec.md)
- [a checkup + security scorecard and ledger entry](plugins/kickoff/skills/project-setup/reference/example-checkup.md)
- [the config the equip step writes](plugins/kickoff/skills/project-setup/reference/example-equip.md)

## Fork it

To republish under a different account, update `owner` in `.claude-plugin/marketplace.json`,
`author` in `plugins/kickoff/.claude-plugin/plugin.json`, and the marketplace URL above.

MIT — see `LICENSE`.
