---
name: spec-first
description: Use when starting a new project or module, authoring or restructuring a module spec, or entering an unfamiliar or legacy codebase (brownfield). Topics: Spec-vs-Spike track selection, the stack-agnostic 6-block module spec with per-stack adapters, reverse-spec of existing code, living-spec drift control and SPEC_CHANGELOG, and model routing by task class. Overlays the Superpowers brainstorm-plan-build-verify flow. Not for one-off scripts, throwaway prototypes, or small edits to an already-spec'd module.
---

# Spec-First — methodology overlay

An **overlay** on the Superpowers brainstorm→plan→build→verify flow. It does NOT
replace that flow — it inserts five deltas at named phases. Load it once at the
start of project/module work and keep it active; **never invoke it as a step
"after brainstorming."**

> **Prerequisite — Superpowers.** This overlay drives the `superpowers:*` skills named in the
> table below; it cannot run without them. If those skills are not installed, **stop and tell
> the user** to install the Superpowers plugin first —
> `claude plugin marketplace add obra/superpowers-marketplace` then
> `claude plugin install superpowers@superpowers-marketplace` — rather than calling a skill that
> isn't there.

Operational extract of a Spec-First methodology. Living document — update when
practice diverges. Last-reviewed: 2026-08-09.

## When to apply (and when NOT)

Apply when: a **multi-module system**, OR **rework-cost > spec-cost**, OR **shared
contracts across parallel agents**. Skip when: a single throwaway file, or an
exploratory spike with no downstream reuse. (The track selector below doubles as
this gate.)

## How this layers on Superpowers

These Superpowers skills own the generic flow. Do not restate or replace it —
apply only the deltas.

| Phase | Owner (invoke) | spec-first delta |
|---|---|---|
| Before design | *(spec-first)* | **Track selector** (Spec vs Spike); if Spike, frame the spike-plan as the decision brainstorming will get approved |
| Design / spec | **REQUIRED SUB-SKILL:** Use superpowers:brainstorming | Design doc uses the **6-block skeleton + stack adapter**; brownfield → **reverse-spec first**; add the **Acceptance/observable-done** block |
| Plan | Use superpowers:writing-plans | Contracts already handled by its Interfaces block — *no delta* |
| Build | Use superpowers:executing-plans / subagent-driven-development + using-git-worktrees | *No delta* except: parallelize only what a contract decouples; coupled work is sequential |
| Verify | Use superpowers:test-driven-development + verification-before-completion | "Done" = observable criteria from the spec; for ML, a **metric on holdout**, not "tests green" |
| Finish | Use superpowers:finishing-a-development-branch | **Update the spec to reality + drift-check + SPEC_CHANGELOG entry** |

## 1. Track selector (before any spec)

Test: **"Can I fill all 6 spec blocks without guessing anything?"**
- All yes → **Spec-track**: specify fully → autonomous build.
- Any block is a guess → **Spike-track**: run a **time-boxed spike** (a prototype
  with ONE goal: remove a named uncertainty), record what you learned, THEN write
  the spec by fact.

A module can split: deterministic part → Spec, uncertain part → Spike. **The spec
describes the learned solution, not a hypothesis.**

**HARD-GATE reconciliation:** brainstorming forbids code before an approved design;
a spike is code. Resolve it: **the spike IS the approved decision** — the user
approves the plan *"run a time-boxed spike with goal X to remove uncertainty Y,
then spec against the result."* Time-boxed, one named uncertainty, no open-ended
coding. This satisfies the gate. The track selector runs **per module, one level
below** brainstorming's project decomposition — don't conflate them.

## 2. Stack-agnostic 6-block spec + adapter

Every module spec has six stack-independent blocks — plus a security and an acceptance
block: User Stories · Data Model · Interface Contract · Screens / entry points ·
Business Logic · Edge Cases · **Security / abuse** · **Acceptance / observable-done**.

**Security is designed in, not bolted on.** Decide at spec time who may read/write each
object and where that is enforced — retrofitting authorization after the code exists is
how the classic holes (IDOR, missing server-side authz, unguarded uploads) get shipped.

Translate **Data Model, Security, API, Background, ML-inference** to your stack via
`reference/stack-adapters.md` — **never default to Supabase**. Fillable skeleton:
`reference/templates.md`.

**Before writing a spec, read `reference/example-spec.md`** — a filled spec for a small module —
and match its level of concreteness. Blocks like "validate the input" are not specifications;
that file shows what "concrete as code" actually means.

## 3. Brownfield: reverse-spec first

For existing/legacy code, before changing anything: point a reader-subagent at the
module → it reconstructs the 6-block spec of what ALREADY exists → mark the
**seams** (safe insertion points, contracts you must not break) → specify ONLY the
change and its impact on adjacent contracts. Don't rewrite what works. Procedure:
`reference/templates.md`.

## 4. Living spec + drift control

The spec is the single source of truth; a spec↔code divergence is a bug in one of
them, never "the code is just newer." At the finish phase: the implementing agent
**updates the spec to what was actually built**; qa runs a **drift-check**
(spec↔code contracts and data models); append a `SPEC_CHANGELOG.md` entry. Keep
ONE living spec in brainstorming's default `docs/superpowers/specs/` location —
don't mint a competing file. Checklist + changelog format: `reference/templates.md`.

## 5. Model routing by task class + ROI honesty

Route by task class, not model name:

| Task class | Tier |
|---|---|
| Heavy reasoning (architecture, security, tricky bugs, ML design) | top reasoning tier |
| Routine (UI, forms, reviews, ordinary features) | mid tier |
| Bulk mechanics (scaffolding, formatting, renames) | cheapest/fastest tier |
| Need iteration speed | Fast mode on a top model |

**ROI honesty:** Spec-First pays off when rework-cost > spec-cost — true for
multi-module systems, false for one-off scripts. Measure your rework rate; don't
trust the slogan. Fresh docs (Context7 etc.) only where external / fast-moving
APIs are involved — not for stable stdlib.

## Delta checklist
- [ ] Track chosen deliberately (Spec/Spike); uncertainty removed by a spike before the spec
- [ ] Stack adapter filled (not Supabase-by-default)
- [ ] Brownfield: reverse-spec of existing + seams marked
- [ ] 6-block spec includes a Security / abuse block and an Acceptance / observable-done block
- [ ] Non-obvious architecture / stack choices have their rationale recorded (one line in the
      ledger or a short `docs/adr/` note) — so the "why" survives the decision
- [ ] "Works" defined observably in the spec; ML measured on holdout
- [ ] Spec updated to reality post-build; SPEC_CHANGELOG entry added
- [ ] Models routed by task class; Context7 only where needed
- [ ] Skipped the ceremony for one-off / throwaway work
