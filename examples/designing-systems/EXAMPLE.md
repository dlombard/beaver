# Example — designing-systems

**Skill:** `designing-systems` · **Grade scale:** see [../README.md](../README.md)

Run in a fresh session in an empty directory. The skill should trigger on its own.

## Prompt

> We're launching a food-delivery startup in two cities. Customers order from
> restaurants in an app, restaurants accept and start cooking, couriers pick up and
> deliver, and everyone watches the order move on a live map. You're the principal
> engineer — design the system.

## What the skill should do

Turn this into a **full**-intensity decision-grade high-level design: elicit the
constraints the prompt omits, pick building blocks that fit, **seed the SRD**, and
produce the artifact set (product brief because there is no PRD, requirements +
**constraint register** + **SRD seed**, architecture + **building-block table**,
component inventory, quality attributes, risks, SMART criteria, spec/SRD backlog,
review).

## Reference — what good looks like

- **Constraints elicited or labeled as assumptions**, not invented: live-tracking
  update latency; **order state-machine consistency**; **payments strongly
  consistent (CP)**; courier↔order **dispatch/matching**; scale is ambiguous
  ("two cities → expansion") and named as architecture-determining.
- **Building blocks that fit a real-time, location, money system** — mobile clients;
  **real-time transport** (WebSocket/SSE or pub/sub) for live location; a
  **geospatial** store/index; an **event stream** for the order lifecycle; an
  **order service with an explicit state machine**; a **payments/ledger** store that
  is CP + auditable; notifications; a **dispatch/matching** service. *Not* a plain
  CRUD app.
- **Consistency split stated**: money = CP; live courier location = ephemeral/AP;
  order state = single-writer with a defined state machine.
- **Components by ownership** (single-writer per datum: orders, payments, dispatch).
- **SRD seed**: system functions (`SYS-n`) for place-order, accept, dispatch, live
  tracking, pay; external interfaces (customer app, restaurant, courier, payments,
  maps); qualification approach per class; draft allocation to components. Next-phase
  backlog has **named SRD-section rows** (e.g. payments interface shalls, verification
  matrix) — not a single "write the SRD" line.
- **AI kept appropriate**: ETA prediction and dispatch optimization noted as
  ML/optimization *if useful* — **no reflexive LLM chatbot**.

## Rubric

**Must (all required to pass):**
1. Produces a **constraint register** with measurable targets or labeled assumptions
   (latency for live tracking, order/payment consistency, scale).
2. **Building-block table** with real-time transport + geospatial + event stream +
   a CP money store — each tied to a constraint; not a generic CRUD stack.
3. States the **consistency model** per data class (money CP; location AP/ephemeral;
   order state single-writer).
4. **Components by ownership** with single-writer-per-datum.
5. Handles the **scale ambiguity** (asks ≤5 questions or labels assumptions) and names
   the two-cities→expansion boundary as design-shaping.
6. **Seeds the SRD**: `SYS-n` shalls + external interfaces + qualification approach,
   and backlogs **named** full-SRD gaps (not a blank "Full SRD section").
7. Uses **full** intensity (principal-engineer / "design the system") — the complete
   artifact set, not the four-file lite sketch.

**Failure signals (any ⇒ fail):**
- Generic CRUD-app design; no real-time transport for live tracking.
- Payments modeled as eventually-consistent, or no money/consistency story.
- No constraint register; or invents precise numbers with no reasoning.
- Bolts on an LLM/chatbot with no constraint driving it.
- Silently picks a launch scale without asking or labeling it.
- Writes a full SRD, or treats feature specs as the SRD; or omits the SRD seed.
- Drops to **lite** (sketch-only files) on this prompt.

**Grade:** ✅ Pass = all Musts, no signals · ⚠️ Partial = minor gaps only · ❌ Fail =
any Must missed or any signal present.
