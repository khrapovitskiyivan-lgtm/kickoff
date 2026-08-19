---
name: project-setup
description: Use when starting, planning, or scaffolding a project, or setting up / auditing / strengthening an existing one — analyze what the project actually needs across every dimension (code intelligence, testing, data, frontend quality, security, delivery, observability, performance, i18n, background jobs, docs, collaboration), then recommend the best-fit tooling from the whole ecosystem and vet it. The built-in examples are orientation, not a menu. Triggers on "new project", "set up", "get started", "what should I install", "strengthen my project".
---

# Project setup — analyze needs, discover the right tools, then equip (safely)

Recommend what **this** project actually needs. **Derive every recommendation from a
needs analysis + your own current knowledge of the whole ecosystem — never just copy a
fixed list.** The examples table at the bottom is orientation, NOT the menu; most good
recommendations will NOT be in it.

**Cold start (just an idea — no stack yet):** do NOT recommend tooling. Shape the idea and
**choose the stack** via `superpowers:brainstorming`, then `spec-first`. Tooling applies
only once a stack exists.

## Step 1 — Analyze needs across EVERY dimension (no skipping)

**First, inventory what already exists — never duplicate it.** Run `claude plugin list`
and `claude mcp list` (installed plugins / MCP servers), note the available skills, read the
project's dependencies (`package.json` / `requirements.txt` / etc.), and read the ledger. If a
need is already met by an installed tool or an existing dependency, mark it "already covered"
and do NOT re-recommend it.

Read the code/config (`package.json`, `requirements.txt`, `pyproject.toml`, `go.mod`,
`.git`, CI files, `Dockerfile`, tests). Then walk **each** dimension and state the concrete
need or gap — even if the answer is "already covered" or "n/a". Cover at least:

- **code intelligence** · **testing** (unit + E2E + contract) · **data / DB access** ·
  **frontend quality** (perf / CWV / a11y / SEO) · **security & privacy** (auth, PII, secrets,
  dependency vulns; **web-facing app** → walk the concrete `reference/security-baseline.md`
  — auth/brute-force, IDOR, server-side authz, datastore RLS, injection, file uploads, secret
  exposure, webhook forgery, race conditions, paid-API cost, CORS; **if it calls an LLM /
  handles prompts** → OWASP **LLM Top 10**: prompt injection, secret/PII leakage into prompts,
  unsafe LLM-output handling) · **delivery** (CI, deploy, containers) · **observability** (errors, logs,
  metrics) · **performance** (caching, rate limiting) · **background work** (jobs, queues, cron)
  · **i18n** · **docs / ingest** · **collaboration** (PR / issues) · **token / cost efficiency**
  (auto-compact, model routing by task class, subagents for heavy reads) · **+ anything the project implies**.

Name **real gaps beyond the obvious stack tools** (rate limiting? i18n? CI? queues? caching?
secret scanning?). For a deep, per-category analysis, **run the official `claude-code-setup`**
if it's available (offer to install it if not) and fold its findings in.

## Step 2 — For EACH gap, find the best-fit tool from ANYWHERE

**Do NOT default to the examples table.** For each need, in this order:
1. **Reason from your full, current knowledge** of the ecosystem. The right answer is often an
   npm/pip **library**, an **MCP server**, or a **community skill** that is in none of our lists.
   You are not limited to Claude Code plugins — name the tool that actually fits.
2. **Actively search** when unsure — name the concrete discovery path per tool kind:
   - **skills / plugins**: `npx skills find "<the need>"` (skills.sh), the plugin marketplaces, and whatever `claude-code-setup` surfaced.
   - **MCP servers**: search a real registry, not a vague "directory" — the official MCP registry and **Smithery** (`smithery.ai`) as leads; if an in-session MCP-registry search / connector-suggest tool is available, use it. Then vet scope (Step 3).
   - **libraries**: the language's package index (npm / PyPI / crates.io / pkg.go.dev), filtered to maintained, reputable packages.
   - Everything surfaced this way is **untrusted until vetted** — `claude-code-setup` and any discovered plugin included. Read a skill's hooks/scripts and scope an MCP *before* it runs; install nothing without the Step 3 confirmation gate.
3. Use the examples table **only** as a sanity cross-check for common cases.

Name concrete tools (exact names), each tagged: *from-knowledge* / *discovered* / *example*.

## Step 3 — Vet, then recommend / install on confirmation
- **Prefer free / open-source. Do NOT recommend paid plans or paid products** — where a service is genuinely needed, use its free tier only.
- Prefer **reputable / official**; treat "top-N you must install" lists as **leads, not gospel**.
- **Skills** (markdown) are lower-risk than **plugins with hooks / MCP servers** (they execute
  code / connect to accounts) — read hooks/scripts before enabling; give MCP servers minimal scope.
- **Don't stack overlapping skills.** Install only on the user's confirmation. Skip one-off scripts.
- **Preview before acting.** Before writing or installing anything, present the full proposed plan
  — the spec/tooling list, each item tagged by risk (skill vs code-executing hook/MCP) — and get one approval.

