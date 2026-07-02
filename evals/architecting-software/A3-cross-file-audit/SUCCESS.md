# A3 — cross-file architecture audit (the differentiator case)

Tests the thing single-snippet cases (A1/A2) can't: does the skill drive a **codebase-level
audit** — tracing imports across files — to find violations invisible in any one file? This
is where `architecting-software` should beat a strong baseline; if it doesn't, the skill has
little reason to exist.

The workspace is **seeded** with `./svc` (see `seed/`), a 6-file Python service. Each file
looks locally fine; the problems only appear in the dependency graph:

- **Cycle:** `services/orders_service.py` imports `services/billing_service.py`, which imports
  `services/orders_service.py` back (`mark_paid`). A→B→A across two files.
- **Boundary leak, split across files:** `use_cases/checkout.py` (a core app rule) imports
  `gateways/stripe_client.py`, which imports the `stripe` SDK directly — core → provider SDK,
  with no port. You only see it by following `checkout → stripe_client → import stripe`.
- **Scream:** top-level layout is by technical role (`controllers/ models/ services/ gateways/
  use_cases/`), not by domain (`orders/ billing/ checkout/`).
- **Testable:** `run_checkout`/`charge_for_order` can't be tested without Stripe.
- **Distractor (NOT a violation):** `billing_service.py` importing `use_cases/checkout.py` is
  outer→inner — allowed. A good reviewer must NOT flag it.

## Baseline expectation (no skill)

Given a whole repo (not a snippet), a strong model tends to review superficially — comment on
the direct Stripe use in the one file it happens to open, maybe the env-var key — and is
**likely to miss the cross-file cycle and the scream** because it doesn't systematically trace
imports.

## Treatment success criteria

**Must:**
1. **Actually traverses** — greps/reads imports across files and reasons over the dependency
   graph, not one file.
2. Finds the **[cycle]** `orders_service ↔ billing_service`.
3. Finds the **[scream]** technical-role layout; recommends organizing by domain.
4. Finds the **[depend]/[boundary]** `use_cases/checkout` → `gateways/stripe_client` → `stripe`
   (core → provider, no port); proposes a `PaymentGateway` port + adapter, and an **ADR stub**
   in `docs/adr/`.
5. Uses the **finding contract** (`[tag] path:line — problem → fix`) and gives a
   dependency-direction verdict.
6. Does **not** false-flag the allowed outer→inner import (`billing_service → checkout`).

**Failure signals:** reviews only one file; misses the cycle and/or the scream; recommends
speculative abstractions; flags the allowed outer→inner dependency; no traversal.

**Uplift check (the whole point):** did the baseline find the **cycle** and the **scream** on
its own? If not, treatment's traversal + contract is real, demonstrable uplift — unlike A1/A2,
which only proved non-regression.
