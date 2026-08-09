---
name: project-setup
description: Use when starting, planning, creating, or scaffolding a project, or when setting up, auditing, or strengthening an existing one — to choose the right agent tooling (Claude Code skills, plugins, MCP servers, hooks) for the detected stack, with a vet-before-install safety pass. Triggers on "new project", "set up", "get started", "what should I install", "strengthen my project". Pairs with spec-first for new projects. Not a replacement for deep analysis (see the official claude-code-setup plugin).
---

# Project setup — recommend & equip (safely)

Two entry paths.

## New project
1. Apply **spec-first** (in this kit) — pick Spec vs Spike track, write the 6-block spec before code.
2. Establish the intended stack, then equip from the baseline below.
3. Run the vetting pass before installing anything third-party.

## Existing project
1. Detect the stack: read `package.json`, `requirements.txt`, `pyproject.toml`, `go.mod`, `.git`, framework configs.
2. Recommend from the baseline below what is missing.
3. For a deeper, per-category recommendation, run the official **claude-code-setup** plugin (it analyzes the project and suggests MCP / skills / hooks / subagents / commands, read-only).
4. Vet before installing.

## House baseline (opinionated defaults)

| Signal in the project | Recommend |
|---|---|
| Any TypeScript / JavaScript | `typescript-lsp`, `context7` (fresh library docs) |
| Any Python | `pyright-lsp`, `context7` |
| Web frontend (React / Next / Vue / Svelte / Tailwind) | `web-quality-skills` (perf / CWV / a11y / SEO), official `frontend-design` |
| Needs E2E / browser tests | `playwright` |
| Telegram Mini App (grammY / initData) | a `telegram-mini-app` auth skill |
| Doc-heavy (.docx / .pdf / .pptx ingest) | `markitdown` MCP (official Microsoft) |
| Has a GitHub remote | `github` plugin |
| Running in production | `sentry` (error monitoring) |
| Any new project | `spec-first` (this kit) |
| Want deep, per-category analysis | official `claude-code-setup` |

Install a plugin with `claude plugin install <name>@<marketplace>`; add an MCP server with `claude mcp add`.

## Vet before install (always)
- Prefer **reputable authors / official** sources.
- **Skills** (markdown instructions) are lower-risk than **plugins with hooks or MCP servers** — the latter execute code / connect to real accounts. Read the hooks/scripts before enabling; give MCP servers minimal scope.
- **Don't stack overlapping skills** (e.g. several "make design better" skills fighting for the same job).
- Skip the ceremony for one-off / throwaway scripts.
