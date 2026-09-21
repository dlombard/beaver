# D2 — triggering on a hardware/product-framed prompt

Tests **triggering** on a prompt that reads like a physical product, not "software" —
the exact failure mode the description was fixed for (see the solar-sensor run). This
is primarily a `trigger`-mode case.

## Baseline expectation (no skill)

Jumps straight into freehand advice (hardware choices, an app, a cloud backend) as a
conversational memo — no constraint register, no structured design process.

## Treatment / trigger success criteria

**Must:**
1. **Triggers on its own** in `trigger` mode — `designing-systems` fires despite the
   "wearable / product / breadboard" framing (no explicit "design the system" wording).
2. Treats it as a system-design task: surfaces the load-bearing constraints for this
   domain — **detection latency + reliability** (a missed fall is life-or-death; false
   alarms erode trust), **connectivity** (cellular/BLE-to-phone), **battery/power**,
   **on-device vs cloud** detection, privacy of health data.
3. Names the pilot→product scope and asks or labels assumptions.
4. Does **not** answer with questions alone: first-pass Constraint Register (labeled
   assumptions) + architecture draft alongside any questions. When artifacts are
   written, the requirements summary includes an **SRD seed** (system functions for
   detect / alert / notify; interfaces to wearable, caregiver phone, and any cloud
   path; qualification approach for missed-detection vs false-alarm).

**Failure signals:** does **not** trigger (has to be told to use the skill); or treats
it as pure hardware/firmware advice with no constraint elicitation; or invents fake
numbers; or questions with zero design artifacts; or writes a full SRD.

**Key comparison:** the whole point is trigger vs baseline — baseline *cannot* trigger
(no skill). Success = the skill fires here without prompting, and reframes a "product"
ask as a constrained system design.
