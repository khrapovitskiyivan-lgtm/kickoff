# Templates — spec skeleton, reverse-spec, drift-check, changelog

## 6-block module spec skeleton

```
## Module: <name>
### User Stories
- As a <role>, I <action> so that <outcome>.
### Data Model
<per stack — see stack-adapters.md; concrete fields/types, not abstractions>
### Interface Contract
<endpoints/functions: signature, input/output schema, error codes — concrete as code>
### Screens / entry points
<screens, routes, CLI commands, or events that reach this module>
### Business Logic
<the rules; deterministic functions where possible>
### Edge Cases
<empty, malformed, concurrent, over-limit, unauthorized, …>
### Security / abuse
<per stack — see stack-adapters.md: who may read/write each object and where that is
 enforced (server-side, not UI); what untrusted input reaches; what it costs an abuser
 to hammer it. Web-facing → design against project-setup's security-baseline.md.>
### Acceptance / observable-done
<what must be observably true to call this done: concrete scenarios;
 for ML, the metric + threshold on a named holdout>
```

**Filled mini-example (Acceptance block):**
```
### Acceptance / observable-done
- POST /leads with a valid payload returns 201 and the row exists in `leads`.
- POST /leads with a missing `phone` returns 422 with a field-level error.
- Matcher precision@5 >= 0.85 on holdout set `bench/stroysleng-2026`.
```

## Reverse-spec procedure (brownfield)

1. Point a reader-subagent (Read/Grep/Glob only) at the module → have it emit the
   **6-block spec of what already exists**, from the code.
2. Mark the **seams**: safe insertion points, and the contracts (signatures,
   schemas, events) that must NOT break.
3. Specify ONLY the change + its impact on adjacent contracts. Do not rewrite
   working code.
4. Capture house **conventions** — sample the lint/format config (eslint / prettier /
   ruff / gofmt / rustfmt), naming patterns, and directory layout — and record them in
   `CLAUDE.md` so later specs and tooling recommendations match the existing style.

## Drift-check checklist (finish phase)

- [ ] Every Interface Contract in the spec matches the actual signature/schema in code.
- [ ] The Data Model in the spec matches the actual tables/models.
- [ ] New edge cases discovered during build are added to the spec.
- [ ] The Acceptance block still describes what the code observably does.

## SPEC_CHANGELOG.md entry format

```
## <date> — <module/topic>
- Changed: <what diverged from the original spec>
- Why: <reason>
- Impact: <contracts/consumers affected>
```
