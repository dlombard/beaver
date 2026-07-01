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
