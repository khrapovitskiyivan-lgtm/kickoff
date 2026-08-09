---
description: Kick off — set up a new project (spec-first) or audit an existing one for the right tooling.
---

Ask the user whether this is a **new** project or an **existing** one, then:

- **New** → if it's just an idea (no stack chosen, no code yet), FIRST shape it with `superpowers:brainstorming` (problem, users, MVP scope, and the stack choice); THEN `spec-first` (track selector → 6-block spec); THEN `project-setup` (equip the chosen stack). Do NOT recommend stack tooling before a stack exists.
- **Existing** → follow the `project-setup` skill: detect the stack, recommend what is missing from the house baseline, suggest running the official `claude-code-setup` plugin for deeper analysis, and vet before installing.

Keep it lightweight; skip the ceremony for one-off / throwaway scripts.
