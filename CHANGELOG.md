# Changelog

Notable changes to the kickoff plugin. Newest first.

## 0.11.0 — lead with what's actually differentiated
A product reviewer put it bluntly: *"I'd send a friend the security baseline and mention the
plugin."* The dimension sweep — the thing on the front page — is roughly what a good model does
anyway when asked "what's missing here?", while the baseline and the ledger aren't reproducible
from its priors. So the framing is inverted: **security and the ledger lead**, the tooling sweep
supports. Also acted on the same review's cuts:
- `stack-adapters.md` shrank from a per-stack matrix to the rule it existed to enforce (which
  blocks need translating, and never default to the stack you saw last). The matrix was commodity
  knowledge with a shelf life — and its first column was Supabase, causing the bias it warned about.
- `statusline.sh` left the plugin. Tuning your Claude Code setup is a different object from
  equipping a project; only the handoff-note practice stayed.
- `/kickoff:start` routes itself instead of asking "new or existing?" — the answer is observable
  (empty folder / code / an existing ledger), and an existing ledger now sends you to `checkup`.
  Both command descriptions state that rule, and the SessionStart primer — which only ever knew
  about `start` — now routes across all three.

## 0.10.0 — executability
Rules a model reliably skips are worth nothing. **Verify now precedes skip** in the ledger pass
(0.7.1's headline rule was dead: "skip anything installed" came first). The SessionStart hook got
`matcher: startup` — with none it re-fired on every resume and compaction. `.kickoff/quiet` now
resolves against `CLAUDE_PROJECT_DIR`, so the documented mute no longer fails open, and the
self-check tests it. Worked examples moved **inside the skills** and are cited where they're needed
— they were unreferenced and outside the shipped plugin. `file:line` evidence must now quote the
line actually read (or, for a gap, the search that came back empty); anything else is `unverified`.
The examples table moved out of the skill with a countable ceiling on how much of it may surface.

## 0.9.0 — the advice itself
Security baseline 15 → 28 items, after an expert found two wrong claims and ~14 omissions.
**Removed:** "automode mitigates prompt injection" (false — no model setting makes injection safe);
the "untouched >1 year = risky" dependency heuristic (finished libraries are fine; recent commits
are what a hijacked package looks like). **Rewritten:** CORS — it is *not* an access control, and
the old rule was a no-op; the real bug is a reflected `Origin`. **Added:** password hashing,
sessions/JWT, CSRF, SSRF, security headers, mass assignment, command injection, NoSQL injection,
open redirect, deserialization, multi-tenancy, debug-mode/exposed surfaces, client-trusted business
logic, backups. The header now says plainly that a full scorecard is not an audit.

## 0.8.0 — stop doing harm
Three places where kickoff was actively harmful rather than merely incomplete. It wrote permission
grants to `.claude/settings.json`, which is **committed** — a machine-local decision published to
everyone who clones; now `settings.local.json`, gitignored. Allow entries are presented by
consequence: `Bash(pytest:*)` runs the repo's `conftest.py` — arbitrary code execution wearing a
narrow-looking name. The sibling roll-up is now consent-gated, quarantined behind a read-only
subagent, and labels neighbouring ledgers **untrusted** — a cloned repo's ledger claiming a
"vetted" tool was a working path to installing an attacker's MCP server. Also: `.kickoff/` is
gitignored (the security scorecard is a map of unfixed holes), and the impossible promise to block
`--no-verify` is gone.

## 0.7.1
- **Verify, don't trust.** The ledger records what was *decided*, not what is *still true*.
  Entries claiming a concrete artifact (file, config, hook, backup, enabled setting) are now
  checked against reality before counting as done — a decayed `done` item outranks any new
  recommendation. Found by dogfooding a checkup on a real project: a backup recorded as done
  had been written to a temp directory and was gone days later, leaving no copy at all.

## 0.7.0
- **First-contact pass for existing projects.** `/kickoff:start` on a brownfield project is now
  a real onboarding pass — reverse-spec the code, capture conventions, analyze every dimension,
  create the ledger and a baseline scorecard — instead of a thin duplicate of `checkup`.
  `start` = first contact (once), `checkup` = the recurring pass that diffs against it.
- **Security is designed in, not bolted on.** The spec skeleton gains a **Security / abuse**
  block; `spec-first` said to translate Security via the stack adapter but the skeleton had
  nowhere to put it.
- **Self-check** — `scripts/check.sh` validates JSON manifests, shell syntax, hook behaviour
  (including the `KICKOFF_QUIET` opt-out), frontmatter, and that every `reference/…` path
  resolves. Two identical dead-path bugs shipped before this existed.
- Handoff-note practice added to the token/cost dimension; decision-rationale (ADR) line added
  to the spec-first checklist; a security-scorecard example and the ledger format documented.

## 0.6.0
- **Sibling ledger roll-up** — optionally reads other projects' `.kickoff/notes.md` under the
  same parent folder so a tool you already vetted (or declined) next door isn't re-litigated.
  Tooling verdicts only: no project content, business detail or secrets cross between projects.
  The local ledger always wins.

## 0.5.0
- **`/kickoff:security`** — a focused walk of the security baseline, one item at a time, with
  `file:line` evidence per verdict and a severity-ordered scorecard in the ledger. Composes with
  the built-in `/security-review`, dependency audits and secret scanners rather than replacing
  them. `checkup` keeps security to one line and delegates the deep pass here.

## 0.4.1
- **Web-app security baseline** (`reference/security-baseline.md`) — 15 risk→check items that
  fast-built projects get wrong most often, wired into the security dimension.

## 0.4.0
- **Worked examples** (`examples/`) — a filled 6-block spec, a coverage scorecard with ledger,
  and the config the equip step writes, so the claims are verifiable rather than aspirational.

## 0.3.9
- Descriptions refreshed to admit the plugin now writes config artifacts and analyzes security.
- **Real opt-out for the SessionStart primer**: `KICKOFF_QUIET=1` or a `.kickoff/quiet` marker.
- Discovery is untrusted-until-vetted, closing the gap with the vetting section.

## 0.3.8
- **Superpowers is declared as a prerequisite** and guarded: the planning flow now stops with
  install instructions instead of calling skills that aren't there.
- Fixed a dead `statusline.sh` reference path.

## 0.3.7
- Quality-gate config artifact (pre-commit, conventional-commit, git-safety) offered on confirmation.
- Per-dimension **coverage scorecard** in `checkup`, persisted so passes diff and show movement.
- OWASP **LLM Top 10** sub-dimension for projects that call an LLM.

## 0.3.6
- Concrete MCP discovery path (official registry + Smithery) instead of a vague "directory".
- **Vetting produces an artifact**: a scoped `.claude/settings.json` permission allowlist
  (merge, never clobber) plus an optional light `CLAUDE.md` stub.
- Node/Express, Go and Rust stack-adapter columns; convention capture on brownfield/checkup;
  full-plan preview before writing or installing anything.

## 0.3.5 and earlier
Context-usage status line; free/open-source-only stance; token/cost-efficiency dimension;
proactive activation on empty/new projects; tooling inventory before recommending.
