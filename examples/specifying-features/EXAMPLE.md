# Example — specifying-features

**Skill:** `specifying-features` · **Grade scale:** see [../README.md](../README.md)

Run in a fresh session. The skill should trigger on its own (a request to spec a
feature).

## Prompt

> Spec this feature for our existing task-manager web app (REST API, Postgres,
> email service already wired up): **password reset by email**. A user requests a
> reset link, receives an email, and sets a new password. There's no PRD — work from
> this.

## What the skill should do

Produce one implementable, verifiable spec: scope, the API contract delta, the data
changes, the unhappy paths, executable acceptance criteria, and an explicit
Definition of Done — deriving sensible scope from the request and labeling it as
assumptions (no PRD exists).

## Reference — what good looks like

- **Contract delta**: two endpoints (e.g. `POST /password-reset/request`,
  `POST /password-reset/confirm`) with request/response shapes and status codes.
- **Data changes**: a reset-token store with **expiry** and **single-use** semantics
  (hashed token, TTL, consumed-at).
- **Unhappy paths covered, not just the happy one**: expired token; reused token;
  unknown email → **same response as known email** (no user enumeration); rate
  limiting on requests; token invalidation on password change. Each is a criterion or
  an explicit out-of-scope line.
- **Executable acceptance criteria**: each row pairs Given/When/Then with a concrete
  check — a curl command or a named test — and its expected result (`POST
  /password-reset/confirm with an expired token → 400, password unchanged`), not
  "user can reset password successfully".
- **Definition of Done**: demonstrable items only — the test command, lint/type
  checks, the contract delta applied if the project keeps API docs.
- **Header discipline**: a stable spec ID; `Traces: none` (no PRD); approval mode
  stated (`self-approved` after the review pass, or awaiting sign-off); derived
  choices (token TTL, rate limit) labeled as assumptions.
- **One feature only** — no bundled "change email" or MFA; no implementation code.

## Rubric

**Must (all required to pass):**
1. Every acceptance criterion has an **executable check and an expected result**
   (curl/test/walkthrough — no "works correctly").
2. Covers the **unhappy paths**: token expiry, token reuse, and **no user
   enumeration** on unknown email (criterion or explicit exclusion each).
3. Specifies the **contract delta** (endpoints, shapes, status codes) and the **data
   changes** (token storage with expiry/single-use).
4. Ends with a **Definition of Done** where every item is demonstrable by a command,
   test, or observable artifact.
5. Header carries a **spec ID, traces, and an explicit approval mode**; derived scope
   (TTL, limits) is labeled as assumptions.

**Failure signals (any ⇒ fail):**
- Happy-path-only spec.
- Vague criteria with no check ("reset works as expected").
- Writes the implementation (handler code, SQL) instead of the contract.
- Bundles extra features (change email, MFA, magic-link login).
- No Definition of Done, or DoD items that can't be demonstrated.

**Grade:** ✅ Pass = all Musts, no signals · ⚠️ Partial = minor gaps only · ❌ Fail =
any Must missed or any signal present.
