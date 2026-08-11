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
  dependency vulns) · **delivery** (CI, deploy, containers) · **observability** (errors, logs,
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
2. **Actively search** when unsure: `npx skills find "<the need>"` (skills.sh), the marketplaces
   / official directory, and whatever `claude-code-setup` surfaced.
3. Use the examples table **only** as a sanity cross-check for common cases.

Name concrete tools (exact names), each tagged: *from-knowledge* / *discovered* / *example*.

## Step 3 — Vet, then recommend / install on confirmation
- Prefer **reputable / official**; treat "top-N you must install" lists as **leads, not gospel**.
- **Skills** (markdown) are lower-risk than **plugins with hooks / MCP servers** (they execute
  code / connect to accounts) — read hooks/scripts before enabling; give MCP servers minimal scope.
- **Don't stack overlapping skills.** Install only on the user's confirmation. Skip one-off scripts.

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
Never write secrets into it.

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
| Deployment / CI | `vercel` / `railway` / `render`; Docker; GitHub Actions | vendor / per host |
| Observability | `sentry` | needs DSN |
| Docs / ingest | `markitdown` MCP | official |
| Version control | `github` | needs token |
| Methodology | `spec-first` (this kit) | ours |
| Token / cost efficiency | **auto-compact** (native, free: `autoCompactEnabled` + `precomputeCompactionEnabled`), model routing by task class, subagents for heavy reads, trim unused plugins; (heavy) `headroom` proxy | mostly free settings/practices — recommend before any paid option |
