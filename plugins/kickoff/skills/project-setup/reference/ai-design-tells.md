# AI design tells — what gives away a generated page

A page can pass every accessibility, performance and SEO check and still read as
machine-made. These are the signatures a model reaches for when it tries to "look
designed". Run this **after** the layout exists — it is an audit, not a direction:
`frontend-design` and the design skills decide what to aim for, this checks what
actually landed.

**Scope: marketing surfaces** — landing pages, portfolios, storefronts, prototypes.
Not dashboards, data tables, or multi-step product UI, where several of these
patterns are legitimate.

Most of this is **mechanically checkable**, which is the point: run the greps, cite
the line, don't eyeball what a command can count.

## Countable — grep for these first

| Tell | Check | Why it's a tell |
|---|---|---|
| **Em-dash as decoration** | `grep -c '—' page` | The single loudest signature. Counts lines carrying one; even a handful reads as machine prose. Use a plain hyphen. |
| **Middle-dot separators** | `grep -c '·.*·' page` | Fine once in a metadata strip; `foo · bar · baz · qux` is the default a model reaches for. Cap at one per line. |
| **Numbered step labels** | `grep -nE '[0-9]+ *[·.:] *[A-ZА-Я]' page` | `1 · Setup`, `Stage 2`, `Phase 03`. The step's content is its label. |
| **Section-number eyebrows** | `grep -nE -e '[0-9]{2,3} +/ +[0-9A-Za-zА-я]' -e '[0-9]{2,3} +· +[A-ZА-Я0-9]' page` | `00 / INDEX`, `002 · Capabilities`, `01 / 4` pagination. If the reader can count, drop the label. |
| **Pure black** | `grep -ic -e '#000000' -e '#000\b' page` | Off-black, charcoal, zinc-950 instead. |
| **Three equal feature cards** | `grep -cE -e 'grid-cols-3' -e 'repeat\(3, *1fr\)' page` | The default feature row. Prefer a 2-column zig-zag or an asymmetric grid. Verify by eye: not every 3-column grid is a feature row. |
| **Perfect round numbers** | `grep -o -e '99\.9\+%' -e '100%' -e '50%' -e '24/7' page` | Real data is messy: `47.2%`, not `50%`. |
| **Hand-rolled icons** | `grep -c '<svg' page` | Prefer an icon set over bespoke path data. |
| **Custom cursors / neon glow** | `grep -cE -e 'cursor:[^;]*url' -e 'box-shadow:.*0 0 [0-9]*px' page` | Both read as 2015 and hurt accessibility and performance. |

**Verify before reporting.** A substring match is not a finding: grepping `Inter`
hits `interface` and `internal`, so check `font-family` before claiming a font.
Two independent searches plus reading the code path — same rule as the security
baseline.

## Needs an eyeball — no grep will settle these

- **Fake product UI built from divs** in the hero (a mock terminal, task list or
  dashboard made of styled rectangles). The strongest single tell there is; use a
  real screenshot, a generated image, or nothing.
- **Version-status eyebrows** (`BETA`, `v2.0`, `EARLY ACCESS`) when the brief is not
  actually about a launch.
- **Oversized H1** carrying the hierarchy alone, where weight and colour should.
- **Hero top padding** so large the content floats mid-viewport - reads as a bug.
- **Poetic section labels** ("From the field", "On our desks") and filler verbs
  ("Elevate", "Seamless", "Unleash", "Next-Gen") where a plain noun would do.
- **Generic placeholder identity**: stock names, egg avatars, "Acme"-class brands.

## A caution on language

The copy-level tells above are written for English pages. On a page in another
language the structural checks (em-dash, dots, numbering, colour, grid, icons) all
still hold, but the phrase bans do not transfer - do not report their absence as a
pass. Judge the copy in its own language for the same failure: performative
craftsman labels and empty superlatives.

---

Distilled from the "AI Tells" catalogue in `Leonxlnx/taste-skill` (MIT), which
derived it from tests on generated landing pages. Rewritten and re-scoped here;
the grep column is our own, and was validated against a real storefront page.
