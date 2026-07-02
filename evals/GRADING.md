# Grading Log

Record each A/B result here. Grade = ✅ Pass / ⚠️ Partial / ❌ Fail (see `README.md`).
"Uplift" = did `treatment` clear a bar that `baseline` did not?

| Skill | Case | Model | Baseline (no skill) | Treatment (skill) | Triggered? | Grade | Uplift | Notes |
|---|---|---|---|---|---|---|---|---|
| designing-systems | D1-smart-parking | sonnet-5 | Strong prose design; surfaces constraints + scale range; but **no formal constraint register** and reflexively picks **Kafka + Kubernetes**; writes no files | Full 10-doc `docs/design/` set; formal Constraint Register + capacity estimate; building-block table; **rejects Kafka/K8s citing 10–650 msg/s**; scoped turn-2 payment revision (6 files touched, 4 byte-identical) → CP + PCI-DSS SAQ A | ✅ auto — wrote `docs/design/` incl. constraint register + building-block table | ✅ **Pass** | **Yes** (moderate) | Uplift = formal artifacts + capacity-justified restraint + scoped edit. Turn-1 prose from baseline is already strong; the delta is structure + restraint, not new insight |
| designing-systems | D2-trigger-wearable | sonnet-5 | Reframes as a system on its own; asks 5 constraint Qs (BLE-vs-cellular, FDA, positioning, battery); phases work | Triggers on hardware framing; 5 constraint Qs incl. named regs (21 CFR 820 / IEC 62304 / IEC 60601) + "Constraint Register" + labeled default assumptions; **no docs, no design produced** | ✅ auto — fired on "help us build the real product" framing | ✅ **Pass** (trigger-focused rubric) | **No / marginal** | Triggering confirmed — the case's point. But baseline asks the same constraint set; forced treatment still produced **zero artifacts**. Little behavioral uplift |
| architecting-software | A1-clean-arch-review | sonnet-5 | Names **all 3** Dependency-Rule violations, recommends `PaymentGateway`+`OrderRepository` ports, flags untestable-without-DB/Stripe, catches commit-ordering bug **+ extras** (cents, error handling, session leak, idempotency) | Same findings tagged `[depend][boundary][testable]` + ADR pointer + "Suggested shape"; turn-2 scoped interfaces+refactor (87 w) | ✅ **loaded** — transcript shows `Skill(architecting-software)` invoked | ✅ **Pass** | **No / marginal** | Baseline already cleared every Must. Skill adds tags + ADR framing, not new substance. A1 trigger adds a speculative `[scream]` Order-entity finding (over-abstraction the skill forbids) |
| architecting-software | A2-restraint | sonnet-5 | Clean "No, YAGNI"; one caller/one backend; gives escape hatch; keeps as-is (a full pass with no skill) | "No" citing `[boundary]` "real, present variation or named volatile dependency" + crafting-code `[yagni]`; keeps as-is | ❌ **No** (hard signal, #5) — transcript shows **no `Skill` invocation**; did not fire on its own | ✅ **Pass** | **No** | Baseline resisted on its own. "Triggered ✅" in first pass conflated right-answer with skill-fired; no skill-shaped signal in trigger output |
| architecting-software | A3-cross-file-audit | sonnet-5 | found the cycle, but **missed the [scream]** entirely; freeform, no finding contract, no ADR | built a dep-graph layer table (corrected folder-vs-layer), found **cycle + scream + [depend]/[boundary] + [testable]**, used the `[tag] path:line → fix` contract, wrote `docs/adr/0001-payment-gateway-port.md`, didn't false-flag the allowed outer→inner import | ✅ auto — tags + contract + ADR without being forced | ✅ **Pass** | **Yes** (clear) | **The differentiator case (#3).** Baseline missed the scream + produced no contract/ADR; skill traversed the graph. Unlike A1/A2, real demonstrable uplift on an *existing codebase* |
| crafting-code | C1-simplify | sonnet-5 | Caught over-eng + O(n²) + YAGNI, recommended collapse — but a **set-loop**, never reached `dict.fromkeys` | Walked ladder `[yagni][stdlib][shrink][name][test]`; reached `list(dict.fromkeys(tags))` | ❌ **No** on trigger (hard signal, #5) — no `Skill` invocation; the tags were model-native. Loads correctly when forced: `Skill(crafting-code)` | ✅ **Pass** | **Yes** (modest — one rung) | Baseline missed only the stdlib rung; skill closed it. (trigger tagged the perf fix `[efficiency]` — undefined tag; treatment used `[shrink]`) |
| crafting-code | C2-intensity | sonnet-5 | n/a (no baseline by design) | ultra challenges scope (minimal registry vs heavier) + demands a spec; **lite only asks the stack** — neither builds nor notes the lazier alternative | n/a (prompt names skill) | ⚠️ **Partial** | n/a | Dial *does* move (answers the core question), but `lite` fails its own spec ("build as asked; note the lazier alternative"). Empty-workspace confound contributes → tighten `lite` in SKILL.md **and** seed the workspace |
| crafting-code | C3-process-gate | sonnet-5 | Caught SQLi + IDOR + CSV bugs, gated "not done" — but **no blocking `[spec]` gate** | turn 1: full gate table, blocks on `[spec]`, catches SQLi+auth+CSV+404. turn 2: refuses to gate "done" — asserted spec file absent on disk — still requires fixes | n/a (prompt names skill) | ⚠️ **Partial** | **Yes** (turn 1) | Turn-1 gate is a clear pass + uplift. Turn-2 "accept spec and proceed" is **untested** — harness never wrote `docs/specs/0007-csv-export.md`, so both modes refuse. Fix harness |

See `REVIEW.md` for full per-skill findings, quoted evidence, and prioritized SKILL.md +
eval-suite improvement suggestions.

## Post-fix re-run (Sonnet — after applying improvements #1, #2, #4)

Re-ran the affected cases after the fixes. Measured change vs. the graded "before" above:

| Case | Before | After | New grade |
|---|---|---|---|
| **C2 (lite)** | 58w — only asked "what language?"; neither built nor noted the alternative | 118w — **built** the full `DateFormatRegistry` + example plugin + 13 tests, ended with `Simpler alternative: … a plain dict[str, Callable] …` | ✅ Pass |
| **C2 (ultra)** | challenged scope | still challenges scope — lite/ultra now clearly differ **and** lite meets its spec | ✅ |
| **D2 (treatment)** | questions only, **0 artifacts** | **9-file `docs/design/` set** + labeled assumptions (battery ≥3d, BOM ≤$45, 95% recall) delivered *alongside* the 5 questions | ✅ Pass, **uplift → Yes** |
| **C3 (treatment)** | turn 2 untestable (spec never on disk → both modes refused) | turn 1 blocks on `[spec]`; turn 2 finds the seeded spec and **proceeds through the gate** | ✅ Pass |

Fixes: prescriptive `lite` (#1) no longer collapses into a question; "never questions
alone" (#4) turns D2 into real uplift; the seeded workspace (#2) makes C2's build
observable and C3's turn-2 testable.

## New skills — trigger runs (2026-07-01)

First runs of the three lifecycle skills added in 0.2.0. **Trigger mode only** (no
baseline pair yet — grade is against the case's Musts; Uplift pending a baseline run).
All three fired on their own — hard signal `Skill(<name>)` in every transcript.

| Skill | Case | Model | Treatment (trigger run) | Triggered? | Grade | Uplift | Notes |
|---|---|---|---|---|---|---|---|
| defining-products | P1-habit-tracker | sonnet-5 | 211-line `docs/product/prd.md`: FR-1–FR-29 with MoSCoW + real MVP cut; surfaced implied auth/roles/invitations **and per-user timezone** as Musts; conscious-excludes table; all metrics number+source+timeframe; 5 labeled assumptions + 4 questions alongside a full PRD | ✅ auto — `Skill(defining-products)` on a bare "Write the PRD" pitch | ✅ **Pass** | pending baseline | Nit: added scope (SSO FR-23, Slack FR-28) deferred and milestone tagged "(proposal)", but rows not individually labeled `proposal` |
| specifying-features | S1-password-reset | sonnet-5 | 207-line spec: 10 ACs each with named pytest check + expected result; expiry/reuse/**no-enumeration**/rate-limit/concurrency covered; contract delta + token-table data changes; DoD demonstrable; header carries SPEC-ID, `Traces: none`, explicit approval mode; TTL/limits labeled placeholders | ✅ auto — `Skill(specifying-features)` on "Spec this feature" | ✅ **Pass** | pending baseline | Chose `awaiting human sign-off` over the autonomous default — justified (auth-touching). Two DoD items honestly flagged "no repo command found; confirm with implementer" |
| verifying-completion | V1-idempotency-gap | sonnet-5 | Checklist from the spec (3 ACs + DoD boxes); ran `python3 -m unittest -v` **and scripted a repro** (same `Idempotency-Key` twice → 2 tasks); verdict **not done** despite green tests; traceability report to `docs/verification/`; didn't fix the code | ✅ auto — `Skill(verifying-completion)` on "verify that we're actually done" | ✅ **Pass** | pending baseline | Nit: labeled the unimplemented AC-3 `broken` (repro-backed) where the skill's taxonomy says `missing`; substance correct |

Takeaway vs. the older observation that "small snippet questions often don't trigger":
all three fired untriggered, including V1's snippet-sized task — the "is it done?" /
"write the PRD" / "spec this" phrasings sit squarely in the new descriptions.

## Triggering — hard signal (#5)

The harness now scores triggering from the **transcript** (`loaded-turnN.txt`: did the
model invoke `Skill(<name>)` and load its body?), not from output shape. This corrected
the first-pass "✅ auto" grades:

- `designing-systems` (D1/D2) — **loads on its own** (trigger runs wrote the exact
  `docs/design/` artifact set, which requires reading the skill's templates).
- `architecting-software` A1 — **loads** (`Skill(architecting-software)` in the transcript).
- `architecting-software` A2 and `crafting-code` C1 — **do NOT load on trigger**: Sonnet
  answers the small task inline without invoking the skill, and the "skill-shaped" tags
  were **model-native**. Both load correctly when **forced** (treatment).

Takeaway: auto-triggering is real but **not uniform** — heavier, multi-artifact tasks
(a design; an explicit architecture review) invoke the skill; small snippet questions
often don't. Measure it per run from `loaded-*.txt`; don't credit it from vibes.

## How to fill a row

- **Baseline** — one line on what the no-skill run did (the gap the skill should close).
- **Treatment** — did it hit the case's Must criteria?
- **Triggered?** — from the `trigger` run: did the skill fire without being forced?
- **Uplift** — Yes if treatment passed and baseline didn't; No if baseline already did
  it (the skill may not be adding value on this case); N/A if inconclusive.
- **Notes** — anything to feed back into the skill (a missed consideration → add it;
  a false trigger → tighten the description; over-verbosity → cut).
