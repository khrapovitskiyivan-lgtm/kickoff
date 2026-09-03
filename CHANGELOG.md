# Changelog

Notable changes to the kickoff plugin. Newest first.

## 0.15.0 — verify-first checked the wrong thing, twice
Two findings from a live `/kickoff:checkup` run on the ЧПУ project, neither of them from a review.

- **Existence is not the promise.** The rule collected the paths an `installed` entry named and
  checked they were there. An empty git repository passes "does `.git` exist" while the entry that
  bought it — history to roll back to — is worth nothing. The check now asks what the entry was
  *for* and tests that: `git log -1` for history, a run for a test setup, the content for a config.
  Where only existence is checkable the verdict is `verified (exists)` — weaker out loud rather than
  silently rounded up, the same shape as `unverified` in the security scorecard.
- **`open` decays too.** The rule verified `installed` entries and passed every `open` one straight
  through to "still open". The ledger is append-only, so a later dated entry may have installed,
  declined or cancelled an item while the earlier line still reads `open` (seen on ЧПУ with the
  cancelled SPIKE-1/2). Now the **latest mention of an item wins**, and a stale `open` is dropped
  rather than re-proposed as work.
- `reference/example-checkup.md` gains the verify-first pass it never showed — the worked example
  had a scorecard and a ledger entry but no batch check, which is the step models copy.
- `README.md` said a recorded item "gets checked for still being there"; replaced, same defect.

## 0.14.4 — the checker was the defect
A meta-review found `scripts/check.sh` printing ALL CHECKS PASSED while four broken references
shipped. It had caught **0 of the 9** defects this changelog records, and it was credited four
times with owning a class it never covered. The cause: its regex matched only backticked paths
beginning `reference/` or `scripts/`, so markdown links were invisible and **no file under
`commands/` was ever examined**.

- Extractor rewritten in python (the sed escaping was where the original went wrong, and a mangled
  extractor fails silently, which is the whole bug). It now scans both the markdown-link and the
  backtick form, skips paths that name a file in the *user's* project at runtime, and resolves each
  reference from the citing file's directory and from the plugin root. Coverage went 9 refs to 16.
- **Coverage assertion**, per directory: a check that silently matches nothing is indistinguishable
  from a passing check. Not per file - `checkup.md` and `start.md` legitimately cite only
  `.kickoff/notes.md` and `CLAUDE.md`, so "every file has a reference" is a false invariant; the
  first draft of this assertion asserted it and had to be corrected.
- **Proven to fail before being trusted.** Three seeded defects (a dead markdown link, a dead
  backticked path, a deliberately broken extractor) each produce a FAIL; reverted, green again. A
  check never observed failing is not a check.
- Four dead references and a stale count fixed: `example-checkup.md` pointed at a file that never
  existed and still said "15-item" after 0.9.0 made it 28; `example-equip.md` pointed at a renamed
  file; `commands/security.md` carried a path unresolvable from `commands/`; `stack-adapters.md`
  named `security-baseline.md` with no navigable path to another skill.
- `unverified` added to the scorecard schema in `commands/security.md`. The prose has mandated that
  status since 0.11.2 while the table offered only guarded/gap/n-a, so the one honest verdict had
  nowhere to go and would round up to `guarded`.

Nothing was added in this release. Per the rule adopted here: a correction may only delete or
replace. 0.14.3 broke that rule while fixing a claim, which is how it shipped two unverified ones.

## 0.14.3 — two claims that pretended to be safety
A follow-up review checked 0.14.2's replacement text against the live documentation, and found the
fix had swapped one wrong claim for another. Both corrections below are sourced, not composed.

