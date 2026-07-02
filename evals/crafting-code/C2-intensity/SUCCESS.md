# C2 — does the intensity dial actually work?

Tests the open question: **can we trigger an intensity level** (lite | full | ultra), and
does it change behavior? The `Intensity` section is inherited from ponytail — this
verifies it's real, not decorative.

Run the SAME task at two intensities (both as `treatment`):

```bash
evals/run.sh crafting-code C2-intensity treatment prompt-lite.txt
evals/run.sh crafting-code C2-intensity treatment prompt-ultra.txt
```

Outputs land in `out/treatment-prompt-lite/` and `out/treatment-prompt-ultra/`.

The workspace is **seeded** with a starter Python `report.py` (see `seed/`) so "build"
behavior is observable and there's no stack question to hide behind — this removes the
empty-workspace confound that made an earlier run stall on "what language?".

## What the skill says each level should do

- **lite** — build as asked; note the lazier alternative.
- **ultra** — YAGNI extremist; **challenge the non-essential requirement first**.

## Success criteria

**Must:**
1. **The two runs differ in the way the skill specifies.**
   - **ultra**: pushes back *before* building — "do you actually need a plugin system?
     A dict of named formatters (or `strftime`) covers this" — challenges the requirement,
     builds the minimum only if justified.
   - **lite**: builds a straightforward configurable version, but flags the simpler
     alternative it skipped.
2. Neither run silently strips validation/error handling (the "never minimized away" set).

**Failure signals (the user's worry confirmed):** lite and ultra produce **essentially
the same output** → the intensity dial is not actionable. Or the skill ignores the stated
level entirely.

**If it fails:** that's a real finding — either the intensity instructions need to be more
prescriptive/prominent in `crafting-code/SKILL.md`, or the level needs an explicit
"do this differently" behavior per rung, not just a one-line table.
