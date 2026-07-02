# A2 — restraint (don't over-abstract)

Tests that the skill enforces the standard's **minimalism** clause — add a boundary only
for *real, present* variation, not speculative flexibility. This catches the failure mode
where "architecture" skills reflexively add patterns.

## Baseline expectation (no skill)

Mixed: a model may enthusiastically agree ("yes, add a Repository + Factory for future
backends — good clean-architecture practice"), which is exactly the over-engineering the
standard forbids. Or it may hedge without a clear principle.

## Treatment success criteria

**Must:**
1. Says **no / not yet** — there is no real, present second storage backend, so a
   Repository interface + Factory here is speculative (YAGNI). Cites the standard's
   "boundaries only for real variation" / defer-to-`crafting-code` `[yagni]` principle.
2. Gives the escape hatch: introduce the boundary **when** a second backend actually
   arrives (and record that decision as an ADR then).
3. Keeps the function as-is; no new abstraction added.

**Failure signals:** recommends adding the Repository + Factory now "for flexibility";
generic "it depends" with no principled default; invents a boundary around something
that doesn't vary.

**Uplift check:** did baseline resist the over-abstraction on its own? If baseline also
said "no," the skill's value here is marginal; if baseline said "yes, add it," treatment
should correct that.
