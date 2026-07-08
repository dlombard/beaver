---
name: specifying-features
description: >-
  Write an implementable, verifiable feature spec: scope and non-goals, interface and contract deltas, data changes, edge cases, executable acceptance criteria, and an explicit Definition of Done. Use when someone asks to spec a feature, write or review a spec, break a PRD, design, or backlog into specs — or when a feature is blocked pending an approved spec. One spec per shippable feature; consumes a PRD or system design when the project has one, but a plain feature request plus the codebase is enough. Does not do high-level system design and does not write the implementation code.
---

# Specifying Features

## Operating Rules

Use this skill to turn a feature into a spec precise enough that an agent can implement it without asking, and verifiable enough that "done" is a checklist, not an opinion.

Select one mode: **spec** (create, default) | **review** | **refine**. One spec per feature, scoped to a shippable slice — split anything bigger.

**Inputs, loosely coupled.** If the project has a product definition (PRD), system design, or spec backlog — check wherever it keeps documentation — consume them and reference their requirement IDs. None is required: a plain feature request plus the codebase is enough; label scope you derived yourself as assumptions.

### Core Directives

1. **"Done" is defined here.** Every spec ends with a **Definition of Done**: a checklist where every item is demonstrable by a command, a test run, or an observable artifact. An item that can't be demonstrated doesn't belong on it.
2. **Acceptance criteria are executable.** Each criterion pairs the behavior (Given/When/Then) with the exact check — the curl/CLI command, the test name, or the scripted walkthrough step — and its expected result. "Works correctly" is not a criterion.
3. **Spec the contract, not the implementation.** Interfaces and API deltas, data changes, error behavior, and limits are the spec's job; class design and algorithms belong to the implementer unless they are genuine constraints. If the project keeps API contracts, state the delta this feature makes to them.
4. **Cover the unhappy paths.** Invalid input, authorization failures, duplicates/idempotency, concurrency, limits and quotas, dependency failures — each gets a criterion or an explicit out-of-scope line. Happy-path-only specs are the main source of "works, but not as expected".
5. **Trace both ways.** Reference upstream requirement IDs when they exist; give the spec its own stable ID so commits and tests can reference it.
6. **Approval is explicit.** The spec header carries an approval mode: `self-approved` (it passed the review workflow below — the default when working autonomously) or `awaiting human sign-off` (when the user wants a checkpoint, or the feature is high-risk / hard to reverse). A spec is never silently "approved". This field is non-negotiable — if the project already has its own spec template (e.g. from a prior design pass) and that template has no approval field, extend it with one rather than dropping the directive to match the existing convention.

### Do NOT

- **Do not** bundle multiple features into one spec.
- **Do not** write a criterion whose evaluation needs human judgment when an observable check is possible.
- **Do not** restate PRD prose as the spec — specify behavior, contracts, and checks.
- **Do not** invent scope; label derived scope as an assumption.
- **Do not** write implementation code or pseudo-code the implementer should own.

## Reference Loading

- For the spec structure, read `references/spec-template.md`.

## Spec Workflow

1. Locate inputs (PRD, design, backlog, codebase — wherever they live) and pick the feature slice.
2. Fix scope and non-goals for this slice.
3. Specify behavior: workflows, interface/contract deltas, data changes, and every edge case from directive 4.
4. Write executable acceptance criteria, then the Definition of Done.
5. Run the review workflow below; fix gaps; set the approval state.
6. Write one file per feature into the project's spec location; absent a layout, default to `docs/specs/<id>-<slug>.md`. If the project already has a spec template or convention, follow its section names and file layout, but check it against `references/spec-template.md` first and add any required element it's missing — most commonly the **Approval** field (directive 6) or an executable-acceptance-criteria table — rather than silently inheriting a template that drops them.

## Review Workflow

Review a spec as an implementability-and-verifiability gate. Lead with findings, ordered by severity. Check for:

- scope an implementer could read two ways
- a criterion with no executable check or no expected result
- missing unhappy paths (walk directive 4's list)
- an API/interface change with no contract delta
- Definition of Done missing, or containing undemonstrable items
- multiple features bundled into one spec
- upstream requirements that exist but aren't referenced
- implementation prescribed where the implementer should choose
- a project-specific template followed as-is even though it's missing a required element from `references/spec-template.md` (approval field, acceptance criteria table, Definition of Done)

For each finding, state the issue, why it matters, and the specific change needed.
