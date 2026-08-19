# Example spec — Leads intake (FastAPI / Python)

A filled instance of the 6-block skeleton (`spec-first` → `templates.md`),
stack-translated via the Python/FastAPI column of `stack-adapters.md`.
Track: **Spec** (all six blocks fillable without guessing).

## Module: leads-intake

### User Stories
- As a **website visitor**, I submit my contact details so that a sales rep can reach me.
- As a **sales rep**, I get each new lead matched to the 5 most relevant products so that I can prepare before calling.

### Data Model
`Lead` (SQLAlchemy + Pydantic): `id: UUID`, `name: str`, `phone: str (E.164)`,
`email: str | None`, `note: str | None`, `created_at: datetime`,
`status: Enum(new|contacted|dropped)`. Permissions at the service layer (no public writes
outside the endpoint). PII (`phone`, `email`) never logged in plaintext.

### Interface Contract
- `POST /leads` — in: `LeadCreate{name, phone, email?, note?}`; out: `201 LeadRead{id, status}`;
  errors: `422` (validation), `429` (rate limit).
- `GET /leads/{id}/matches` — out: `200 [ProductMatch{product_id, score}]` (≤5, desc);
  errors: `404`.

### Screens / entry points
- Public web form → `POST /leads`. Internal rep dashboard → `GET /leads/{id}/matches`.
- No auth on create (public); dashboard behind session auth middleware.

### Business Logic
- Normalize `phone` to E.164; reject non-parseable (422).
- On create: persist, then enqueue a match job (Celery) — never block the request on matching.
- Matcher returns top-5 products by cosine similarity over the product embedding index.

### Edge Cases
- Missing/invalid `phone` → 422 with a field-level error.
- Duplicate submit (same phone within 10 min) → 201 but no second match job (idempotent).
- Matcher index cold/unavailable → `GET matches` returns `200 []`, not 500; job retried.
- Burst from one IP → 429 after N/min.

### Security / abuse
- `POST /leads` is public by design; `GET /leads/{id}/matches` is **session-authenticated and
  rep-scoped** — enforced in the service layer, not the handler, and it returns **404** for a lead
  outside the caller's scope (403 would confirm the id exists).
- Untrusted input reaching the server: the four `LeadCreate` fields. Bound by Pydantic; `note` is
  escaped on render and never interpolated into HTML or SQL.
- Cost of abuse: `POST /leads` is unauthenticated, so it is the DoS and spam surface — per-IP rate
  limit (429) plus a per-day cap on enqueued match jobs, since each job costs an embedding call.
- PII (`phone`, `email`) is never written to logs or error payloads, including the tracker's
  breadcrumbs.

### Acceptance / observable-done
- `POST /leads` with a valid payload returns `201` and the row exists in `leads`.
- `POST /leads` with a missing `phone` returns `422` with a field-level error.
- Matcher **precision@5 ≥ 0.85** on holdout set `bench/leads-2026`.
- No plaintext `phone`/`email` appears in application logs (grep check in CI).
