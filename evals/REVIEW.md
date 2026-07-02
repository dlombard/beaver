# Beaver Skills — A/B Eval Review

Model under test: **claude-sonnet-5**. Reviewer's stance: adversarial — find where the
skills add nothing over a strong baseline, not where they read well. Every claim below is
quoted from the saved artifacts under `evals/<skill>/<case>/out/`.

## Overall verdict

The three skills are well-written and produce correctly-*structured*, traceable output.
But on a strong model the **substantive** work is often already done by the no-skill
baseline. Uplift is real and clear in exactly two places — **designing-systems D1** (formal
decision-grade artifacts + capacity-justified restraint + a genuinely scoped revision) and
**crafting-code's process gate, C3 turn 1** (a blocking `[spec]`/`[contract]`/`[verify]`
gate the baseline never applies). Elsewhere the delta is thin: **architecting-software
A1/A2** baselines already name every violation and already refuse the over-abstraction, so
the skill only adds tags and an ADR pointer; **D2** triggers correctly but produces the same
question-list the baseline produces; the **intensity dial** produces a visible difference but
**lite under-delivers its own spec**. Two cases are confounded by the harness (C2 and C3
turn 2 stall on an empty workspace / a spec file that was never written to disk).

## Results summary

| Skill | Case | Baseline (no skill) | Treatment | Triggered? | Grade | Uplift |
|---|---|---|---|---|---|---|
| designing-systems | D1-smart-parking | Strong prose design; surfaces constraints + scale range; but no formal constraint register and reflexively picks **Kafka + Kubernetes**; writes no files | Full 10-doc `docs/design/` set; formal Constraint Register + capacity estimate; building-block table; **rejects Kafka/K8s with msg/s numbers**; scoped turn-2 payment revision (6 files touched, 4 untouched) | ✅ auto — wrote `docs/design/` incl. constraint register | ✅ **Pass** | **Yes** (moderate) |
| designing-systems | D2-trigger-wearable | Reframes as a system; asks 5 constraint Qs (connectivity, FDA, positioning, battery); phases work | Triggers on hardware framing; 5 constraint Qs incl. named regs + "Constraint Register" + labeled default assumptions; **no docs, no design produced** | ✅ auto — fired on "build the product" framing | ✅ **Pass** (on its trigger-focused rubric) | **No / marginal** |
| architecting-software | A1-clean-arch-review | Names all 3 Dependency-Rule violations, recommends `PaymentGateway` + `OrderRepository` ports, flags untestable-without-DB/Stripe, catches the commit-ordering bug **+ extras** | Same findings, tagged `[depend][boundary][testable]`, ADR pointer, "Suggested shape"; turn-2 scoped interfaces+refactor | ✅ auto — tags present | ✅ **Pass** | **No / marginal** (tags only) |
| architecting-software | A2-restraint | Clean "No, YAGNI"; one caller/one backend; gives the escape hatch; keeps as-is | "No" citing `[boundary]` "real, present variation or named volatile dependency" + crafting-code `[yagni]`; keeps as-is | ⚠️ **Unconfirmed** — trigger output has no tags, indistinguishable from baseline | ✅ **Pass** | **No** |
| crafting-code | C1-simplify | Caught over-eng + YAGNI + O(n²), recommended collapse — but a **set-loop**, never `dict.fromkeys` | Walked ladder `[yagni][stdlib][shrink][name][test]`; reached `list(dict.fromkeys(...))` | ✅ auto — tags + reached the one-liner | ✅ **Pass** | **Yes** (modest — one rung) |
| crafting-code | C2-intensity | n/a (no baseline) | ultra challenges scope (minimal registry vs heavier) + demands a spec; **lite only asks the stack** — neither builds nor notes the lazier alternative | n/a (prompt names skill) | ⚠️ **Partial** | n/a |
| crafting-code | C3-process-gate | Caught SQLi + IDOR + CSV bugs, gated "not done" — but **no blocking `[spec]` gate** | turn 1: full gate table, blocks on `[spec]`, catches SQLi+auth+CSV+404. turn 2: refuses to gate "done" because the spec file is absent, still requires fixes | n/a (prompt names skill) | ⚠️ **Partial** (turn 1 clear pass; turn 2 confounded) | **Yes** on turn 1 |

Grades that differ from the pre-filled `GRADING.md` first pass: **C2 → Partial** (lite fails
its own spec, not a clean Pass), **C3 → Partial** (turn-2 "accept spec and proceed" is never
demonstrated), and the uplift for **A1/A2/D2 is downgraded to No/marginal** with evidence.

---

## Per-skill findings

