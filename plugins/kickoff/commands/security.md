---
description: Focused security pass over the web-app baseline — one item at a time, with file:line evidence.
---

Walk the project against the `project-setup` skill's security baseline
(`skills/project-setup/reference/security-baseline.md` in this plugin) — the holes
fast-built web projects have most often. Report findings; **fix nothing without confirmation**.

> **Run this in a fresh session.** Whoever wrote the code will defend it — a clean context
> judges it honestly. This is a *focused* pass by design: `/kickoff:checkup` sweeps every
> dimension broadly, this one goes deep on security alone.

## How to run it

1. **Scope first.** Read the stack and entry points (routes/handlers, auth, DB client, upload
   and payment paths, client bundle config). Decide which baseline items **apply** — a static
   site has no IDOR; a project with no uploads skips file handling. Mark the rest `n-a`
   rather than inventing findings.
2. **One item at a time, in baseline order.** Do NOT ask yourself "is this project secure" —
   that answers itself with "looks fine". For each item, go find the guard.
3. **Demand evidence.** Every verdict cites `file:line` — where the guard lives, or the
   exact place it's missing. A claim with no line is not a finding.
4. **Per module, not per repo.** On a large codebase, walk module by module; the more code
   judged at once, the more gets missed.
5. **Compose, don't reinvent.** Use what already exists rather than hand-rolling a scanner:
   the built-in `/security-review` (reviews the current diff), a dependency audit
   (`npm audit` / `pip-audit` / `govulncheck`), and secret scanning (gitleaks) — this command
   owns the **project-wide baseline walk + the ledger**, those own their slice.

## Report

A **security scorecard**, ordered by severity:

```
### Security scorecard <YYYY-MM-DD>
| # | item | status (guarded/gap/n-a) | evidence (file:line) | severity |
|---|---|---|---|---|
| 3 | IDOR / object ownership | gap | api/orders.ts:42 — only checks session, not owner | high |
| 5 | datastore RLS | guarded | supabase/policies.sql:12 | — |
```

Then, for each **gap**: what an attacker does with it, and the concrete fix — smallest change
that closes it, at the right layer (server-side, not UI). Present the full list for **one
approval** before changing any code.

Persist the scorecard in the ledger `.kickoff/notes.md` so the next pass **diffs against it**
and shows movement — but **confirm `.kickoff/` is in `.gitignore` first, and add it if not**. This
scorecard is a prioritized, `file:line`-precise list of the project's *unfixed* holes: committed and
pushed, it is a map for whoever finds the repo. If the user wants it version-controlled anyway, say
plainly what that publishes. Never write secrets or exploit payloads into it either.

**Leaked secrets are rotated, not just hidden** — if a key ever reached the client bundle, git
history, or a public repo, say so plainly: hiding it leaves the old one valid.