## Step 4 — Turn the vet into a durable artifact (optional, on confirmation)

Vetting that leaves no trace evaporates. Once the user confirms what to equip, **offer** to
crystallize the vet — never write silently, never overwrite:
- **Permission allowlist (primary).** Write / extend `.claude/settings.json` with a scoped
  `permissions.allow` list for exactly the vetted tools and their commands — approved tooling then
  runs without re-prompting, and nothing else is implicitly trusted. **Merge** into any existing
  file; never clobber it. This is the natural *output* of the vet, not code scaffolding.
- **CLAUDE.md stub (light, only if wanted).** Only when the project lacks one and the user asks:
  a short stub (stack + key conventions). Keep it minimal — `/init` owns full project docs; do
  **not** overwrite an existing `CLAUDE.md`.
- **Quality-gate config (optional).** Offer a vetted, stack-appropriate **pre-commit gate**
  (lint + typecheck + test), a **conventional-commit** check, and **git-safety** guardrails
  (block force-push to `main`, block `--no-verify`). Emit config only — the enforcement layer is
  the natural sibling of the allowlist, not code scaffolding. Match the stack's own tool (husky +
  lint-staged / pre-commit / lefthook); **merge**, don't clobber; tag each line by risk.

Write nothing without an explicit yes. Record what was written in the ledger.

## Track the process — the ledger

Keep a per-project ledger at `.kickoff/notes.md` so recommendations don't repeat and progress is visible.
- **Before** a pass: read it. Skip anything `installed` or `declined`; surface still-`open` items; re-surface a `declined` item if its reason no longer holds.
- **After** a pass: append a dated entry (create the file on first pass). Format:
  ```
  ## <YYYY-MM-DD>
  - installed: <tool> (<dimension>)
  - open: <tool> (<dimension>) — <why>
  - declined: <tool> — <reason>
  ```
- **Coverage scorecard** (record on a checkup): a compact per-dimension snapshot so successive
  passes show movement — the next checkup diffs against the last one:
  ```
  ### Scorecard <YYYY-MM-DD>
  | dimension | status (covered/gap/n-a) | tool | priority |
  |---|---|---|---|
  | testing | gap | vitest | high |
  ```
Never write secrets into it.

### Sibling roll-up — reuse what you already decided next door (optional)

Decisions made in one project should not be re-litigated from scratch in the next. **Before**
recommending, optionally skim the ledgers of sibling projects to prime this pass:

- **Scope.** Sibling directories of the current project root (same parent folder) that contain
  a `.kickoff/notes.md`. Read **only that file**, read-only — never other project files, never
  outside the parent folder. Skip silently if there are none.
- **Extract decisions ONLY.** Take the *tooling verdicts*: tool name · dimension ·
  installed / declined / open · the one-line reason. Ledgers are free-form prose and often
  hold project content — business, legal, personal, or client detail. **None of that crosses
  over.** Never copy prose, findings, or context from another project into this session; if a
  reason can't be stated in one neutral clause about the tool, drop it.
- **Use it as a prior, not a verdict.** Surface it as a lead: *"in sibling X you vetted and
  chose Y for this need — reuse it here?"* or *"you declined Z twice for <tool reason>; still
  wanted?"* A different project may legitimately need a different answer.
- **This project's own ledger always wins.** A local `installed`/`declined` entry is never
  overridden by a sibling's.

Skip the roll-up when it would be noise (a one-off script, or an unrelated project type).

## Examples — orientation only, NOT the menu

A few common defaults per dimension. **Not exhaustive; most recommendations should come from
Step 2, not here.**

| Dimension | Common example | Note |
|---|---|---|
| Code intelligence | `typescript-lsp` / `pyright-lsp`; `context7` | official |
| Testing (E2E) | `playwright` (browser); for headless APIs prefer contract/HTTP tools (e.g. Supertest, Schemathesis) | discover per project |
| Database | `supabase` / `prisma` / Neon MCP | vendor — token |
| Frontend quality | `web-quality-skills`, `frontend-design` | reputable |
| Security | `security-guidance`, `/security-review`; secret scanning (gitleaks); dep audit | discover per project |
| Security (AI/LLM) | `security-guidance`, `/security-review` against OWASP LLM Top 10 (prompt injection, prompt leakage, unsafe output) | only if it calls an LLM |
| Deployment / CI | `vercel` / `railway` / `render`; Docker; GitHub Actions | vendor / per host |
| Observability | `sentry` | needs DSN |
| Docs / ingest | `markitdown` MCP | official |
| Version control | `github` | needs token |
| Methodology | `spec-first` (this kit) | ours |
| Token / cost efficiency | **auto-compact** (native, free: `autoCompactEnabled` + `precomputeCompactionEnabled`), a **context-usage status line** with a near-limit `/clear` hint (the plugin's `reference/statusline.sh`, i.e. `../../reference/statusline.sh` from here), model routing by task class, subagents for heavy reads, trim unused plugins | all free native settings / practices |
