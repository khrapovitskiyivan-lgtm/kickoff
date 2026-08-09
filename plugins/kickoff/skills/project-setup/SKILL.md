---
name: project-setup
description: Use when starting, planning, creating, or scaffolding a project, or when setting up, auditing, or strengthening an existing one — to choose the right agent tooling (Claude Code skills, plugins, MCP servers, hooks) for the detected stack, with a vet-before-install safety pass. Triggers on "new project", "set up", "get started", "what should I install", "strengthen my project". Pairs with spec-first for new projects. Not a replacement for deep analysis (see the official claude-code-setup plugin).
---

# Project setup — recommend & equip (safely)

Two entry paths.

## New project
1. Apply **spec-first** (in this kit) — pick Spec vs Spike track, write the 6-block spec before code.
2. Establish the intended stack, then equip across the dimensions below.
3. Run the vetting pass before installing anything third-party.

## Existing project
1. Detect the stack: read `package.json`, `requirements.txt`, `pyproject.toml`, `go.mod`, `.git`, framework configs, CI files, `Dockerfile`.
2. Go dimension by dimension below and recommend what is missing.
3. For a deeper, per-category pass, run the official **claude-code-setup** plugin (read-only analyzer).
4. Vet before installing.

## Baseline by project dimension (curated defaults — useful, not exhaustive)

Recommend only what fits the project. Prefer official / reputable; flag anything third-party.

| Dimension | When it applies | Recommend | Note |
|---|---|---|---|
| Code intelligence | any TS/JS or Python | `typescript-lsp` / `pyright-lsp`; `context7` for fresh library docs | official |
| Testing (E2E) | web UI / browser flows | `playwright` | official |
| Database / data | uses Supabase / Prisma / Postgres | `supabase` / `prisma` / Neon MCP (match what it uses) | vendor MCP — needs a token; give minimal scope |
| Frontend quality & design | React / Next / Vue / Svelte / Tailwind | `web-quality-skills` (perf/CWV/a11y/SEO), official `frontend-design` | reputable / official |
| Security & governance | handles auth / PII / payments | official `security-guidance`, `/security-review`; (advanced) `Strix` — signs & verifies the agent's tool-calls | Strix is third-party + niche — vet before use |
| Deployment / infra | deploys to a host | `vercel` / `railway` / `render` MCP by host; Docker / Terraform | vendor — vet / token |
| Monitoring | running in production | `sentry` | needs a DSN / auth |
| Docs / ingest | works with .docx / .pdf / .pptx | `markitdown` MCP (official Microsoft) | official |
| Version control | has a GitHub remote | `github` plugin | needs a token |
| Methodology / planning | any real (multi-module) project | `spec-first` (this kit) | ours |

Install a plugin with `claude plugin install <name>@<marketplace>`; add an MCP server with `claude mcp add`.

## Discover more (breadth without hardcoding hype)

This baseline is curated defaults, not the whole ecosystem. For the long tail:
- Browse the live directory **skills.sh** (`npx skills find "<need>"`).
- Run the official **claude-code-setup** for a deep, per-category recommendation.

Treat any social-media "top N plugins you must install" list as **leads, not gospel** — identify and vet each item first (some are niche, some are hype, some are unidentifiable).

## Vet before install (always)
- Prefer **reputable authors / official** sources.
- **Skills** (markdown instructions) are lower-risk than **plugins with hooks or MCP servers** — the latter execute code / connect to real accounts. Read the hooks/scripts before enabling; give MCP servers minimal scope.
- **Don't stack overlapping skills** (e.g. several "make design better" skills fighting for the same job).
- Skip the ceremony for one-off / throwaway scripts.
