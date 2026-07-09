---
name: crafting-code
description: >-
  A coding standard for what good code is. Apply while writing or changing any
  code. Defines the blocking process gate, the four quality pillars, SOLID
  triggers (SRP/OCP/LSP/ISP/DIP — when to apply each, not definitions), and the
  embedded ponytail simplicity ladder. Intensity: lite | full | ultra (simplicity
  pillar only).
---

## Intensity (simplicity pillar only)

Default **full**. Never relaxes the gate, error handling, security, or verification.

| Level | Behavior |
|-------|----------|
| lite  | Build the thing **fully as asked** — do **not** challenge scope or stop to interrogate the requirement. Then end with exactly one line: `Simpler alternative: <the lazier option>` (or `Simpler alternative: none`). Both deliverables are required. |
| full  | Enforce the ladder; stdlib & native before new code. |
| ultra | YAGNI extremist; challenge non-essential requirements first. |

## Process gate (blocking, pass/fail)

- **[spec]** A *product feature* needs an approved spec in `docs/specs/` that scopes the change. No spec ⇒ no feature. Exempt (no spec, but no new product-feature behavior): bug fixes, refactors, chores, docs, tests, agent skills/tooling, repo scaffolding/config.
- **[verify]** Every Definition-of-Done item is demonstrated — tests green, lint/types clean, manual steps done.
- **[contract]** An API change ships its OpenAPI doc (`docs/api/`) in the same diff, and the endpoint is curl-exercisable.
- **[sync]** A change that invalidates a design doc, spec, or API contract updates that document in the same diff — stale docs are a defect.
- **[reverse]** A hard-to-reverse (one-way-door) decision has an ADR in `docs/adr/`. Easy to undo → just code it.
- **[repeat]** Backend actions are runnable and re-runnable from curl/CLI, deterministic, idempotent where they should be. The app relies only on what the API exposes.
- **[secret]** No secrets, keys, signing material, or media added.
- **[commit]** The commit message references the spec — and the requirement IDs it implements, when the project tracks them.

## Four pillars (findings)

**Pragmatism** — [dry] one source of truth, no duplicated knowledge · [couple] low coupling, deps point inward, independently testable · [concern] transport ≠ logic ≠ storage; persistence behind an interface · [error] explicit handling, fail fast, nothing swallowed.

**Craft** — [srp] one responsibility (can't name it without "and" ⇒ split) · [name] intention-revealing names, consistent domain language, comments say *why* · [small] diff does one job; opportunistic cleanups flagged separately · [test] first-class, F.I.R.S.T., part of the change.

**Minimalism (ponytail)** — walk the ladder, stop at the first rung that works:

1. [yagni] Need to exist at all?
2. [delete] Already in the codebase? Reuse it.
3. [stdlib] Standard library solves it?
4. [native] Platform feature (CSS, HTML inputs, DB constraints) before code?
5. Already an installed dependency?
6. [shrink] One line / much smaller, same behavior?
7. Else: the minimum necessary code.

Deletion over addition; boring over clever. Mark deliberate shortcuts `// debt: <ceiling> — upgrade when <trigger>`.

**Never minimized away:** input/trust-boundary validation, data-loss-preventing error handling, security, accessibility, explicitly requested features.

## SOLID — triggers, not definitions

You know the five principles; these are the moments to reach for each. Apply only against *real, present* variation — never speculatively (defer to `[yagni]`; an unused abstraction is a defect, not craft). SOLID justifies structure only where the minimalism ladder above already agrees code is warranted.

- **[srp]** See the Craft pillar — one reason to change; split when naming it needs "and".
- **[ocp]** Editing the *same* if/switch chain a **third** time to add a case ⇒ make the variant a plugged-in type, not another branch. Not before the third — two cases are a conditional, not a hierarchy.
- **[lsp]** A subtype/implementation that throws on, no-ops, or narrows a method its base promises is the wrong hierarchy ⇒ prefer composition or a smaller interface. Strengthening preconditions or weakening postconditions in an override is the smell.
- **[isp]** An implementer forced to stub methods it doesn't use, or a caller pulling in a fat interface for one method ⇒ split the interface by client need.
- **[dip]** Depend on an interface you own, not a concrete framework/DB/SDK. Covered in depth by `architecting-software` `[depend]`/`[boundary]` — invert volatile deps behind a port; boundary choices get an ADR there.

## Attribution

Distilled from *The Pragmatic Programmer* (Hunt & Thomas) and *Clean Code* (Martin). Simplicity ladder, intensity dial, tags, and exemptions embedded from ponytail (MIT, © Dietrich Gebert — https://github.com/DietrichGebert/ponytail; see `LICENSE-ponytail`).
