# Web-app security baseline — risk → what to check

Concrete checklist for the **security** dimension when the project is web-facing (a login,
an API, a browser-reachable database, file uploads, payments, or paid-API calls). These are
the holes fast-built projects have most often — attackers are automated scanners hitting
every address, not targeted hackers, so "small / unknown" is not cover.

For each item: name the risk, verify the guard, demand the **file + line** where it lives.

**A full scorecard is not an audit.** These 28 items are the common failures, not the field — a
project can pass every one and still be broken through a path nobody here anticipated. Report what
was *examined*; never let "28/28" read as "secure". Anything outside this list that the project's
shape implies is still your job to raise.

## Identity & access control
1. **Password storage** — hashed with **argon2id / bcrypt / scrypt**, never MD5/SHA-1/plaintext/homemade. This outranks everything else here: a breach with weak hashes hands over every account.
2. **Sessions & tokens** — cookies `HttpOnly` + `Secure` + `SameSite`; session rotated on login/privilege change and invalidated on logout. JWTs: verified algorithm (reject `alg:none` and HS/RS confusion), real expiry, a revocation story; not parked in `localStorage` where XSS reads them.
3. **Login brute-force** — rate limit auth **and** the password-reset / OTP / magic-link routes; prefer backoff + CAPTCHA over hard lockout (lockout is its own DoS). Per-IP limits built on `X-Forwarded-For` are bypassable unless trusted proxies are pinned, and useless against residential-proxy stuffing — pair with per-account limits.
4. **Credential stuffing** — 2FA at least for admins; check new passwords against a breach corpus (HIBP k-anonymity) instead of trusting length rules. No user enumeration — the same response and *timing* on login, **registration**, and **password reset** alike.
5. **IDOR / object ownership** — every endpoint that reads or mutates by id checks the record belongs to the caller, not merely that they're logged in. Prefer **404 over 403** for objects outside their visibility (403 confirms existence). Covers writes and client-supplied foreign keys too.
6. **Function-level authorization** — privileged actions check the role **server-side**; hiding the button is not a guard. Prefer **deny-by-default at the router/middleware layer** over per-handler opt-in. Never trust a role claim the client can set.
7. **CSRF** — any cookie-authenticated state-changing request needs anti-CSRF tokens or strict `SameSite`. (Token-in-header APIs are largely exempt; cookie sessions are not.)
8. **Datastore row security (Supabase / Firebase / any browser-reachable DB)** — RLS / security rules on **every** table; no allow-all default. The anon key in the browser is by design — **the `service_role` key must never reach it** (`NEXT_PUBLIC_*` or a client-reachable route bypasses RLS entirely). Policies do nothing without `ENABLE ROW LEVEL SECURITY`; mind `SECURITY DEFINER` functions and Storage buckets, which have their own policies.
9. **Multi-tenancy** — every query scoped by `tenant_id`, cache keys included. IDOR checks alone don't give tenant isolation.

