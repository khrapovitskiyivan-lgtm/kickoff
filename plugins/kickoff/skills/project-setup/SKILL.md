---
name: project-setup
description: Use when starting, planning, or scaffolding a project, or setting up / auditing / strengthening an existing one — analyze what the project actually needs across every dimension (code intelligence, testing, data, frontend quality, security, delivery, monitoring, docs, collaboration), then recommend and vet the right agent tooling. Use a curated baseline as a fast prior but actively discover beyond it via skills.sh and the official claude-code-setup. Triggers on "new project", "set up", "get started", "what should I install", "strengthen my project".
---

# Project setup — analyze needs first, then equip (safely)

Goal: recommend what **this** project actually needs — discovered by analysis, **not
limited to a fixed list**. The baseline below is a fast starting prior, NOT a ceiling.
When a need isn't in it, go find the right tool.

**Cold start (just an idea — no stack or code yet):** do NOT recommend stack-specific
tooling. First shape the idea and **choose the stack** via `superpowers:brainstorming`,
then `spec-first`. This skill's tooling recommendations apply only once a stack exists.

## Step 1 — Analyze the project's real needs (not just its stack)

Read the code and config (`package.json`, `requirements.txt`, `pyproject.toml`,
`go.mod`, `.git`, framework configs, CI files, `Dockerfile`, tests dir). Then name the
concrete **gaps** across these dimensions — the actual needs, e.g.:

- **Code intelligence** — language-server / type support present? fresh library docs?
- **Testing** — any tests? E2E for the UI? coverage on critical logic?
- **Data** — how does it talk to its DB? migrations? typed access?
- **Frontend quality** — perf / Core Web Vitals / a11y for a user-facing UI?
- **Security** — handles auth / PII / payments? any review in place?
- **Delivery** — CI? a deploy target? containerization?
- **Observability** — error monitoring in production?
- **Docs / ingest** — needs to read external documents (.docx/.pdf/…)?
- **Collaboration** — PR / issue workflow?

For a **deep, per-category analysis of an existing codebase, run the official
`claude-code-setup`** (the specialized read-only analyzer) and fold its findings in —
don't reinvent it here.

## Step 2 — For each identified need, find the best-fit tooling

1. Check the **baseline** below — a fast, already-vetted prior.
2. If the need isn't covered there, **actively discover — do NOT stop at this list**:
   - search the live directory: `npx skills find "<the need>"` (skills.sh),
   - check marketplaces / the official plugin directory,
   - use your own current knowledge of the ecosystem,
   - and surface what `claude-code-setup` recommends.
3. The right answer is **whatever fits the analyzed need**, from anywhere — the baseline
   is just the shortcut for common cases.

## Baseline (fast prior for common needs — not exhaustive)

| Dimension | When it applies | Common default | Note |
|---|---|---|---|
| Code intelligence | any TS/JS or Python | `typescript-lsp` / `pyright-lsp`; `context7` | official |
| Testing (E2E) | web UI / browser flows | `playwright` | official |
| Database / data | Supabase / Prisma / Postgres | `supabase` / `prisma` / Neon MCP | vendor MCP — token, minimal scope |
| Frontend quality & design | React/Next/Vue/Svelte/Tailwind | `web-quality-skills`, official `frontend-design` | reputable / official |
| Security & governance | auth / PII / payments | `security-guidance`, `/security-review`; (adv.) `Strix` | Strix third-party + niche — vet |
| Deployment / infra | deploys to a host | `vercel` / `railway` / `render` MCP; Docker / Terraform | vendor — vet / token |
| Monitoring | in production | `sentry` | needs a DSN / auth |
| Docs / ingest | .docx / .pdf / .pptx | `markitdown` MCP (official Microsoft) | official |
| Version control | GitHub remote | `github` | needs a token |
| Methodology | multi-module project | `spec-first` (this kit) | ours |

## Step 3 — Vet, then recommend / install
- Prefer **reputable authors / official** sources; treat "top-N you must install" lists as **leads, not gospel** — identify and vet each item.
- **Skills** (markdown) are lower-risk than **plugins with hooks / MCP servers** (they execute code / connect to real accounts). Read hooks/scripts before enabling; give MCP servers minimal scope.
- **Don't stack overlapping skills.**
- Install on the user's confirmation — never silently. Skip the ceremony for one-off / throwaway scripts.

## Track the process — the ledger

Keep a per-project ledger at `.kickoff/notes.md` so recommendations don't repeat and progress is visible over time.
- **Before** a pass: read it. Skip anything marked `installed` or `declined`; surface still-`open` items.
- **After** a pass: append a dated entry. Create the file on the first pass.
- Format:
  ```
  ## <YYYY-MM-DD>
  - installed: <tool> (<dimension>)
  - open: <tool> (<dimension>) — <why it's worth adding>
  - declined: <tool> — <reason>
  ```
It's a plain note — safe to commit (team-visible history) or gitignore (personal). Never write secrets into it.
