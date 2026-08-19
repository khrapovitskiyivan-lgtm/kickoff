---
description: Kick off — set up a new project (spec-first), or run the full first-contact pass on an existing one.
---

**Prerequisite check (new-project path):** the planning flow drives `superpowers:*` skills. If they aren't installed, tell the user to add the Superpowers plugin first — `claude plugin marketplace add obra/superpowers-marketplace` then `claude plugin install superpowers@superpowers-marketplace` — and pause until it's in. The **existing**/equip path below works without it.

Ask the user whether this is a **new** project or an **existing** one, then:

- **New / empty folder / just an idea** → be proactive: if there is no code and no design yet, first **ASK what they are building** — don't stay silent — then shape it with `superpowers:brainstorming` (problem, users, MVP scope, and the stack choice); THEN `spec-first` (track selector → 6-block spec); THEN `project-setup` (equip the chosen stack). Do NOT recommend stack tooling before a stack exists.
- **Existing (brownfield)** → this is **first contact** with a codebase kickoff has never seen, so go wider than a routine checkup — there is no ledger to honor and nothing to diff against yet. Do all of it, in order:
  1. **Orient.** Reverse-spec the core modules per `spec-first` (what already exists, and the contracts that must not break) — enough to understand the system, not a full rewrite of its docs.
  2. **Capture conventions.** Lint/format config, naming, layout → record in `CLAUDE.md` so later work matches house style.
  3. **Analyze every dimension** via `project-setup`, and for a web-facing project flag that a deep security pass (`/kickoff:security`) is warranted.
  4. **Create the ledger** `.kickoff/notes.md` with a **baseline scorecard** — the snapshot every later `/kickoff:checkup` diffs against to show movement.
  5. **Equip** on confirmation, vetting first (skills < code-executing hooks/MCP).

  Afterwards, recurring passes are `/kickoff:checkup` — **`start` is the once-per-project onboarding, `checkup` is the repeat visit.**

Before writing or installing anything, present the **full proposed plan** (spec + tooling list, each item tagged by risk) and get one approval — don't act tool-by-tool.

Keep it lightweight; skip the ceremony for one-off / throwaway scripts.
