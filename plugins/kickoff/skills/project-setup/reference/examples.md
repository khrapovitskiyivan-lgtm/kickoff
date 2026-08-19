# Examples — orientation only, NOT the menu

Common defaults per dimension. **Read this last, only to sanity-check what you already chose**
— never to generate candidates. Most good recommendations are not in here; if this file is
producing your list, Step 2 didn't happen.

Free/OSS first: the vendor rows below are hosted services with free tiers, not endorsements to
put a project on a paid plan.

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
| Work that survives a long session | a **handoff note** — jot current state + decisions into the spec/ledger before context compacts | free practice |
