# A1 — Clean Architecture violation review

Tests: triggering, correct findings, and sustaining a conversation (produce the
concrete refactor for a named element).

## Baseline expectation (no skill)

A competent model will likely spot *some* issues (Stripe hard to test, SQL inline), but
often as generic "consider dependency injection / add error handling" advice — and may
**over-abstract** (suggest repositories/factories everywhere) without the Dependency-Rule
framing, or miss that raising `HTTPException` from the core leaks the framework inward.

## Treatment success criteria

**Turn 1 — Must (findings by the standard's tags):**
1. **[depend]** — the core use case imports a framework (FastAPI `HTTPException`), the DB
   (`SessionLocal`/raw SQL), and a provider SDK (Stripe). Invert behind interfaces.
2. **[boundary]** — Stripe used directly → `PaymentGateway` interface + adapter; the
   choice is an ADR (`docs/adr/`).
3. **[testable]** — untestable without a live DB and Stripe.
4. Notes that raising `HTTPException` in the core is wrong (translate at the boundary),
   and does **not** over-abstract things that don't vary.

**Turn 2 (follow-up) — Must:**
5. Produces the **concrete refactor for the two named elements only**: a `PaymentGateway`
   and an `OrderRepository` interface, `place_order` depending on the abstractions and
   returning a domain result (no `HTTPException` in core). Scoped to what was asked.

**Failure signals:** "looks fine"; misses the provider-SDK-in-core problem; recommends
abstractions with no tie to a finding; blanket over-abstraction; on the follow-up,
re-lectures instead of showing the code.

**Uplift check:** did baseline already name the Dependency-Rule violations *and* stay
disciplined about not over-abstracting? Treatment should be sharper and tag-structured.
