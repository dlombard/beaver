# C1 — simplicity ladder on over-engineered code

Tests: triggering + the skill's simplicity ladder / pillars producing a concrete
simplification.

## Baseline expectation (no skill)

A model may simplify the algorithm (spot `dict.fromkeys`) but often **keeps or even
praises** the Strategy-pattern scaffolding as "good extensibility," or gives style nits
without deleting the needless hierarchy.

## Treatment success criteria

**Must:**
1. Walks the **simplicity ladder** and identifies the stdlib/one-line solution —
   `list(dict.fromkeys(items))` — tagging **[stdlib]** and/or **[shrink]**.
2. Flags the **speculative abstraction** (strategy interface + wrapper for a single
   impl) — **[yagni]/[delete]** — and recommends removing it.
3. Gives the concrete replacement: one small function.
4. Does **not** strip genuinely necessary validation in the name of minimalism.

**Failure signals:** approves the code / praises the pattern; adds *more* structure;
misses the one-line stdlib solution; only offers cosmetic nits.

**Uplift check:** baseline often half-simplifies; treatment should delete the hierarchy
*and* reach the one-liner, explicitly via the ladder.
