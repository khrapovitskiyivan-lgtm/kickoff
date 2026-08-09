# kickoff

A shareable Claude Code starter kit. It helps you **plan a new project** (spec-first)
and **equip new or existing projects** with the right, *vetted* Claude Code tooling —
instead of chasing "install this, install that" tutorials.

## Install (one time)

```bash
claude plugin marketplace add https://github.com/khrapovitskiyivan-lgtm/kickoff
claude plugin install kickoff@kickoff
```

Restart Claude Code so it loads.

## Use

In any project, run:

```
/kickoff:start
```

It asks whether the project is **new** or **existing**:

- **New** → walks you through a spec-first plan (Spec vs Spike, a 6-block spec) and recommends the right tooling for your stack.
- **Existing** → detects your stack, tells you what is worth adding, and points you at the official `claude-code-setup` plugin for a deeper pass.

Everything is **vet-before-install**: it flags which additions execute code (hooks / MCP servers) versus plain instructions (skills), so you install with eyes open.

## What's inside

- **`spec-first`** skill — a lightweight methodology overlay (track selector, 6-block spec, reverse-spec for legacy code, living-spec / drift control).
- **`project-setup`** skill — an opinionated tooling baseline by stack + a vetting checklist.
- **`/kickoff:start`** — the entry command.

## Fork it

To republish under a different account, update `owner` in `.claude-plugin/marketplace.json`,
`author` in `plugins/kickoff/.claude-plugin/plugin.json`, and the marketplace URL above.

MIT.
