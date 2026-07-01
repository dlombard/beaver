---
name: architecting-software
description: >-
  Clean Architecture standard (Robert C. Martin) for structuring a service so the domain stays independent of frameworks, DB, and providers. Use when designing a service, writing a spec/ADR, or reviewing/auditing the structure of new or existing code — including tracing an existing codebase's imports to find dependency-rule violations, cycles, and boundary leaks. For code-level craft, use crafting-code.
---

## The Dependency Rule

Source dependencies point inward only. Business rules never import a framework, DB, or provider SDK — those are replaceable details.

## Layers (inner → outer)

1. **Entities** — domain objects (`Order`, `LineItem`, `Invoice`).
2. **Use cases** — app rules (`PlaceOrder`, `GenerateInvoice`); orchestrate entities.
3. **Adapters** — controllers, gateways, repositories; translate in/out.
4. **Frameworks & drivers** — web framework, DB, third-party/provider SDKs, UI. Outermost, swappable.

The API and the UI are delivery mechanisms, not the core — every use case is also reachable from curl/CLI.

## Checks (findings)

- **[depend]** Core/use-case code imports a framework, DB, or provider SDK. Invert behind an interface (DIP).
- **[boundary]** A volatile external (third-party API, LLM, storage) is used directly. Put it behind an interface + adapter; the choice is an ADR (`docs/adr/`).
- **[cycle]** Modules depend on each other cyclically. Break it — keep dependencies acyclic.
- **[testable]** A use case can't be tested without infra running. Move the detail behind a boundary.
- **[scream]** Folder layout reflects the framework (controllers/models), not the domain (orders/billing/…). Organize by domain.
- **[defer]** A detail is baked into business rules, hard to swap. Keep it a plugin; significant/hard-to-reverse choices get an ADR (`docs/adr/`).

## Reviewing an existing codebase

Reviewing a repo is not the same as judging one snippet — the real violations live in the
**dependency graph** and are invisible in any single file. Trace it:

1. List the modules/packages; **grep the imports** to build the dependency graph.
2. Assign each module a layer (entity / use-case / adapter / framework-driver).
3. Flag every dependency that points **inner → outer** (core importing an adapter/SDK) → **[depend] / [boundary]**.
4. Follow import chains to find **cycles** (A→B→A), even across files → **[cycle]**.
5. Check the top-level layout screams the **domain**, not technical roles (controllers/models/services) → **[scream]**.
6. For each volatile external (DB, provider SDK, LLM), confirm a **port** sits between it and the core → **[boundary]**.

## Finding contract

Report each finding on one line, in this shape:

`[tag] path:line — <what's wrong> → <the inversion/fix>`

For every **[boundary]** finding, also write an ADR stub to `docs/adr/` (Status: Proposed;
Context = the offending dependency; Decision = the port + adapter). Close with a one-line
**dependency-direction verdict** (does every source dependency point inward? yes/no).

## Boundaries vs. minimalism

Add a boundary or interface only for *real, present* variation or a *named* volatile dependency — never speculatively. No abstraction around what doesn't change (defer to crafting-code `[yagni]`).

## Attribution

*Clean Architecture*, Robert C. Martin.
