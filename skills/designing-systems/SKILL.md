---
name: designing-systems
description: >-
  Plan, review, or refine the high-level design and architecture of any non-trivial system, product, or platform — software, data/ML/AI, IoT/edge/embedded, or distributed/cyber-physical/hardware. Use whenever someone asks to design, architect, or structure a system, or to critique such a design — e.g. "design the system", "architect this", "how should we build X", "you're the principal engineer". Also use it FIRST when someone asks to build a new app, product, or service from scratch: scope and design it before implementing, even when the request says "build it end-to-end" — the design comes before the code. Works even when the domain sounds like hardware or a physical product. Produces decision-grade artifacts — constraint register, architecture, building-block selections, SRD seed, component inventory, data/ML flows, quality attributes, risks, and a next-phase spec/SRD backlog. Intensity lite | full. Does not write implementation code, a full SRD, feature specs, wireframes, or completion gates.
---

# Designing Systems

## Operating Rules

Use this skill to turn an idea into decision-grade high-level system design artifacts.

Select one mode:

- **design**: create artifacts from a project idea or brief.
- **review**: critique an existing artifact for gaps, vagueness, risk, and unverifiable claims.
- **refine**: revise an artifact using review findings or new constraints.

If the user does not specify a mode, use **design**.

### Intensity

Default **full**. Never relaxes the Constraint Register, building-block table, fact-check, SRD seed, or next-phase backlog.

| Level | When | Behavior |
|-------|------|----------|
| **lite** | User asks for a sketch, outline, first-pass, or names `lite`. | Write four files: `requirements-summary.md` (Constraint Register + SRD seed), `architecture.md` (building-block table + compact component map), `risks-and-assumptions.md`, `next-phase-spec-backlog.md`. Fold quality targets into the register/architecture. Skip `product-brief.md` and per-component H2s. If the system is AI/LLM, also write `data-and-ml-flow.md`. Do not withhold the design to negotiate scope. |
| **full** | Default — including "design the system", "principal engineer", "from scratch", or a greenfield build. | Complete artifact set in `references/templates.md`. |

**Applying review feedback.** After presenting a design, the user will often review it and reply with corrections rather than a formal review request. A small, localized correction — a wrong number, a wrong provider/API claim, a decision the user makes explicitly ("I choose X") — can be applied directly to the affected artifact(s) without re-entering this skill; re-verify the corrected fact per directive 3 and ripple it to every artifact that depended on it. Re-enter in **refine** mode instead when the change reopens a constraint or building-block trade-off, ripples across the architecture rather than a local fix, or changes scope — i.e. when it needs the same rigor as the original design pass, not just an edit.

**Ask clarifying questions** only when missing information materially changes architecture, scope, risk, security, data design, quality attributes, or downstream specification work. Ask at most 5. If the user wants momentum, proceed with explicit assumptions and mark them as assumptions. **Never answer a design request with questions alone** — always deliver a first-pass **Constraint Register** (unknowns filled by labeled assumptions) and an initial architecture draft *alongside* any questions, so the reply is a usable design, not a questionnaire.

### Core Directives

