# Example equip artifacts — Leads intake

What `project-setup` **Step 4** writes **only after you confirm** — the durable output of the
vet. Merge-not-clobber; every line maps to a tool you approved in the checkup
([`checkup-scorecard.md`](checkup-scorecard.md)).

## Permissions allowlist — `.claude/settings.json`

Scopes approval to exactly the vetted tools, so they run without re-prompting and nothing
else is implicitly trusted:

```json
{
  "permissions": {
    "allow": [
      "Bash(pytest:*)",
      "Bash(ruff:*)",
      "Bash(gitleaks:*)",
      "Bash(alembic upgrade:*)",
      "Bash(celery -A app.worker:*)"
    ]
  }
}
```

## Quality-gate — `.pre-commit-config.yaml`

The enforcement layer: lint + typecheck + test + secret scan on every commit. Git-safety
(block force-push to `main`, block `--no-verify`) is enforced by the team's server-side rules
or a local `pre-push` hook — kickoff emits the config, it doesn't weaken your git host.

```yaml
repos:
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.6.0
    hooks: [{ id: ruff }, { id: ruff-format }]
  - repo: https://github.com/pre-commit/mirrors-mypy
    rev: v1.11.0
    hooks: [{ id: mypy }]
  - repo: https://github.com/gitleaks/gitleaks
    rev: v8.18.0
    hooks: [{ id: gitleaks }]
  - repo: local
    hooks:
      - id: pytest
        name: pytest
        entry: pytest -q
        language: system
        pass_filenames: false
```

Conventional-commit check (commit-msg) is added the same way (e.g. `commitizen`), tagged by
risk in the plan. Nothing here is written without your explicit yes, and it's recorded in the
ledger.