### designing-systems — the clearest earner, but D2 shows the baseline is already good

**Strength — formal, capacity-justified restraint (the standout moment).** The baseline
reflexively reaches for heavyweight infra: D1 baseline picks *"Backbone: Kafka (or Kinesis)"*
and *"Infra: Kubernetes/ECS"* with no capacity justification. Treatment does the opposite and
shows its work. From the building-block table in
`D1-smart-parking/out/treatment/docs/design/architecture.md`:

> Async / event-driven | Managed MQTT broker ... | **Kafka / event streaming platform** |
> Message volume (10–650 msg/s) doesn't justify Kafka's operational cost at this team size

> Compute / runtime | Containers on a managed orchestration/PaaS ... | **Kubernetes** | ...
> K8s's self-healing/scaling isn't needed at pilot QPS — revisit at citywide scale

This is the skill's *"Do not add a heavyweight block (Kafka, Kubernetes, microservices)
without a constraint that justifies its complexity"* directive firing correctly, backed by a
real back-of-envelope estimate (`requirements-summary.md`: *"~876k msgs/day ≈ 10 msg/s avg …
~11.5M msgs/day ≈ 133 msg/s avg"*). The baseline produced no such estimate. **This is the
single most defensible uplift in the whole suite.**

**Strength — the scoped revision (D1 turn 2) works.** Diffing turn-1 `docs/` against turn-2
`docs-after/`: **6 files changed** (architecture, component-inventory, requirements-summary,
quality-attributes, risks, index) and **4 left byte-identical** (product-brief,
data-and-ml-flow, next-phase-spec-backlog, review). The answer names exactly what it touched —
*"Everything else … the sensor/dashboard path, building-block choices unrelated to payment —
is untouched"* — and correctly upgraded payments to CP + `PCI-DSS SAQ A`. It located and
edited one element instead of regenerating the design (Must #5).

**Weakness — D2 shows little behavioral uplift; the base model already reframes a "product"
ask as a constrained system.** The whole premise of D2 is that a hardware/"build the product"
prompt should be pulled into system-design. But the **baseline already does this** without any
skill — `D2/out/baseline/turn1.txt` opens *"Building this well means threading together
several distinct systems …"* and asks about connectivity (*"BLE to a paired phone"* vs
*"Standalone cellular (LTE-M/NB-IoT + SIM)"*), FDA positioning, and phasing. The treatment
(`D2/out/treatment/turn1.txt`, 253 words, **no docs written**) asks a near-identical 5-question
set; its only real additions are naming specific standards (*"21 CFR 820 / IEC 62304 / IEC
60601"*) and the phrase *"Constraint Register."* So D2 confirms **triggering** but not much
else — and when forced (treatment), the skill still produced **zero artifacts**, unlike D1
which wrote ten. The differentiator was purely the prompt wording ("design the system" in D1
vs "help us build" in D2). A forced design skill that answers with only a question list is a
missed opportunity to show value.

### architecting-software — weakest uplift; the Sonnet baseline is already a strong Clean-Arch reviewer

**Weakness — A1 baseline already hits every Must.** The SUCCESS rubric's four Must findings
are all present in the **no-skill** run (`A1/out/baseline/turn1.txt`):

> `place_order.py` lives in `use_cases/` but imports `fastapi.HTTPException`, `stripe`, and the
> concrete `SessionLocal` directly. A use-case/domain layer should depend on abstractions (a
> `PaymentGateway` port, an `OrderRepository` port) … this function can't be unit tested
> without hitting Stripe and a real DB.

> Raising `HTTPException` from the use-case couples business logic to transport.

That is `[depend]`, `[boundary]`, `[testable]`, and the "translate at the boundary" point —
**all four**, plus the same two ports the treatment recommends, plus extra bugs the treatment
*omitted* (amount-in-cents, missing `stripe.error` handling, unclosed session, no idempotency
key). The treatment (`A1/out/treatment/turn1.txt`) is genuinely cleaner and tag-structured,
and its turn-2 (87 words, just the two interfaces + refactor) is nicely scoped — but it adds
**no substantive finding the baseline missed**. Per the definition of uplift, the baseline
already cleared the bar.

**Weakness — A2 baseline already refuses the over-abstraction.** `A2/out/baseline/turn1.txt`
opens *"No, don't add that yet — this is YAGNI territory"*, gives the escape hatch (*"If/when
you do get a second backend, the extraction is mechanical"*), and keeps the function as-is —
a clean pass on all three Musts with no skill. Treatment's only edge is citing the principle
by name (*"The `[boundary]` check requires real, present variation or a named volatile
dependency"*). Same conclusion, more traceable.

**Weakness — triggering is unverifiable for A2.** The `trigger` run
(`A2/out/trigger/turn1.txt`) uses **no tags** and reads identically to the baseline
(*"No — that would be over-engineering"*). The README says skill use is *"infer[red] from the
output shape (the artifacts and tags a skill produces)"* — but here there is no skill-shaped
signal, so `GRADING.md`'s confident *"✅ auto — refused the over-abstraction"* conflates
"gave the right answer" with "the skill fired." (A1 trigger, by contrast, does carry
`[depend][boundary][testable][scream]` tags, so its firing is confirmed.)

**Minor — a whiff of the very over-abstraction the skill forbids.** A1's `trigger` run adds a
`[scream]` finding recommending an `Order` entity *"If 'total calculation' is a business rule
(e.g. tax, discounts later)"* — a speculative "later," which sits in tension with the skill's
own minimalism clause. The treatment wisely dropped it. Worth guarding explicitly.

### crafting-code — the process gate is the real win; the ladder and the dial are partial

**Strength — the blocking process gate is genuine uplift (C3 turn 1).** The baseline
(`C3/out/baseline/turn1.txt`) reviews the code well (catches the SQL injection) but never
applies a *blocking* gate. The treatment (`C3/out/treatment/turn1.txt`) does, with a full
pass/fail table:

> **[spec]** ❌ | "Export report to CSV" is a new product feature. No `docs/specs/` entry
> exists … there's nothing scoping what "done" means

…and still catches the real defects (*"SQL injection … `f"SELECT * FROM reports WHERE id =
{report_id}"` interpolates the path param directly"*), so it doesn't merely wave the process
flag. That "no spec ⇒ not done" discipline is exactly what the baseline lacks. Clear uplift.

**Weakness — C3 turn 2 "accept the spec and proceed" is never demonstrated (harness bug).**
The follow-up asserts *"The approved spec is docs/specs/0007-csv-export.md"* — but the harness
never wrote that file into the temp workspace, so the treatment correctly refuses:
*"`docs/specs/0007-csv-export.md` doesn't exist anywhere on this filesystem … I can't gate
this as done on a spec I can't verify."* Faithful to the skill, but it means turn-2 Must #4
("accept the spec, re-run the gate on remaining items") is **untested** — and the baseline
turn 2 refuses on the same grounds, so there is no A/B signal on turn 2 at all.

**Weakness — C1 uplift is a single ladder rung.** The baseline already deletes the Strategy
hierarchy and applies YAGNI (*"this is speculative generality … YAGNI applies here"*) and
already fixes the O(n²). Its only miss is the final rung: it lands on a hand-rolled set-loop
and recommends *"the single function above"* — never `dict.fromkeys`. The treatment reaches
`list(dict.fromkeys(tags))` under `[stdlib]`. Real, but narrow. (Aside: the `trigger` run
tags the complexity fix `[efficiency]`, a tag **not defined** in SKILL.md — treatment uses the
correct `[shrink]`. Minor vocabulary drift.)

**Weakness — the intensity dial moves, but `lite` under-delivers its own spec (confirmed).**
The two runs *do* differ, which answers C2's core question. `ultra`
(`C2/out/treatment-prompt-ultra/turn1.txt`, 207 words) challenges scope before building —
*"Minimal (what I'd default to at ultra): an in-process registry … Heavier: dynamic loading …
Unless you have a concrete need for dynamic external loading … the minimal registry
satisfies"* — matching its spec. But `lite`
(`C2/out/treatment-prompt-lite/turn1.txt`, 58 words) does **neither** of its two required
things ("build as asked; note the lazier alternative"):

> Since this is greenfield, one quick question before I scaffold anything: what
> language/runtime should this be in …

It only asks for the stack. It doesn't build, and it never names the lazier alternative. Part
of this is a harness confound (the empty workspace legitimately blocks "what stack?"), but
`lite`'s spec is under-specified enough that the model defaulted to "ask a question and stop."
The dial is directionally real; `lite` is not yet actionable.

---

## Prioritized improvement suggestions

### crafting-code (SKILL.md)

1. **Make `lite` prescriptive so it can't collapse into "ask a question and stop."** Replace
   the table row `lite | Build as asked; note the lazier alternative.` with two mandatory,
   separable deliverables and an explicit "don't debate scope":
   > **lite** — Build *exactly and fully* what was asked; do **not** challenge scope. End with
   > a one-line `Simpler alternative: …` naming the lazier option you skipped (stdlib/native/
   > fewer files) — but ship the requested version. Ask only *blocking* clarifications (e.g.
   > unknown stack); never withhold the build to negotiate scope.

   And tighten `ultra` symmetrically: *"challenge the non-essential requirement **before**
   writing any code; build the minimum only once justified."* This gives each level a
   *do*/*don't* that the eval can distinguish even when the workspace is thin.
2. **Codify the "asserted-but-unreadable spec" behavior** (the treatment did the right thing
   ad hoc in C3 turn 2). Add to `[spec]`: *"If a spec is asserted but not present/readable at
   the given path, `[spec]` is **unmet** — say so; do not gate on a spec you can't read."*
3. **Fix tag drift.** Either add a complexity/perf tag or state that algorithmic complexity
   files under `[shrink]` (the `trigger` C1 run invented `[efficiency]`).

### architecting-software (SKILL.md)

4. **Give the skill a differentiator the base model doesn't already provide: a strict output
   contract.** Since Sonnet already finds the violations and the right ports (A1) and already
   refuses over-abstraction (A2), the skill's value has to be *traceable, reproducible
   structure*. Add a required finding format, e.g.:
   > Report each finding as `[tag] file:line — the violation — which layer imports inward —
   > the specific inversion`. For every `[boundary]`, emit a one-line ADR stub for `docs/adr/`.

   That produces an artifact the baseline demonstrably does not.
5. **Guard the skill against its own over-abstraction reflex.** Extend the minimalism clause to
   cover `[scream]`/entity extraction: *"Do not invent an entity for logic that is a one-line
   computation today (e.g. `sum(prices)`); extract only when a **named** rule (tax, discount)
   exists."* This directly addresses the speculative `Order`-entity `[scream]` finding in A1
   trigger.
6. **Reposition where it earns its keep.** On single-function reviews the base model is already
   strong; add a one-liner steering the skill toward cross-module structure (`[cycle]` import
   cycles, `[scream]` framework-shaped folder layout) where a single-file reviewer wouldn't
   catch the problem. (Pair with the new eval case in #11.)

### designing-systems (SKILL.md)

7. **Close the D2 gap: never answer a design-mode request with only a question list.** Add to
   the Operating Rules / Design Workflow:
   > Even when clarifying questions are warranted, produce a **first-pass Constraint Register
   > populated with explicit labeled assumptions** for every load-bearing constraint, and
   > attach the questions to it. Asking must *augment* a skeleton artifact, never replace it.

   This would have turned D2 treatment (253 words, no docs) into a visible uplift over the
   baseline's question list.
8. **Promote capacity estimation to a hard requirement for heavyweight-block decisions** (D1's
   best behavior — make it reliable, not incidental): *"Any heavyweight block (Kafka,
   Kubernetes, microservices, distributed SQL) that is accepted **or** rejected must cite a
   back-of-envelope number (msg/s, QPS, GB/day)."* D1 did this; make it mandatory.

### Eval suite (harness, cases, rubrics)

9. **Seed the workspace so "implement it" / "gate the spec" cases don't stall on emptiness.**
   For **C2**, drop a minimal project into the temp workspace (a `pyproject.toml`/`package.json`
   + one source file) so the agent actually *builds* and lite-vs-ultra build behavior is
   observable rather than both collapsing to "what stack?" For **C3**, actually write
   `docs/specs/0007-csv-export.md` before turn 2 — right now the turn-2 Must ("accept the spec
   and proceed") is untestable and both modes refuse.
10. **Stop inferring triggering from vibes.** A2's trigger output is indistinguishable from
    baseline, yet it's logged as "✅ auto." Adopt the README's own fallback by default: run
    `trigger` with `--output-format stream-json`, grep for the skill name, and record
    **"loaded: yes/no"** as a column separate from "produced skill-shaped output."
11. **Add cases where the base model is known to be weak — otherwise A1/A2 only prove
    non-regression.** For architecting-software, add a **multi-file repo** case with a real
    dependency `[cycle]` or a framework-shaped `[scream]` folder layout, where a single-function
    reviewer would miss the structural problem. For crafting-code, add a `[delete]` case (the
    right answer is reuse existing code) and a harder simplification the base model is more
    likely to keep.
12. **Repair the D1 turn-2 baseline** (known-truncated) — it is the *one* place a scoped-
    revision A/B could be measured, and right now the turn-2 uplift is asserted, not measured.
13. **Force `GRADING.md` to record uplift honestly.** Several first-pass rows credited the
    skill where the baseline already succeeded (A1 "fired", A2 "correct restraint") without
    noting the baseline did the same. Make an explicit "did baseline already clear this bar?"
    line mandatory per row.