## Input & output
10. **SQL / NoSQL injection** — parameterized queries or ORM bindings only; no string-concatenated SQL. Watch the raw escape hatches (`$queryRawUnsafe`, `text()`, `.raw()`), identifiers (`ORDER BY`, column names — parameters don't cover these, use an allowlist), and Mongo operator injection from JSON bodies (`$where`, `$ne`).
11. **Command injection & path traversal** — no user input into `exec` / `subprocess(shell=True)`; no user-controlled path into file reads/writes. Very common in fast-written glue code.
12. **XSS** — escape on output; **sanitize** (DOMPurify et al.) wherever user HTML/markdown must render — escaping is the wrong tool there. Audit `innerHTML`, `dangerouslySetInnerHTML`, `v-html`, `srcdoc`, `javascript:` hrefs, `bypassSecurityTrust*`. **CSP** is the containment layer when one slips through.
13. **Mass assignment** — never hand a request body straight to a model update (`update(req.body)`, object spread, models accepting extra fields): that's how `is_admin: true` arrives. Bind an explicit field allowlist.
14. **File upload** — type from **content**, not extension; but magic-byte sniffing alone is not enough: polyglots pass, and **SVG is stored XSS** when served from your origin. Rename on save, cap size (zip bombs, disk fill), store **outside** any executable path, and serve from a separate origin or with `Content-Disposition: attachment` + `X-Content-Type-Options: nosniff`. Never reflect the user's filename. For presigned S3-style uploads, bind content-type and length and keep the ACL private.
15. **SSRF** — anywhere the server fetches a user-supplied URL (image-by-URL, webhooks, "import from link", LLM browse tools): allowlist destinations and block internal ranges, above all the cloud metadata endpoint `169.254.169.254`, which hands over instance credentials.
16. **Open redirect** — validate `?next=` / `returnUrl` against an allowlist; it powers phishing and OAuth token theft.

## Exposure, secrets & supply chain
17. **Secret exposure** — the specific footgun: `NEXT_PUBLIC_` / `VITE_` / `REACT_APP_` / `EXPO_PUBLIC_` inline the value into the browser bundle. Also: secrets in logs, error payloads and error-tracker breadcrumbs; in container images and CI output; in published source maps. `.gitignore` is not retroactive — a key already committed stays in history. A leaked key is **rotated**, not hidden: the old one still works.
18. **Debug mode & exposed surfaces** — this is what the drive-by scanners check first: `DEBUG=True` in production (leaks settings and secrets), stack traces to users, and reachable `/admin`, Swagger UI, `.git/`, `.env`, actuator endpoints, open DB ports, public buckets.
19. **Security headers & transport** — HTTPS only + HSTS; **CSP**; `X-Content-Type-Options: nosniff`; `frame-ancestors` (clickjacking); `Referrer-Policy`. Never disable certificate validation (`rejectUnauthorized: false`, `verify=False`).
20. **Dependency vulnerabilities** — run a real audit (`npm audit`, `pip-audit`, `govulncheck`) against known CVEs. **Age is not the signal** — plenty of good libraries are simply finished, while *recent* commits are exactly what a hijacked package shows. Verify a package **exists and is the one you mean** before installing: typosquats and LLM-hallucinated names are pre-registered by attackers. Commit the lockfile; know that install-time `postinstall` scripts execute; `npm audit fix --force` performs breaking bumps.
21. **Untrusted skills, MCP servers & prompt injection** — read hooks/scripts before enabling, give MCP servers minimal scope, prefer human confirmation on side-effectful actions, and keep untrusted content out of privileged context. **No model setting makes prompt injection safe** — treat claims of that kind as marketing; least privilege is the control. For an app that calls an LLM, this extends to *indirect* injection through retrieved documents and tool output, unsafe handling of LLM output (into SQL, shell, or HTML), and the confused deputy: the model's tools carry the caller's privileges.

## Money & abuse
22. **Payment webhook forgery** — verify the signature **over the raw request body** (a JSON body-parser ahead of it breaks verification, and the usual "fix" is disabling the check), with a timestamp tolerance against replay, constant-time comparison, and idempotency. Check amount, currency and `livemode`; better still, re-fetch the event from the provider instead of trusting the payload. And never grant entitlement from the **client-side success redirect** — that's the most common bypass of all.
23. **Client-trusted business logic** — price, quantity, discount and totals come from the server, never the request body. Reject negative quantities and stacked coupons.
24. **Race conditions** — for check-then-act on money (balance debit, promo redemption, withdrawal) a transaction alone is not enough at READ COMMITTED: use `SELECT … FOR UPDATE`, a DB constraint, or SERIALIZABLE + retry. Idempotency keys solve a *different* problem (duplicate submissions) — you often need both.
25. **Paid-API cost abuse** — per-user daily caps on paid calls (LLM, SMS, image gen) plus a **provider-side budget alert**, which is the real fail-safe because it lives outside your code. Note the trade-off before shipping a global fail-closed ceiling: one abuser can burn it and deny everyone.
26. **Insecure deserialization** — no `pickle.loads`, `yaml.load` (use `safe_load`), or Node `vm` on untrusted input.
27. **CORS — and what it isn't.** CORS is **not an access control**: it relaxes the browser's same-origin policy and stops nothing from curl or any server-side client. Authn/authz is the guard. The bugs people actually ship: **reflecting the request `Origin` back** into `Access-Control-Allow-Origin` (`origin => cb(null, origin)`) — this *is* the exploit, and it works with credentials; sloppy matching (`endsWith("myapp.com")` matches `evilmyapp.com`); and allowlisting `null`. Use a literal allowlist.
28. **Backups & recovery** — a tested restore, off-site. Not an attack, but the failure that ends projects; and a "done" backup that lives somewhere temporary is not a backup.

## How to run it (discipline)
- **Don't ask "check the project for vulnerabilities"** — the agent answers "looks fine" and is technically right. Go **one item at a time**.
- **Check each module as it's written** — the more code at once, the easier to miss something.
- **Demand the file and line** where the guard lives, or where it's missing.
- **Use a fresh session** — whoever wrote the code will defend it.
