# Example checkup — Leads intake

What `/kickoff:checkup` reports for the module in [`leads-intake-spec.md`](leads-intake-spec.md):
a per-dimension **coverage scorecard**, then the **ledger** entry it appends. The next
checkup diffs against this scorecard to show movement.

## Coverage scorecard

### Scorecard 2026-08-13
| dimension | status | tool | priority |
|---|---|---|---|
| code intelligence | covered | pyright-lsp | — |
| testing (unit) | covered | pytest | — |
| testing (E2E/contract) | gap | schemathesis (OpenAPI) | med |
| data / DB access | covered | SQLAlchemy | — |
| frontend quality | n-a | — (API only) | — |
| security & privacy | gap | gitleaks + PII log-scrub | high |
| security (AI/LLM) | n-a | — (no LLM call) | — |
| delivery (CI) | gap | GitHub Actions | high |
| observability | gap | sentry (needs DSN) | med |
| performance (rate limit) | gap | slowapi | med |
| background work | covered | celery | — |
| i18n | n-a | — | — |
| docs / ingest | covered | mkdocs | — |
| collaboration | covered | github | — |
| token / cost efficiency | covered | auto-compact + statusline | — |

Top priorities: **CI**, **secret scanning + PII log-scrub**, then rate limiting.

## Ledger — `.kickoff/notes.md`

```
## 2026-08-13
- installed: gitleaks (security & privacy)
- open: github-actions (delivery) — no CI yet; blocks the acceptance grep check
- open: slowapi (performance) — 429 path in spec has no enforcement
- declined: sentry (observability) — no DSN / not self-hosting yet; revisit at launch
```

A later checkup won't re-suggest gitleaks (installed) or sentry (declined, reason unchanged),
and will re-surface sentry only once a DSN exists.
