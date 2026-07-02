# PRD Template

Use these sections when creating or refining a PRD. Keep entries concise, specific,
and traceable — downstream artifacts reference the IDs minted here.

## Header

- **Product**:
- **Status**: draft / in review / approved
- **Sources**: (idea, brief, conversation, prior docs)
- **Last updated**:

## Problem & Users

- **Problem**:
- **Target users / personas** (role, context, job to be done):
- **Today's alternative** (how they solve it now):
- **Value proposition**:

## Feature List

One row per feature — the completeness contract. IDs are permanent; never renumber,
mark dead rows `deprecated`.

| ID | Feature | Priority (MoSCoW) | Summary | Acceptance criteria |
| --- | --- | --- | --- | --- |
| FR-1 |  | Must / Should / Could / Won't |  | see stories below |

**Conscious excludes** (from `feature-completeness-checklist.md`):

| Category | Why excluded |
| --- | --- |

## User Stories & Acceptance Criteria

One block per Must and Should feature:

- **FR-x — <feature>**
  - **Story**: As a <user>, I want <behavior>, so that <outcome>.
  - **Acceptance criteria** (observable, product-level — no implementation):
    - Given <context>, when <action>, then <observable result>.

## Non-Functional Requirements

Measurable at the product level; system design deepens them into a Constraint Register.

| ID | Requirement | Target | Priority |
| --- | --- | --- | --- |
| NFR-1 |  |  |  |

## Success Metrics

| Metric | Target | Source | Time frame |
| --- | --- | --- | --- |

## Release Milestones

MVP = the Must set. Scope each milestone by feature ID.

| Milestone | Scope (feature IDs) | Target date / trigger |
| --- | --- | --- |

## Non-Goals

Explicit Won'ts, one-line reason each.

## Risks, Dependencies & Assumptions

- **Assumptions** (labeled):
- **Dependencies**:
- **Risks & mitigations**:

## Open Questions

## Traceability

Downstream artifacts — system design, feature specs, commits, tests, completion
reports — reference the FR/NFR IDs above. Additions get new IDs; nothing is renumbered.
