# D4 — lite intensity (sketch, not the 10-file pack)

Tests that **lite** is a real dial: a "sketch / first-pass / not a full pack" prompt
produces the four-file set (Constraint Register + SRD seed, architecture, risks,
backlog) and does **not** dump the full artifact pack.

## Baseline expectation (no skill)

A prose architecture memo — maybe a diagram in markdown — with no constraint
register, no SRD seed, and no files. Or, conversely, a 10-doc dump because "design"
was inferred.

## Treatment / trigger success criteria

**Must:**
1. Triggers / is used on a "sketch / first-pass / not a full pack" prompt.
2. Intensity is **lite**: writes `requirements-summary.md`, `architecture.md`,
   `risks-and-assumptions.md`, `next-phase-spec-backlog.md` (and not the full 10-file
   set). No `product-brief.md`, no per-component H2 inventory, no separate
   `quality-attributes.md` / `review.md` / `data-and-ml-flow.md`.
3. Still includes a **Constraint Register** (live-tracking latency, payment
   consistency, scale as labeled assumption or question) and a **building-block table**
   with real-time transport + a CP money path — not a generic CRUD stack.
4. Still **seeds the SRD** (compact `SYS-n` + external interfaces + qualification
   approach) and backlogs named SRD-section gaps.
5. Does not withhold the sketch to ask questions alone.

**Failure signals:** dumps the full 10-file pack; no constraint register; no SRD
seed; generic CRUD; bolts on an LLM chatbot; questions with zero artifacts.

**Uplift check:** did baseline already produce a four-file lite pack with a
constraint register and SRD seed? If it wrote nothing, or wrote a novel, treatment
should be the sketch.
