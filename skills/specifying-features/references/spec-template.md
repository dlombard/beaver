# Feature Spec Template

One file per feature. Every section present — write "None" or "Out of scope: <reason>"
rather than omitting a section silently.

## Header

- **Spec ID**: SPEC-<n> (stable — commits and tests reference it)
- **Feature**:
- **Status**: draft / in review / approved
- **Approval**: self-approved | awaiting human sign-off
- **Traces**: upstream requirement IDs (e.g. FR-3, NFR-1) — "none" if the project has no PRD/design
- **Last updated**:

## Summary

One paragraph: the behavior this slice ships, and for whom.

## Scope & Non-Goals

- **In scope**:
- **Out of scope** (explicit, with reason):

## Behavior

- **User story**: As a <user>, I want <behavior>, so that <outcome>.
- **Workflows**: step-by-step, including alternate paths.
- **States & transitions** (when stateful):

## Interface / Contract Delta

New or changed endpoints, commands, events, or signatures — method, path,
request/response shape, status codes. If the project keeps API contracts, name the
exact delta to apply to them.

## Data Changes

Schema/migrations, new fields, indexes, retention. "None" if none.

## Edge Cases & Error Behavior

One line each — cover or explicitly exclude every one:

- invalid input:
- authorization failure:
- duplicate request / idempotency:
- concurrency:
- limits & quotas:
- dependency failure:

## Acceptance Criteria

Every row executable — a check plus its expected result.

Name the execution environment for the checks (local/fakes, dev, staging, prod). A
criterion or Definition-of-Done item that needs a live system names which
environment it runs against; if that is unknown, it goes under Open Questions — it
cannot be silently deferred.

| ID | Given / When / Then | Check (command, test name, or walkthrough step) | Expected result |
| --- | --- | --- | --- |
| AC-1 |  |  |  |

## Definition of Done

Every item demonstrable by a command, a test run, or an observable artifact.

- [ ] All acceptance criteria pass (state the command that proves it)
- [ ] Tests added and green: `<command>`
- [ ] Lint / type checks clean: `<command>`
- [ ] Contract delta applied to the project's API docs (if it keeps them)
- [ ] Docs this change invalidates are updated in the same diff
- [ ] Manual walkthrough completed: <steps>

## Open Questions
