# SRD Handoff

This skill produces a **high-level design**, not a System Requirements Document
(SRD / SyRS). It **seeds** the SRD so the next phase can write one without guessing.

## Contents

What an SRD is · Seed checklist · Full SRD (backlog by section) · Do not

## What an SRD is (in this pipeline)

| Artifact | Answers | Owner |
|---|---|---|
| **PRD** | What to build, for whom, prioritized features (`FR-n` / `NFR-n`) | `defining-products` |
| **This design** | Constraints, building blocks, component ownership, quality attributes | `designing-systems` |
| **SRD seed** (in Requirements Summary) | What the *system* shall do/be — system functions, external interfaces, qualification approach, draft allocation | `designing-systems` (this pass) |
| **Full SRD** | Shall-level completeness: every system function, every external interface, environmental/safety/regulatory shalls, verification matrix | Next phase — **not** this skill, **not** `specifying-features` |
| **Feature spec** | One shippable slice: contracts, edge cases, executable ACs, Definition of Done | `specifying-features` |
| **Service structure** | Ports, layers, dependency rule | `architecting-software` |

An SRD is not a PRD rewrite, not an architecture doc, and not a pile of feature specs.
No skill in this collection writes the finished SRD; this one is responsible for
leaving a seed that a later SRD author (human or agent) can expand.

## Seed checklist (Requirements Summary)

For each item, one line is enough; `N/A because …` beats omission.

1. **Traces** — PRD `FR-*` / `NFR-*` this design implements. No PRD: `traces: none — derived from brief`; label derived scope as assumptions.
2. **System functions (`SYS-n`)** — system-level shalls, not user stories. Example: "SYS-4 — The system shall match an available courier to an accepted order within T." One `SYS-n` per distinct system capability. Trace each to an `FR-*` or mark `derived`. Do not fork IDs that contradict a published PRD — trace, don't renumber product features.
3. **External interfaces** — every actor the system talks to: humans, mobile/web, payments, maps, sensors, regulators, partner APIs. Name the interface and the unknown the full SRD must close (protocol, payload, SLA, failure model).
4. **NFRs** — do not rewrite them. The Constraint Register *is* the NFR core of the seed. Point to it.
5. **Qualification approach** — for each *class* of system requirement (function, performance, safety, security, interface), the kind of evidence that will verify it: test / analysis / inspection / demonstration. Not the test procedures.
6. **Draft allocation** — `SYS-n` → component. Unowned functions go to the backlog, not into a silent "TBD".

## Full SRD (backlog it by section)

Write **one backlog row per missing SRD section**, not a single "write the SRD" row.
Suggested default location: `docs/srd/` unless the host project already has one.

Typical remaining sections (include only those the seed did not already close):

| Backlog area | What still has to be specified | Suggested artifact |
|---|---|---|
| SRD · interfaces | I/O, protocols, data dictionary, error model per external interface | `docs/srd/interfaces.md` |
| SRD · environment | Operational conditions, power, connectivity, on-prem/cloud, device limits | `docs/srd/environment.md` |
| SRD · safety / security / regulatory | Shalls + the verification method for each | `docs/srd/assurance.md` |
| SRD · verification matrix | Every `SYS-*` (and NFR) → method + level | `docs/srd/verification-matrix.md` |
| SRD · attributes | Priority, allocation, verification method, PRD trace per shall | `docs/srd/` (or host layout) |
| SRD · boundary | Glossary + system-context drawing | `docs/srd/context.md` |

Feature-spec rows (`docs/specs/`, `specifying-features`) and service-structure rows
(`docs/adr/`, `architecting-software`) are **separate** from SRD rows.

## Do not

- **Do not** write the full SRD in this pass — even if the user asked for "the SRD". Deliver the seed and the named-section backlog; say what remains.
- **Do not** dump feature-level acceptance criteria into the seed. That is `specifying-features`.
- **Do not** treat a stack of feature specs as a substitute for the SRD.
- **Do not** mint `SYS-*` IDs that contradict published `FR-*` IDs — trace, don't fork.
- **Do not** leave the backlog's SRD area as a blank "Full SRD section" with no named gap.
