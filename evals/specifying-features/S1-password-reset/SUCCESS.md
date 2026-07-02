# Success Criteria — S1-password-reset (specifying-features)

**Prompt intent:** a plain feature request with no PRD — the spec must be derived
from the request plus a seeded repo README (stack, email helper, users table). The
classic failure this case probes: happy-path-only specs with unverifiable criteria.

## Baseline expectation (no skill)

A capable model writes a reasonable spec-ish document but typically: criteria without
executable checks ("user can reset password"), no explicit Definition of Done, thin
unhappy-path coverage (often misses user enumeration and token reuse), and no
approval/traceability header.

## Treatment success criteria

**Must (all required to pass):**

1. Every acceptance criterion has an **executable check and an expected result**
   (curl/test/walkthrough — no "works correctly").
2. **Unhappy paths** covered as criteria or explicit exclusions: token expiry, token
   reuse (single-use), and **no user enumeration** on unknown email (same response as
   known email).
3. A **contract delta** (endpoints, request/response shapes, status codes) and **data
   changes** (token storage with expiry + single-use semantics).
4. Ends with a **Definition of Done** where every item is demonstrable by a command,
   test, or observable artifact.
5. Header carries a **spec ID, traces (`none` — no PRD), and an explicit approval
   mode**; derived choices (token TTL, rate limits) are labeled assumptions.

**Failure signals (any ⇒ fail):**

- Happy-path-only spec.
- Vague criteria with no check ("reset works as expected").
- Writes the implementation (handler code, SQL bodies) instead of the contract.
- Bundles extra features (change email, MFA, magic-link login).
- No Definition of Done, or DoD items that can't be demonstrated.

## Triggering

The trigger question: does "Spec this feature" fire the skill without it being named?
Grade from `loaded-turn1.txt`.