- **The verification step was fabricated.** 0.14.2 said to check `/permissions` to see what is
  actually in effect. `/permissions` lists rules and the file each came from; it says nothing about
  whether a rule is consulted. And the host *does* warn about inert rules - a path rule written for
  `Write`, `Glob`, `NotebookEdit` or `MultiEdit` is accepted, never consulted, and reported at
  startup and by `claude doctor`. That is where to look. Presenting a non-check as the safety net was
  worse than the bug it replaced. Added while correcting it: **the sandbox** is the only OS-level
  answer to the subprocess hole the same paragraph identifies, and it merges existing deny rules
  into its boundary rather than replacing them; and a settings file silently skips any `mcp__` rule
  containing parentheses, so an MCP tool cannot be path-scoped there.
- **A budget alert is not a fail-safe.** Item 25 called a provider-side alert "the real fail-safe
  because it lives outside your code". Alerts notify; they do not stop spending, and they lag usage.
  The real ceilings are a prepaid balance with auto-recharge off and the provider's hard spend limit.
  Rewritten to those, plus: require auth before any paid call, cap per-user calls and `max_tokens`,
  cache repeats. This was the only place in the checklist naming a non-control as the fail-safe, and
  it guarded the failure most likely to end a solo project.

## 0.14.2 — remove advice that was wrong
An adversarial review checked the deny baseline against the host's own documentation. Three things
had to go, because wrong security advice is worse than none: a user who accepts a guard believes
they are covered.

- **The debugging write-freeze is deleted.** It was inert twice over: permission patterns have no
  negation, and a path rule written for `Write` is accepted and then never consulted (the matching
  name is `Edit`). It was offered at the exact moment someone is debugging and relying on it. The
  hedge it shipped with, "per the host's pattern syntax", was an admission it had not been verified.
- **`Bash(curl * | bash)` is deleted.** A command is split on `|` before matching, so the pipe in
  the pattern is a literal and the rule can never match anything.
- **"Explore searches and cannot write" is deleted.** A tool set that still contains `Bash` can write
  through a shell redirect. Verify a built-in's actual tool list rather than assuming.

In their place the guide now states what this layer really reaches: path denies are solid, **Bash
rules that constrain arguments are fragile** (the host documents the bypasses), denies do not reach
an arbitrary subprocess or an MCP file server, and `/permissions` should be checked afterwards
because a rule that is accepted but never consulted looks exactly like one that works. The old
closing line, "anything expensive to lose belongs here, not in prose", was the false-confidence
generator and is gone.

*(The `/permissions` advice in the paragraph above was itself wrong and was corrected in 0.14.3:
inert rules surface at startup and in `claude doctor`, not in `/permissions`.)*

## 0.14.1
- Step 4's artifact catalogue moved to `reference/equip-artifacts-guide.md`, leaving one line per
  artifact in the skill. `project-setup/SKILL.md` had grown from 153 lines to 262 as each artifact
  arrived, and a prompt-engineering review had already named density (not length) as its real
  problem: the most important instruction in the file, the dimension sweep, was competing with
  everything added after it. Now 190 lines, with the failure modes that matter - which settings file
  is committed, which allow entries are arbitrary execution in disguise, why a hook needs an explicit
  timeout - a read away rather than always resident. Same treatment already applied to the examples
  table and the design tells.

## 0.14.0 — the other half of the enforcement layer
0.12.0 took permissions and called the enforcement layer done. It wasn't: **hooks** are the other
half, and kickoff ships a SessionStart hook of its own while never telling a project how to write
one. Step 4 now offers them, with the moments that matter (`PreToolUse` can block an action) and
the two failures that look like a broken hook: no explicit `timeout` stalls the agent, and a bare
relative script path is not found because a hook does not necessarily run from the project root.
Also: a `SessionStart` hook without a `matcher` re-fires on resume and on every compaction, which
is a lesson from our own 0.10.0.

- **`.mcp.json`**: recommending an MCP server never said where it lands. The project-root file is
  the committed, shared one; anything else is personal. No tokens in it, ever.
- **Precedence**: "my rule isn't applying" is usually a shadowed rule, not a broken one. The audit
  now names the order, including the fact that a personal `settings.local.json` quietly overrides
  the committed team file, and that the nearest `CLAUDE.md` wins.

