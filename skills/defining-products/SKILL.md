---
name: defining-products
description: >-
  Turn a product idea into a decision-grade PRD (Product Requirements Document): target users and problems, an enumerated feature list with priorities and stable requirement IDs, user stories with product-level acceptance criteria, measurable success metrics, release milestones, and explicit non-goals. Use when someone asks to write a PRD, define product requirements, scope an MVP, decide or prioritize what to build — or when starting a new app, product, or service: the product definition comes before system design. Also use it to review or refine an existing PRD. Does not design the system architecture or the UX/UI (no wireframes, no visual design), and does not write technical specs or implementation code.
---

# Defining Products

## Operating Rules

Use this skill to turn an idea into a PRD that downstream phases (system design, feature specs, implementation, completion verification) can trace back to. The PRD answers *what* to build, *for whom*, and *how success is judged* — not how it's engineered.

Select one mode:

- **define**: create a PRD from an idea, brief, or conversation.
- **review**: critique an existing PRD for gaps, unprioritized scope, and unverifiable criteria.
- **refine**: revise a PRD using review findings or new information.

If the user does not specify a mode, use **define**.

**Ask clarifying questions** only when the answer materially changes users, scope, priorities, or success metrics. Ask at most 5. **Never answer with questions alone** — always deliver a first-pass PRD with unknowns as labeled assumptions alongside any questions.

### Core Directives

1. **Enumerate the features — the list is the contract.** Every feature is a row with a stable ID, a priority, and acceptance criteria — not a prose paragraph. This list is what later phases check completeness against; a feature that isn't a row doesn't exist.
2. **Walk the completeness checklist** (`references/feature-completeness-checklist.md`). Briefs describe the differentiating features and forget the load-bearing ones (auth, account management, roles, admin, notifications, data export/deletion, billing). Make every category a conscious *include* or *exclude* — never an accidental omission.
3. **Mint stable requirement IDs** (`FR-1…`, `NFR-1…`). They are the traceability spine: specs, commits, tests, and completion reports reference them. Never renumber a published ID — deprecate it.
4. **Acceptance criteria are product-level and observable.** Behavior a user or tester can observe, not implementation ("the user receives the reset email within 2 minutes", not "the system uses a message queue"). Every Must-have gets at least one.
5. **Prioritize ruthlessly** (MoSCoW: Must / Should / Could / Won't). The MVP is the Must set. If everything is a Must, the prioritization failed — force the cut.
6. **Success metrics are measurable** — a number, a source, and a time frame. "Users love it" is not a metric; "40% of signups create a second project within 14 days, measured in product analytics" is.
7. **Stand alone, couple loosely.** Require no other artifact or skill. If the project already has product docs (check wherever it keeps documentation), refine those rather than duplicating them. Write output into the project's existing docs layout; absent one, default to `docs/product/prd.md`.

### Do NOT

- **Do not** design the architecture, data model, or tech stack — that is system design, a later phase.
- **Do not** design UX/UI, wireframes, or visual flows — the PRD states user-facing behavior, not its presentation.
- **Do not** silently invent scope that isn't in the idea or conversation — label additions as `proposal`.
- **Do not** leave a Must-have without acceptance criteria, or any feature without a priority.
- **Do not** write vanity metrics or unmeasurable success criteria.

## Reference Loading

- For the PRD structure, read `references/prd-template.md`.
- To catch forgotten features, read `references/feature-completeness-checklist.md`.

## Define Workflow

1. Extract intent: users, problem, jobs to be done, platform, business model, timeline, and what "winning" means. Record unknowns as labeled assumptions.
2. Enumerate features: walk the completeness checklist, assign each feature an ID and a MoSCoW priority, and record explicit excludes with a one-line reason.
3. Write user stories and acceptance criteria for every Must and Should.
4. State non-goals and out-of-scope explicitly — the Won't list is as load-bearing as the Must list.
5. Define success metrics and release milestones.
6. Record risks, dependencies, and open questions.
7. Run the review workflow below against the draft; fix clear gaps before presenting.

## Review Workflow

Review a PRD as a scope gate, not as prose. Lead with findings, ordered by severity. Check for:

- users or problem undefined, or defined only as demographics without a job to be done
- features described in prose instead of an enumerated, prioritized, ID'd list
- missing cross-cutting features (run the completeness checklist) with no conscious exclude
- acceptance criteria that are implementation-flavored, subjective, or absent for Must-haves
- everything marked Must — no real prioritization, no MVP boundary
- unmeasurable success metrics
- missing non-goals / Won't list
- scope invented beyond the stated idea without a `proposal` label
- missing milestones

For each finding, state the issue, why it matters, and the specific change needed.
