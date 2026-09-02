# Equip artifacts — what kickoff can write, and what each one really does

The catalogue behind Step 4 of `project-setup`. Everything here is **offered, never written
silently**, and merged rather than clobbered. Nothing is written without an explicit yes, and what
was written goes in the ledger.

One rule governs the whole file: `.claude/settings.json` is committed and inherited by everyone who
clones the repo; `.claude/settings.local.json` is personal. A machine-local decision belongs in the
personal one.

- **Permission allowlist (primary).** Write / extend **`.claude/settings.local.json`** — the
  *personal* scope. `settings.json` is committed and inherited by everyone who clones the repo, so
  a machine-local vetting decision does not belong there; use it only if the user explicitly asks
  to commit the grants for the whole team. When you create `settings.local.json` yourself, also add
  it to `.gitignore` (Claude Code auto-excludes only the copies *it* writes).
  - **Say what an allow entry really grants.** Many look narrow and are not: `Bash(pytest:*)` runs
    the repo's `conftest.py`, `Bash(npm run:*)` runs any `package.json` script, `Bash(make:*)` runs
    the Makefile — each is *arbitrary code execution in this repo, from now on, without asking*.
    Present the **consequence**, not just the tool name, and let the user weigh it.
  - **Narrowest form that works** (`Bash(npm run test:*)`, not `Bash(npm:*)`). **Never** emit
    `Bash(*)`, `Bash(curl:*)`, `Bash(rm:*)`, `Bash(git push:*)`, or `Read(*)`/`WebFetch(*)` reaching
    outside the project.
  - **Merge, don't clobber** — Read the file first, show the **literal added lines as a diff** at
    the approval gate, and re-parse the JSON after writing. Never `Write` over an existing settings
    file; only edit it.
- **Deny baseline (offer it first).** An allowlist only ever *widens* what runs unasked; the half
  that protects is `permissions.deny`, and it is the cheaper half — denials are written once and
  hold for years, while allows accrete. Rules resolve **deny → ask → allow**, so a broad deny beats
  any narrower allow underneath it and cannot be argued around. Offer a starting set, scoped to what
  this project actually has:
  - **Secrets**: `Read(.env)`, `Read(**/*credential*)`, `Read(**/*.pem)` — keep them out of context
    in the first place, rather than trusting nothing leaks them later.
  - **Irreversible git**: `Bash(git push --force*)`, `Bash(git reset --hard*)`.
  - **Destructive shell**: `Bash(rm -rf *)`, and `Bash(curl * | bash)` (fetch-and-execute).
  - **The project's own precious data** — whatever a lost file would cost most here (raw datasets,
    migrations, generated reports). Ask what that is; it differs per project and is the one entry
    a generic list can't supply.
  - **A temporary freeze, when the task is debugging.** While chasing one bug, denying writes outside
    the directory in question (`Write(!src/billing/**)`-shaped, per the host's pattern syntax) stops
    the classic "fixed it, and quietly changed six other files" outcome. Offer it as a *session*
    measure and say plainly it should be lifted afterwards — a freeze left behind is a puzzle for
    whoever hits it next week.
  This is the layer that does not depend on the model reading carefully: a text rule in `CLAUDE.md`
  is a request the model can lose track of, a `deny` entry is enforced before it acts. **Anything
  expensive to lose belongs here, not in prose.**
- **Scoped rules (`.claude/rules/*.md`, when a convention only applies to part of the tree).**
  A rule file with `paths:` frontmatter loads **only when the agent opens a matching file**, so it
  costs nothing the rest of the time — the right home for "how we write X" that would bloat
  `CLAUDE.md` if it were always resident. Offer one when a convention is real but local (a content
  directory's tone, a migrations folder's rules, a generated-code area that must not be hand-edited).
  Without `paths:` the file loads every session like `CLAUDE.md` — only worth it as organisation.
- **A subagent definition (`.claude/agents/<name>.md`), when a role actually repeats.** Its
  frontmatter is the whole design: `name`, a `description` that says **when to call it** (the model
  routes on this line, so write it as a trigger, not a title), and `tools:` listing what it may use.
  - **`tools` is a boundary, not a convenience.** A reader given `tools: Read, Grep, Glob` *cannot*
    write, whatever it decides. Same enforcement layer as the deny list above, scoped to a helper:
    give the narrowest set the job needs.
  - **Worth defining when** the work is bulky and one-shot (read two hundred files, return one
    answer), when the helper must be denied tools the main session has, or when the same role
    recurs across projects. The point is that the heavy reading happens in *its* context and only
    the conclusion comes back.
  - **Not worth it when** the task takes two minutes (handing it over costs more than doing it), or
    when the helper would need the conversation so far — it cannot see it, and re-explaining is the
    expensive part. **Check the built-ins first**: `Explore` searches and cannot write, `Plan`
    gathers material for a plan. Most "I need a reader" cases are already covered.
  - **Keep the drawer small.** Descriptions are resident context; a dozen near-identical helpers
    make the choice worse, not better. Prefer one good definition over three overlapping ones.
- **A Claude Code hook, when a rule must hold rather than be remembered.** Permissions say what
  *may* run; hooks say what *happens* at a moment, and both are executed by the program rather than
  interpreted by the model. Configured in the same settings file. The moments worth knowing:
  `SessionStart` (prime or check the environment), `UserPromptSubmit` (inject something into every
  request), `PreToolUse` (**can block an action** - the place for a dangerous-command guard),
  `PostToolUse` (tidy or verify after a change), `Notification` (the agent is waiting on a human),
  `Stop` / `SubagentStop` (work finished). Use a `matcher` so a hook fires on the events it means:
  a `SessionStart` hook with none also re-fires on resume and on every compaction.
  - **Two failures that look like a broken hook.** A slow check with no explicit `timeout` stalls
    the agent. And a script referenced by a bare relative path is not found, because a hook does not
    necessarily run from the project root - anchor it: `"$CLAUDE_PROJECT_DIR"/.claude/hooks/name.sh`.
  - A hook runs code on the user's machine at moments they did not trigger. Show what it will run,
    and prefer the smallest one that does the job over a clever one.
- **MCP servers land in a file, and which one decides who gets them.** A server added for yourself
  is personal; **`.mcp.json` at the project root is the shared one** - committed, so everyone who
  clones the repo is offered the same connections. Put a server there only when the whole team
  genuinely needs it, and never put a token in it: that file reaches everyone and stays in history.
  Credentials belong in the environment, referenced by name.
- **CLAUDE.md stub (light, only if wanted).** Only when the project lacks one and the user asks:
  a short stub (stack + key conventions). Keep it minimal — `/init` owns full project docs; do
  **not** overwrite an existing `CLAUDE.md`.
- **Quality-gate config (optional).** Offer a vetted, stack-appropriate **pre-commit gate**
  (lint + typecheck + test) and a **conventional-commit** check. Emit config only — the enforcement
  layer is the natural sibling of the allowlist, not code scaffolding. Match the stack's own tool
  (husky + lint-staged / pre-commit / lefthook); **merge**, don't clobber; tag each line by risk.
  - **Pin hook repos to commit SHAs, not tags** — a tag is mutable, so a compromised maintainer can
    re-point it and every run executes new code.
  - **Don't promise what a local hook cannot do.** `--no-verify` exists precisely to skip local
    hooks, so it cannot be blocked from one; force-push protection likewise belongs to the git host
    (branch protection). Say so instead of emitting a guard that only looks like one.
  - Note the loop: a test-running pre-commit hook means repo code executes on every `git commit`.
    Combined with a `Bash(git commit:*)` allow entry, that is unattended code execution.
