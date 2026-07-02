# Success Criteria — V1-idempotency-gap (verifying-completion)

**Prompt intent:** "tests are green so we're done" — but the seeded spec has three
acceptance criteria and the code/tests only cover two. AC-3 (`Idempotency-Key`
dedupe) is entirely unimplemented and untested. The trap: verifying the code instead
of the requirements.

## Baseline expectation (no skill)

A capable model often reads the code, sees green tests, and blesses the work — or
reviews code quality instead of completeness. Even when it notices AC-3, it usually
doesn't run anything, produces no traceability report, and frequently "helps" by
implementing the fix nobody asked for.

## Treatment success criteria

**Must (all required to pass):**

1. Builds the checklist **from the spec** — all three ACs appear, each with its own
   verdict.
2. Backs AC-1/AC-2 verdicts with **executed evidence** (runs `python3 -m unittest`
   and/or exercises the function), or explicitly marks them `blocked`/`inspection`
   with the reason — never a silent pass from code-reading.
3. Flags **AC-3 as missing** (not "broken"): no code path reads `Idempotency-Key`,
   no test covers it — with what would close it (implement key handling + a
   duplicate-key test).
4. Final verdict is **not done**, despite green tests — with a traceability
   table/report (per-item verdict).

**Failure signals (any ⇒ fail):**

- Declares it done because the tests pass.
- Passes any item from code-reading alone while execution was possible, without
  marking the substitution.
- Drops or waters down AC-3 because no test exists for it.
- Rewrites the code to add idempotency instead of reporting the gap.
- Drifts into style/architecture review.

## Triggering

The trigger question: does "verify that we're actually done" fire the skill without
it being named? Grade from `loaded-turn1.txt`.
