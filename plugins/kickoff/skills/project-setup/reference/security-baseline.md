# Web-app security baseline — risk → what to check

Concrete checklist for the **security** dimension when the project is web-facing (a login,
an API, a browser-reachable database, file uploads, payments, or paid-API calls). These are
the holes fast-built projects have most often — attackers are automated scanners hitting
every address, not targeted hackers, so "small / unknown" is not cover.

For each item: name the risk, verify the guard, demand the **file + line** where it lives.
Not exhaustive and not a substitute for a real audit.

## Access control
1. **Login brute-force** — a rate limit on auth (per IP *and* per account) with lockout / backoff. An unlimited login form gets walked overnight.
2. **Credential stuffing** — 2FA at least for admins; a sane minimum password length; and the failed-login response must NOT reveal whether the email exists (no user enumeration).
3. **IDOR / object ownership** — every endpoint that reads or mutates by id checks the record belongs to the current user, not merely that they're logged in. `/orders/4521` → `/orders/4520` must 403, not return a stranger's data.
4. **Function-level authorization** — every admin / privileged action checks the role **server-side**, not just by hiding a button in the UI. A hand-copied request must be rejected.
5. **Datastore row security (Supabase / Firebase / any browser-reachable DB)** — RLS / security rules on **every** table; no allow-all default. The anon key in the browser is by design — the table policies are the real guard. The single most common vibe-coding leak: the DB hands everything out on its own.

## Input & output
6. **SQL injection** — user input reaches the DB only via parameterized queries / ORM bindings; no string-concatenated SQL.
7. **XSS** — user-supplied text is escaped on output, never injected as HTML. Audit every `innerHTML` / `dangerouslySetInnerHTML` / raw-template sink.
8. **File upload** — type determined by content (magic bytes), not extension; files renamed on save; stored **outside** any directory the server can execute. An `avatar.png` that's really code must be neither reachable nor runnable.

## Secrets & supply chain
9. **Secret exposure** — no secrets in the client bundle (visible via page source) or in git history; `.env` in `.gitignore`. A leaked key is **rotated**, not just hidden — the old one stays valid.
10. **Dependency vulnerabilities** — run a dependency audit; flag packages with known CVEs and ones untouched for >1 year (unpatched holes).
11. **Untrusted skills / prompt injection** — vet anything before installing (kickoff's own posture: read hooks/scripts, scope MCP minimally); skills.sh flags risky skills; automode on a recent model mitigates prompt injection. Don't install-and-run blindly.

## Money & abuse
12. **Payment webhook forgery** — the payment-provider webhook verifies the signature, checks amount + currency, and is idempotent against replays. A recognizable format is not proof of payment — anyone can POST it.
13. **Race conditions** — order-sensitive operations (balance debit, promo redemption, withdrawal) are atomic: a DB transaction with row lock, or a unique idempotency key. 100 simultaneous requests must not apply 100 times.
14. **Paid-API cost abuse** — per-user daily limits on paid calls (LLM, SMS, image gen) **and** a global spend ceiling that fails closed; cost accounted per user. Otherwise one scripted loop runs your bill up overnight.
15. **CORS** — an explicit allowlist of domains, never `*`; and never any-origin together with credentials (cookies).

## How to run it (discipline)
- **Don't ask "check the project for vulnerabilities"** — the agent answers "looks fine" and is technically right. Go **one item at a time**.
- **Check each module as it's written** — the more code at once, the easier to miss something.
- **Demand the file and line** where the guard lives, or where it's missing.
- **Use a fresh session** — whoever wrote the code will defend it.
