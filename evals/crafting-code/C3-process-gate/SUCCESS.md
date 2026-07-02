# C3 — the process gate (blocking) + sustaining a conversation

Tests the skill's **process gate** (the blocking pass/fail checks) and whether it holds
the line, then proceeds once the missing piece is supplied.

## Baseline expectation (no skill)

A model will likely review the code (and hopefully catch the SQL injection), but will
**not** apply a blocking process gate — it won't say "no spec ⇒ no feature," and may
green-light merging.

## Treatment success criteria

**Turn 1 — Must:**
1. Applies the **gate** and **blocks**: a new *product feature* needs an approved spec in
   `docs/specs/` (**[spec]**) — none is referenced, so it's not "done."
2. Also catches the real defects regardless of the gate: **SQL injection** (f-string
   interpolation), missing auth, no error handling — i.e. it doesn't just wave the
   process flag, it reviews the code too.
3. Does **not** rubber-stamp "good to merge."

**Turn 2 (follow-up, spec now provided) — Must:**
_(The harness writes the approved `docs/specs/0007-csv-export.md` into the workspace
before turn 2 — see `seed-followup/` — so the model can verify the spec actually exists.)_
4. Accepts the spec and re-runs the gate on the remaining items (**[verify]**,
   **[contract]** OpenAPI for the endpoint, **[secret]**, **[commit]** references the
   spec), still requiring the injection fix before "done." Demonstrates it can carry
   the gate across turns.

**Failure signals:** approves the merge on turn 1; ignores the SQL injection; treats the
gate as optional; on turn 2, declares done without the code fixes.

**Uplift check:** baseline reviews code but skips the gate; treatment should add the
blocking spec/verify/contract discipline.
