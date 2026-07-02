# D1 — smart parking (core artifacts + targeted revision)

Tests: triggering, expected material, constraint elicitation, and sustaining a
conversation (revise one element).

## Baseline expectation (no skill)

Typically a reasonable but generic architecture: components + a stack, prose-level.
Usually **no constraint register**, no explicit consistency model, doesn't surface the
hidden constraints, and the follow-up gets a broad rewrite rather than a scoped edit.

## Treatment success criteria

**Turn 1 — Must:**
1. Triggers (in `trigger` mode) / is used, and produces the artifact set (ideally in
   `docs/design/`): product brief, **constraint register**, architecture with a
   **building-block table**, component inventory, risks.
2. Elicits or labels the hidden constraints: real-time occupancy/availability latency,
   **sensor connectivity/power** (IoT), **payment consistency**, and the **pilot→citywide
   scale ambiguity** (asks or labels assumptions — doesn't silently pick a scale).
3. States a **consistency model** per data class (payments strong; occupancy/telemetry
   eventual/approximate).
4. Picks fitting building blocks (ingest/event stream for sensor telemetry, a store for
   spot state, reservation + payment services), not a plain CRUD app.

**Turn 2 (follow-up) — Must:**
5. Revises **only the payment/billing element** (→ strongly consistent + PCI: tokenized
   PANs, CP store, isolated scope) and the specific things it touches (e.g. the
   constraint-register row, the relevant component), **without rewriting the whole
   design**. Demonstrates it can locate and edit one element.

**Failure signals:** no constraint register; misses the scale ambiguity; generic CRUD
stack; treats all data as one consistency class; on the follow-up, regenerates the
entire design or ignores PCI.

**Uplift check:** did baseline already produce a constraint register + consistency
model + scoped revision? If yes, the skill added little here; if no, treatment should.