1. **Elicit constraints before architecting.** Drive the brief to an explicit **Constraint Register** (`references/constraints-rubric.md`): walk the taxonomy and record each load-bearing constraint (latency budget, scale, availability, consistency, cost, compliance, platform limits) as a measurable target or an explicit assumption / baseline-to-measure. Briefs state *what* to build but rarely the constraints that decide the design ("a Netflix-like app" omits "recommendations < 100 ms p95 for 50M users").
2. **Select building blocks deliberately.** Assemble the architecture from infrastructure primitives across layers — compute/runtime, traffic, storage/data, caching, async/event-driven, communication, coordination, resilience, observability (`references/building-blocks.md`). For each block the system needs, record the alternative considered and the constraint it serves. For any **heavyweight block** (Kafka/streaming, Kubernetes, a new datastore, microservices), cite a **back-of-the-envelope number** (peak QPS, msg/s, data volume, concurrency) that justifies **accepting or rejecting** it — never accept or reject one on vibes.
3. **Verify external facts before committing to them.** Any load-bearing claim about a specific external provider, product, or tool — an API limit, a feature's availability (e.g. "MongoDB Community supports vector search"), a current model/version name, pricing, or a compliance certification — must be checked against current official documentation (web research) before it appears in the Constraint Register, an ADR, or a building-block justification. Training memory is a fine starting hypothesis for which facts to check — it just isn't a substitute for checking them. Cite the source and the date checked (e.g. "verified 2026-07-07: <url>"). A fact that is genuinely undocumented gets labeled "not documented as of `<date>`" — distinct from "not checked." Facts about the user's own infrastructure — which environment a cluster or credential belongs to, what a URI in project config points at — cannot be verified from public documentation: confirm them with the user or record them as labeled assumptions in the Constraint Register and Risks, never as silent premises.
4. **Make the model first-class for AI/LLM systems.** When an LLM, generative model, embeddings, or an AI assistant/agent/copilot is part of the product, treat retrieval/grounding, context budget, generation orchestration, embeddings/vector storage, and the assistant's role(s) as first-class components (`references/ai-system-design.md`).
5. **Define only verifiable goals.** A valid goal names the behavior/outcome, the affected user/component/workflow, the measurable evidence, the milestone or design gate, and the validation method. Mark unknown numbers as assumption or baseline-to-measure.
6. **Conform to the host project's process.** Check for project docs (`CLAUDE.md`, `AGENTS.md`, an existing `docs/` layout) and project-specific skills, and write into that structure rather than imposing a generic one. Absent an existing layout, write the artifact set to `docs/design/` (the collection standard — decisions go to `docs/adr/`, specs to `docs/specs/`, full SRDs to `docs/srd/`, API contracts to `docs/api/`).
7. **Hand off later-phase work; do not draft it here.** Feature specs → invoke `beaver:specifying-features` once per slice, and only if the request asked for specs now. Service-level structure (ports, scream layout, dependency rule) → invoke `beaver:architecting-software` only if the request asked to structure or review the service now. A **full SRD** is next-phase — seed it here (directive 8); no skill in this collection writes the finished document.
8. **Seed the SRD; do not write it.** The Requirements Summary is the System Requirements Document *seed* (`references/srd-handoff.md`): system-level shalls (`SYS-n`) traced to the PRD (or labeled derived), the Constraint Register as the NFR core, external interfaces, draft allocation to components, and a qualification approach per requirement class. A full SRD (shall-level completeness, interface specs, environmental/safety, verification matrix) is later work — backlog **named section gaps**, never a single row "write the SRD". Feature specs are not a substitute for the SRD.

### Do NOT

- **Do not** commit to an architecture before the Constraint Register exists, or leave any load-bearing constraint silently undefined.
- **Do not** add a heavyweight block (Kafka, Kubernetes, microservices) without a constraint that justifies its complexity — or omit one a constraint demands (caching/CDN, a queue, replication).
- **Do not** state a provider/tool capability, limit, or version from training knowledge as though it were verified — check it against official docs or label it an assumption to verify.
- **Do not** draw the LLM as a single "transform" stage in an AI system.
- **Do not** invent vanity goals or fabricate numeric precision; a goal that cannot be tied to a user, business, operational, security, reliability, or delivery outcome is invalid.
- **Do not** silently substitute a generic artifact set when a project-specific skill or process should apply — surface it instead.
- **Do not** draft a full SRD, feature specs (edge cases, executable acceptance criteria, Definition of Done), or service-level Clean Architecture inline — seed / backlog / hand off per directives 7–8.
- **Do not** rewrite a PRD as `product-brief.md`. If a product definition exists, trace its requirement IDs and skip the brief.
- **Do not** dump the full 10-file set when intensity is **lite**.

## Reference Loading

- For **design** or **refine**, read `references/templates.md`.
- For eliciting constraints and the Constraint Register (scale, latency, availability, consistency, cost, compliance, capacity estimation), read `references/constraints-rubric.md`.
- For the SRD seed and what to backlog vs write, read `references/srd-handoff.md`.
- For selecting building blocks / infrastructure primitives (compute & runtime, containers/Kubernetes/serverless, load balancers/CDN/API gateway, database types, caching, queues/pub-sub/event streaming, coordination, resilience patterns, observability), read `references/building-blocks.md`.
- For LLM, generative, embedding, retrieval, or AI-assistant/agent systems, read `references/ai-system-design.md`.
- For SMART success criteria, read `references/smart-criteria-rubric.md`.
- For latency, throughput, job timing, freshness, or scale targets, read `references/performance-rubric.md`.
- For production readiness, read `references/production-readiness-checklist.md`.
- For **review** or the mandatory final review pass, read `references/review-rubric.md`.

## Design Workflow

