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

## Security scorecard — what `/kickoff:security` adds

The checkup above keeps security to **one line**. Because this project is web-facing, it
delegates the deep pass, which walks the 15-item baseline one item at a time and cites
`file:line` for every verdict:

### Security scorecard 2026-08-13
| # | item | status | evidence (file:line) | severity |
|---|---|---|---|---|
| 3 | IDOR / object ownership | gap | `api/leads.py:88` — `GET /leads/{id}/matches` loads by id, no owner check | high |
| 1 | login brute-force | gap | no rate limit on the auth route (`api/auth.py`) | high |
| 14 | paid-API cost abuse | gap | matcher calls the embedding API per request, no per-user cap | med |
| 6 | SQL injection | guarded | `db/leads.py:24` — SQLAlchemy bound params throughout | — |
| 8 | file upload | n-a | project accepts no uploads | — |
| 15 | CORS | guarded | `main.py:31` — explicit origin list, no wildcard | — |

Each gap is reported with what an attacker does with it and the smallest fix that closes
it — then the whole list goes up for **one approval** before any code changes.
