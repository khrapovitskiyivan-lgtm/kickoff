# Example equip artifacts — Leads intake

What `project-setup` **Step 4** writes **only after you confirm** — the durable output of the
vet. Merge-not-clobber; every line maps to a tool you approved in the checkup
([`checkup-scorecard.md`](checkup-scorecard.md)).

## Permissions allowlist — `.claude/settings.local.json`

Written to the **personal** scope, not `settings.json` — the latter is committed and would hand
these standing grants to everyone who clones the repo. Created alongside a `.gitignore` entry.

```json
{
  "permissions": {
    "allow": [
      "Bash(ruff check:*)",
      "Bash(ruff format:*)",
      "Bash(gitleaks detect:*)",
      "Bash(alembic upgrade:*)"
    ]
  }
}
```

**What was deliberately left out, and why the user was told:**

| Considered | Verdict |
|---|---|
| `Bash(pytest:*)` | **Not granted.** pytest imports `conftest.py` from the working tree — this is "run any code in this repo, forever, without asking", not a narrow test permission. Worth a prompt each time. |
| `Bash(celery -A app.worker:*)` | **Not granted.** Same shape: it loads and executes application code. |
| `Bash(ruff:*)` | Narrowed to the two subcommands actually used. |

Each remaining line is a tool that reads or rewrites files under known subcommands. The point of
the allowlist is to stop re-prompting for *boring* commands — not to pre-approve arbitrary
execution because the binary's name sounds safe.

## Quality-gate — `.pre-commit-config.yaml`

Lint + typecheck + secret scan on every commit. `rev:` pinned to **commit SHAs, not tags** — tags
are mutable, so a compromised maintainer could re-point one and every run would execute new code.

```yaml
repos:
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: 8b76f04e7e5a9cd259e9d1db7799599355f97cdf  # v0.6.0
    hooks: [{ id: ruff }, { id: ruff-format }]
  - repo: https://github.com/pre-commit/mirrors-mypy
    rev: bbc3dc1f890007061f18f17e2334f216ea9e5df7  # v1.11.0
    hooks: [{ id: mypy }]
  - repo: https://github.com/gitleaks/gitleaks
    rev: 77c9c1e2f0dc9d0ec1e6d0b0e34cbfd2ff0e19b6  # v8.18.0
    hooks: [{ id: gitleaks }]
```

**What kickoff refused to promise.** "Block `--no-verify`" was dropped from the plan and the user
told why: that flag exists to skip local hooks, so no local hook can block it. Force-push
protection likewise lives in the git host's branch-protection rules, not in emitted config —
shipping a hook that appears to guard these would be worse than shipping nothing.

**A running-tests hook was not added.** `pytest -q` on every commit means repo code executes on
every `git commit`; combined with an allowlisted `git commit`, that is unattended execution. Tests
belong in CI here.

Conventional-commit check (commit-msg) is added the same way (e.g. `commitizen`), tagged by risk in
the plan. Nothing here is written without your explicit yes, and it's recorded in the ledger.