1. Extract project intent: users, problem, workflows, constraints, assumptions, non-goals, platform, integrations, data sensitivity, expected scale, and delivery milestone. If the project already has a product definition (a PRD — check wherever it keeps docs), treat it as the source of truth for scope, **trace its `FR-*` / `NFR-*` IDs**, and **do not write `product-brief.md`**. No PRD: a Product Brief is in-scope at **full** intensity only.
2. Build the **Constraint Register** before architecting (see `references/constraints-rubric.md`): walk the constraint taxonomy (scale/load, performance, availability/reliability, consistency, security/privacy/compliance, cost, environment, operability, delivery), do back-of-the-envelope capacity estimation where a decision depends on scale, and record each constraint as a measurable target or an explicit assumption / baseline-to-measure. Surface the conflicts to resolve (e.g. CAP/PACELC, latency vs. consistency). The architecture in the next step must be justified against this register. Before a constraint or building-block choice hinges on a specific provider/tool's documented behavior, verify it per directive 3 rather than asserting it.
3. Produce the artifacts for the chosen intensity (`references/templates.md`). At **full**, that is:
   - Product Brief — only when no PRD exists
   - Requirements Summary (Constraint Register + **SRD seed** — see `references/srd-handoff.md`)
   - High-Level System Design (including the building-block selections per layer, justified against constraints — see `references/building-blocks.md`)
   - Component Inventory and Interaction Map
   - For AI/LLM systems: the assistant's role(s), the retrieval/grounding and generation-orchestration design, embeddings/vector storage, context budget, and end-to-end Data and ML Flow (see `references/ai-system-design.md`). Make these first-class components and storage, not just a flow appendix.
   - Quality Attributes
   - Risks and Assumptions
   - SMART Success Criteria
   - Next-Phase Specification Backlog (feature specs, **named SRD sections**, service-structure ADRs)
4. Select building blocks per layer (see `references/building-blocks.md`): walk compute/runtime, traffic/networking, storage & data stores, caching, async/event-driven, communication/API, coordination, distributed primitives (unique IDs/sequencers, counters, idempotency keys), resilience, and observability (metrics/monitoring, logging, tracing, alerting). Choose only the blocks the system needs, record each as a row (block chosen · alternative considered · constraint it serves), and resolve trade-off points (e.g. SQL vs NoSQL, sync vs async, cache vs consistency, orchestration vs choreography). This is distinct from domain decomposition in the next step — building blocks are the infrastructure substrate; components are the ownership boundaries that run on them.
5. Define components by ownership boundaries, not by implementation convenience. In `component-inventory.md` (**full**), start with a compact list or table of all components, then add an H2 detail section for each critical-path and highest-criticality component (summarize the rest in the table; full per-component specs are next-phase). For each detailed component, specify purpose, responsibilities, inputs, outputs, owned data, dependencies, failure modes, success criteria, and open specification questions. At **lite**, the compact map in `architecture.md` is enough.
6. Add performance budgets only where meaningful. Prefer practical targets such as p95 latency, throughput, concurrency, job completion windows, data freshness, cold-start time, or recovery time. Avoid fake precision.
7. Add production-readiness requirements for reliability, security, observability, deployment, rollback, data handling, operations, and documentation.
8. Seed the SRD in the Requirements Summary (`references/srd-handoff.md`). Identify remaining later-phase work as **named** backlog rows: full-SRD sections, feature specs, interface contracts, data schemas, diagrams, operational runbooks, validation strategy. If the request wants feature specs or service structure produced now, hand off per directive 7 — never draft them inline.
9. Run a review pass against the produced artifact. Fix clear gaps before presenting the final answer. If gaps remain because information is unknown, list them under Open Questions.

## Review Workflow

Review artifacts as a design-readiness gate, not as prose. Lead with a findings table (see `references/review-rubric.md`), ordered by severity.

Check for:

- unclear scope or missing non-goals
- a Product Brief that restates an existing PRD instead of tracing `FR-*` / `NFR-*`
- missing user workflows
- missing or undefined constraints — no Constraint Register, or load-bearing constraints (scale, latency budget, availability, consistency, cost, compliance, platform limits) left unstated, unquantified, or unjustified against the architecture (see `references/constraints-rubric.md`)
- missing SRD seed — no `SYS-n` system functions, no external-interface list, no qualification approach, or no traces to the PRD (see `references/srd-handoff.md`)
- next-phase backlog with a single vague "write the SRD" row instead of named SRD-section gaps
- missing, unjustified, or mismatched building-block choices (see `references/building-blocks.md`) — e.g. no caching/CDN where the latency budget demands it; no queue/stream where write spikes or decoupling are needed; the wrong database type for the access pattern; no replication/resilience patterns for the availability target; or heavyweight blocks (Kafka, Kubernetes, microservices) added without a constraint that justifies the complexity
- missing component boundaries
- hidden shared state or ownership conflicts
- vague requirements
- unmeasurable success criteria
- missing performance budgets where latency, throughput, freshness, or recovery matters
- missing security, privacy, reliability, observability, or deployment requirements
- for AI/LLM systems: LLM treated as a single stage; no retrieval/grounding layer; ignored context budget / long-context handling; missing embeddings or vector index in storage; no interactive loop, agentic surface, citations, or evaluation story (see `references/ai-system-design.md`)
- load-bearing provider/tool claims (API limits, feature availability, model/version names) stated without a cited source and verification date
- missing handoff items for the later specification phase (feature specs, SRD sections, service structure)

For each finding, state the issue, why it matters, and the specific change needed.
