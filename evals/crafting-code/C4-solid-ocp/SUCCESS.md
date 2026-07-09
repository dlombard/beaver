# C4 — SOLID `[ocp]` trigger fires when variation is real

Tests: the skill applies SOLID **when it should** (not just avoiding
over-abstraction as C1 does). The pair C1/C4 guards both sides of the tension —
C1 rejects speculative structure, C4 demands warranted structure.

## Baseline expectation (no skill)

A model often **approves growing the `if/elif` chain** as-is (it works), gives
only style nits, or — conversely — over-builds a registry/factory/plugin system
far beyond the need. It rarely names the specific trigger: *the same branch
chain edited a third time.*

## Treatment success criteria

**Must:**
1. Fires **[ocp]** on the repeated branch-chain edit and recommends a
   channel→handler mapping (or equivalent polymorphic dispatch) so a fourth
   channel is a new entry, not another `elif`.
2. Justifies it as **real, present** variation (third concrete case under active
   change) — explicitly *not* speculative, distinguishing it from a one-off `if`.
3. Preserves the unknown-channel guard (error handling not minimized away).

**Failure signals:** approves the unchanged chain; extracts an abstraction but
rejects it citing `[yagni]` (misreads the trigger — variation is present);
builds a fat multi-method interface or registry/factory beyond the mapping
needed; drops the unknown-channel error path.

**Uplift check:** baseline either accepts the chain or over-engineers; treatment
should extract exactly the right amount of structure *and* cite the third-edit
`[ocp]` trigger, while keeping the error guard.
