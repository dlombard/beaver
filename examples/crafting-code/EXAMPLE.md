# Example — crafting-code

**Skill:** `crafting-code` · **Grade scale:** see [../README.md](../README.md)

Paste the snippet and the prompt into a fresh session. The skill should trigger on its
own (a request to write/review code to a quality bar).

## Prompt

> Review this change against our code-quality standard. We're adding "dedupe a user's
> tag list, preserving order."
>
> ```python
> class TagDeduplicationStrategy:
>     def dedupe(self, items): ...
>
> class OrderPreservingDeduplicationStrategy(TagDeduplicationStrategy):
>     def dedupe(self, items):
>         seen = []
>         result = []
>         for i in items:
>             found = False
>             for s in seen:
>                 if s == i:
>                     found = True
>             if not found:
>                 seen.append(i)
>                 result.append(i)
>         return result
>
> class TagDeduplicator:
>     def __init__(self, strategy: TagDeduplicationStrategy):
>         self.strategy = strategy
>
>     def run(self, items):
>         return self.strategy.dedupe(items)
> ```

## What the skill should do

Walk the **simplicity ladder** and the quality pillars, and stop at the first rung that
works. This is a one-liner buried under a speculative strategy-pattern hierarchy.

## Reference — what good looks like

- **[yagni] / [delete]** — a strategy interface + subclass + wrapper class for **one**
  behavior with **one** implementation is speculative abstraction. Delete the hierarchy.
- **[stdlib] / [shrink]** — order-preserving dedupe is a **one-liner**:
  `list(dict.fromkeys(items))`. The hand-rolled `O(n²)` double loop is both slower and
  more code.
- **Result**: replace ~20 lines and three classes with one function
  (`def dedupe_tags(items): return list(dict.fromkeys(items))`) — deletion over
  addition, boring over clever.
- **Never minimized away**: if tags cross a trust boundary, keep input validation —
  simplicity doesn't strip validation, error handling, or security.
- **Process note**: if this is a new *product feature*, `[spec]` asks for an approved
  spec; a small internal helper/refactor is exempt.

## Rubric

**Must (all required to pass):**
1. Applies the **simplicity ladder** and identifies the **stdlib/one-line** solution
   (`dict.fromkeys`) — tags **[stdlib]** and/or **[shrink]**.
2. Flags the **speculative abstraction** (strategy interface + wrapper for a single
   impl) — tags **[yagni]/[delete]** and recommends removing it.
3. Gives a **concrete simpler version** (a single small function).

**Failure signals (any ⇒ fail):**
- Approves the code, or praises the strategy pattern as good extensibility.
- Adds **more** structure (e.g. a registry/factory) instead of removing it.
- Misses the stdlib/one-line solution.
- Strips genuinely necessary validation/error handling in the name of minimalism.

**Grade:** ✅ Pass = all Musts, no signals · ⚠️ Partial = simplifies the algorithm but
keeps the needless class hierarchy (or vice-versa) · ❌ Fail = any signal.

---

# Example B — applying SOLID (the other side of the tension)

Example A punishes speculative abstraction. This one checks the skill still *reaches for*
SOLID when the variation is **real and present** — an `[ocp]` trigger, not a `[yagni]` one.

## Prompt

> Review this change against our code-quality standard. We're adding a third notification
> channel, `push`, to the dispatcher — same as we did for `sms` last month.
>
> ```python
> def send(channel, user, message):
>     if channel == "email":
>         smtp.send(user.email, message)
>     elif channel == "sms":
>         twilio.send(user.phone, message)
>     elif channel == "push":            # the change: a third branch
>         fcm.send(user.device_token, message)
>     else:
>         raise ValueError(f"unknown channel {channel}")
> ```

## What the skill should do

This is the **third** edit to the *same* `if/elif` chain to add a case — the `[ocp]`
trigger fires (the plan's "not before the third"). Unlike Example A, the variation is
real, present, and actively growing, so extracting a plugged-in handler is warranted, not
speculative.

## Reference — what good looks like

- **[ocp]** — three real, actively-extended cases ⇒ replace the branch chain with a
  channel→handler mapping (a dict of small handlers keyed by channel), so a fourth
  channel is a new entry, not another `elif` edit to a growing function.
- **[isp]** — each handler needs only `send(user, message)`; keep that interface small
  rather than a fat `Notifier` with per-channel methods.
- **Not speculative** — this is distinct from Example A: OCP applies **because** there are
  already three concrete cases under active change, satisfying the minimalism ladder's
  "same code edited a third time" bar. A single channel would stay one function.
- **Never minimized away** — the `else` that rejects unknown channels is error handling;
  keep an equivalent guard (unknown key ⇒ raise) in the mapped version.

## Rubric

**Must (all required to pass):**
1. Fires **[ocp]** on the repeated branch-chain edit and recommends a channel→handler
   mapping (or equivalent polymorphic dispatch).
2. Justifies it as **real, present** variation (third case), explicitly *not* speculative —
   distinguishing it from a one-off `if`.
3. Preserves the unknown-channel guard (error handling not minimized away).

**Failure signals (any ⇒ fail):**
- Approves growing the `if/elif` chain unchanged.
- Extracts an abstraction but calls it speculative / cites `[yagni]` to reject it (misreads
  the trigger — there *is* present variation).
- Builds a fat multi-method interface or a registry/factory beyond the mapping needed.
- Drops the unknown-channel error path.

**Grade:** ✅ Pass = all Musts, no signals · ⚠️ Partial = extracts handlers but drops the
error guard or over-builds a registry · ❌ Fail = any signal.
