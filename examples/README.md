# Worked examples

Concrete outputs kickoff produces, on one running example — a small **Leads intake**
module (FastAPI / Python). They make the claims in the top-level README verifiable
("we produce a real spec / scorecard / config", not just advice) and serve as few-shot
anchors for the skills.

These are **illustrative artifacts, not an automated eval** — a markdown-skill plugin
has nothing to run in CI; the value is a reference of what "done" looks like.

| File | Produced by | Shows |
|---|---|---|
| [`leads-intake-spec.md`](leads-intake-spec.md) | `spec-first` | A filled 6-block module spec + Acceptance/observable-done |
| [`checkup-scorecard.md`](checkup-scorecard.md) | `/kickoff:checkup` | A per-dimension coverage scorecard + the `.kickoff/notes.md` ledger |
| [`equip-artifacts.md`](equip-artifacts.md) | `project-setup` Step 4 | The config kickoff writes *on confirmation*: a scoped permissions allowlist + a quality-gate |

Same fictional project throughout, so the artifacts line up: the spec names the contracts,
the checkup finds the gaps, the equip step writes the config that closes them.
