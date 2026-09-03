---
description: Focused security pass over the web-app baseline — one item at a time, with file:line evidence.
---

Walk the project against the `project-setup` skill's security baseline
(`${CLAUDE_PLUGIN_ROOT}/skills/project-setup/reference/security-baseline.md`) — the holes
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
3. **Cite only what you read this session.** A `guarded` verdict quotes the actual source line from
   a Grep/Read result in *this* session, citation plus the text:
   `db/leads.py:24 — "select(Lead).where(Lead.id == bindparam('id'))"`.
   If you cannot paste the real text, the status is **`unverified`**, never `guarded` — do not
   reconstruct line numbers from memory. A **gap** usually has no line, so it takes the other form:
   the search you ran and its empty result — `grepped "rate|limit|throttle" across api/, 0 matches`.
   A verdict with neither a quoted line nor a named empty search is not a finding; drop it.
   **Read the value, not just the setting.** A quote proves the guard is *there*, never that it
   guards: `allow_origins=["*"]` cites exactly as convincingly as a literal origin list, and so do
   an RLS policy `USING (true)`, `verify=False`, a limit of 100000/minute, an owner check inside a
   branch the request path never enters. Finish every citation with what the value *does* —
   `main.py:31 — allow_origins=["https://unisnab.app"], literal list, no wildcard`. If you can quote
   the line but cannot say that, the status is `unverified`. A guard you read and found wide open is
   a **gap** that happens to carry a line: cite it and say what it lets through.
   **A gap needs more than one empty grep.** A named search that came back empty proves you looked,
   not that the guard is absent — the guard may simply be spelled differently (a hand-rolled counter
   is not called "throttle"). Before calling anything a gap: search **at least two independent
   wordings**, including the domain word rather than the security term (`recent`, `count`, `since`,
   `attempts`), *and* read the handler the guard would live in. If you have not opened that code
   path, the status is `unverified`, not `gap`. A false gap that carries a citation is worse than a
   bare guess: it reads as audited.
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
| # | item | status (guarded/gap/unverified/n-a) | evidence | severity |
|---|---|---|---|---|
| 3 | IDOR / object ownership | gap | api/orders.ts:42 — only checks session, not owner | high |
| 5 | datastore RLS | guarded | supabase/policies.sql:12 — `using (auth.uid() = owner_id)`, not `true` | — |
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
