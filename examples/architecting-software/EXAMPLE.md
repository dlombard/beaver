# Example — architecting-software

**Skill:** `architecting-software` · **Grade scale:** see [../README.md](../README.md)

Paste the snippet and the prompt into a fresh session. The skill should trigger on its
own (a structure/architecture review request).

## Prompt

> Review this against our architecture standard.
>
> ```python
> # app/use_cases/place_order.py
> from fastapi import HTTPException
> import stripe
> from app.db import SessionLocal
>
> def place_order(user_id, items):
>     db = SessionLocal()
>     total = sum(i["price"] for i in items)
>     charge = stripe.Charge.create(amount=total, customer=user_id)
>     db.execute("INSERT INTO orders (user_id, total) VALUES (?, ?)", (user_id, total))
>     db.commit()
>     if not charge.paid:
>         raise HTTPException(status_code=402, detail="payment failed")
>     return {"status": "ok"}
> ```

## What the skill should do

Apply the Dependency Rule and report findings by tag. This use case sits in the core
but imports a web framework, a DB session, and a provider SDK directly — the exact
thing the standard exists to catch.

## Reference — what good looks like

- **[depend]** — the use case imports **FastAPI** (`HTTPException`), the **DB**
  (`SessionLocal`/raw SQL), and the **Stripe SDK**. Core code must not import
  frameworks, DB, or provider SDKs. Invert behind interfaces (DIP).
- **[boundary]** — **Stripe** is a volatile external used directly. Put it behind a
  `PaymentGateway` interface + adapter; the choice of Stripe is an **ADR**.
- **[testable]** — this can't be tested without a live DB and Stripe. Move both behind
  boundaries so the use case is unit-testable.
- **Concrete restructure**: define `OrderRepository` and `PaymentGateway` interfaces
  in the core; `place_order` depends on those abstractions and **returns a domain
  result** (raising `HTTPException` from the core leaks the framework inward — translate
  to HTTP in the controller/adapter). FastAPI and the Stripe/DB clients become
  outer-layer adapters.
- **Restraint**: introduce **only** these two boundaries (real, present volatility) —
  no speculative interfaces around things that don't vary (defer to `crafting-code`
  `[yagni]`).

## Rubric

**Must (all required to pass):**
1. Flags **[depend]** — framework + DB + provider SDK imported into core.
2. Flags **[boundary]** — Stripe used directly → interface + adapter + **ADR**.
3. Flags **[testable]** — untestable without live infra.
4. Recommends **named interfaces** (repository + payment gateway) with the use case
   depending on abstractions, and moving `HTTPException` **out of the core**.

**Failure signals (any ⇒ fail):**
- Concludes the code is fine / only cosmetic nits.
- Misses that a **provider SDK in the core** is the central problem.
- Recommends **speculative abstractions** everywhere (over-abstraction — the standard
  forbids boundaries around what doesn't vary).
- Suggests patterns with no tie to a concrete finding.

**Grade:** ✅ Pass = all Musts, no signals · ⚠️ Partial = catches [depend] + [boundary]
but misses the HTTPException-in-core or testability point · ❌ Fail = any signal.