## 0.13.1
- Subagent definitions were a blind spot: kickoff *used* read-only subagents in two places but never
  said how to define one, and the `.claude/` audit added in 0.12.0 checked settings and CLAUDE.md
  while ignoring `agents/`. Step 4 now offers an agent definition where a role genuinely repeats,
  and treats `tools:` as what it is — a boundary, the same enforcement layer as the deny list,
  scoped to a helper. Equal weight goes to when *not* to define one: a two-minute task costs more to
  hand over than to do, a helper cannot see the conversation so far, and the built-in `Explore` and
  `Plan` already cover most "I need a reader" cases. The audit now flags definitions that duplicate
  each other or the built-ins, and any whose tool list is wider than its job.

## 0.13.0 — auditing generated design
A page can pass performance, accessibility and SEO and still read as machine-made. New
`reference/ai-design-tells.md`, wired into the frontend-quality dimension for marketing surfaces
(landing pages, storefronts, prototypes — explicitly not dashboards or product UI, where several
of these patterns are legitimate).

The useful part is that most of it is **countable**: em-dashes used as decoration, middle-dot
separator chains, numbered step labels, section-number eyebrows, pure black, three equal feature
cards, perfect round numbers. Each ships with the grep that finds it, so the audit is evidence
rather than taste. A short second list covers what no grep will settle — div-built fake product UI
in a hero being the loudest of them.

Distilled from the AI-Tells catalogue in `Leonxlnx/taste-skill` (MIT) after vetting it as a whole:
the 87 KB skill was not worth installing and would have needed a local fork to be safe, but the
checklist inside it was. Validated by running it against a real storefront page, which turned up 177
decorative em-dashes and 44 lines of stacked separators.

## 0.12.1
- Deny baseline gains a **temporary freeze**: while debugging one thing, deny writes outside that
  directory, so a fix doesn't quietly touch six other files. Offered as a session measure with an
  explicit note to lift it afterwards. Borrowed from vetting another toolkit whose `/freeze` command
  was the one idea in it we didn't already have.

## 0.12.0 — the enforcement half
Prompted by a course module on how a Claude Code environment is actually built. Its central point
lands squarely on this plugin: **text is a request the model can lose track of; a setting is a rule
the program enforces before the model acts.** kickoff lived entirely in the first layer.
- **Deny baseline.** Step 4 only ever *widened* what runs unasked. It now offers `permissions.deny`
  first — secrets, irreversible git, destructive shell, and whatever this project would most regret
  losing. Denials are written once and hold; allows accrete. Rules resolve deny → ask → allow, so a
  broad deny cannot be argued around.
- **Scoped rules.** `.claude/rules/*.md` with `paths:` frontmatter load only when the agent opens a
  matching file — the right home for a convention that is real but local, and would otherwise bloat
  an always-resident `CLAUDE.md`. kickoff ignored this mechanism entirely.
- **The project's `.claude/` is now an audited dimension.** We swept fourteen dimensions of a
  project and never looked at the environment we exist to equip. It fails quietly: a trailing comma
  stops a settings file applying and nobody is told; one wildcard `allow` undoes every narrower rule;
  a `CLAUDE.md` past ~200 lines is followed worse, not better.

## 0.11.2
- **Absence needs more proof than presence.** A gap could be declared on one empty grep, which
  proves you looked — not that the guard is missing. Found by dogfooding: a rate limiter was
  reported as a gap because it was spelled in the project's own words and the search used the
  security term. Now a gap requires at least two independent wordings *and* reading the code path
  it would live in; otherwise the status is `unverified`. A false gap carrying a citation is worse
  than a guess — it reads as audited.

## 0.11.1
- `scripts/check.sh` now compares the installed plugin's version against this repo's. The two are
  independent — installing copies the files into a versioned cache — so editing here changes
  nothing in any session until `claude plugin update` runs. That gap went unnoticed for five
  releases: every session kept running the 0.3.5 build while the fixes sat in git. Verify, don't
  trust, pointed at ourselves.

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
