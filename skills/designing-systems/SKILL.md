---
name: designing-systems
description: Plan, review, or refine the high-level design and architecture of any non-trivial system, product, or platform — software, data/ML/AI, IoT/edge/embedded, or distributed/cyber-physical/hardware. Use whenever someone asks to design, architect, or structure a system, or to critique such a design — e.g. "design the system", "architect this", "how should we build X", "you're the principal engineer". Also use it FIRST when someone asks to build a new app, product, or service from scratch: scope and design it before implementing, even when the request says "build it end-to-end" — the design comes before the code. Works even when the domain sounds like hardware or a physical product. Produces decision-grade artifacts — product brief, constraint register, architecture, building-block selections, component inventory, data/ML flows, quality attributes, SMART criteria, risks, and a next-phase spec backlog. Does not write implementation code, full SRDs, detailed component specs, wireframes, or completion gates.
---

# Designing Systems

## Operating Rules

Use this skill to turn an idea into decision-grade high-level system design artifacts.

Select one mode:

- **design**: create artifacts from a project idea or brief.
- **review**: critique an existing artifact for gaps, vagueness, risk, and unverifiable claims.
- **refine**: revise an artifact using review findings or new constraints.

If the user does not specify a mode, use **design**.

**Ask clarifying questions** only when missing information materially changes architecture, scope, risk, security, data design, quality attributes, or downstream specification work. Ask at most 5. If the user wants momentum, proceed with explicit assumptions and mark them as assumptions. **Never answer a design request with questions alone** — always deliver a first-pass **Constraint Register** (unknowns filled by labeled assumptions) and an initial architecture draft *alongside* any questions, so the reply is a usable design, not a questionnaire.

### Core Directives

1. **Elicit constraints before architecting.** Drive the brief to an explicit **Constraint Register** (`references/constraints-rubric.md`): walk the taxonomy and record each load-bearing constraint (latency budget, scale, availability, consistency, cost, compliance, platform limits) as a measurable target or an explicit assumption / baseline-to-measure. Briefs state *what* to build but rarely the constraints that decide the design ("a Netflix-like app" omits "recommendations < 100 ms p95 for 50M users").
2. **Select building blocks deliberately.** Assemble the architecture from infrastructure primitives across layers — compute/runtime, traffic, storage/data, caching, async/event-driven, communication, coordination, resilience, observability (`references/building-blocks.md`). For each block the system needs, record the alternative considered and the constraint it serves. For any **heavyweight block** (Kafka/streaming, Kubernetes, a new datastore, microservices), cite a **back-of-the-envelope number** (peak QPS, msg/s, data volume, concurrency) that justifies **accepting or rejecting** it — never accept or reject one on vibes.
3. **Make the model first-class for AI/LLM systems.** When an LLM, generative model, embeddings, or an AI assistant/agent/copilot is part of the product, treat retrieval/grounding, context budget, generation orchestration, embeddings/vector storage, and the assistant's role(s) as first-class components (`references/ai-system-design.md`).
4. **Define only verifiable goals.** A valid goal names the behavior/outcome, the affected user/component/workflow, the measurable evidence, the milestone or design gate, and the validation method. Mark unknown numbers as assumption or baseline-to-measure.
5. **Conform to the host project's process.** Check for project docs (`CLAUDE.md`, `AGENTS.md`, an existing `docs/` layout) and project-specific skills, and write into that structure rather than imposing a generic one. Absent an existing layout, write the artifact set to `docs/design/` (the collection standard — decisions go to `docs/adr/`, specs to `docs/specs/`, API contracts to `docs/api/`).

### Do NOT

- **Do not** commit to an architecture before the Constraint Register exists, or leave any load-bearing constraint silently undefined.
- **Do not** add a heavyweight block (Kafka, Kubernetes, microservices) without a constraint that justifies its complexity — or omit one a constraint demands (caching/CDN, a queue, replication).
- **Do not** draw the LLM as a single "transform" stage in an AI system.
- **Do not** invent vanity goals or fabricate numeric precision; a goal that cannot be tied to a user, business, operational, security, reliability, or delivery outcome is invalid.
- **Do not** silently substitute a generic artifact set when a project-specific skill or process should apply — surface it instead.

## Reference Loading

- For **design** or **refine**, read `references/templates.md`.
- For eliciting constraints and the Constraint Register (scale, latency, availability, consistency, cost, compliance, capacity estimation), read `references/constraints-rubric.md`.
- For selecting building blocks / infrastructure primitives (compute & runtime, containers/Kubernetes/serverless, load balancers/CDN/API gateway, database types, caching, queues/pub-sub/event streaming, coordination, resilience patterns, observability), read `references/building-blocks.md`.
- For LLM, generative, embedding, retrieval, or AI-assistant/agent systems, read `references/ai-system-design.md`.
- For SMART success criteria, read `references/smart-criteria-rubric.md`.
- For latency, throughput, job timing, freshness, or scale targets, read `references/performance-rubric.md`.
- For production readiness, read `references/production-readiness-checklist.md`.
- For **review** or the mandatory final review pass, read `references/review-rubric.md`.

## Design Workflow

1. Extract project intent: users, problem, workflows, constraints, assumptions, non-goals, platform, integrations, data sensitivity, expected scale, and delivery milestone. If the project already has a product definition (a PRD or product brief — check wherever it keeps docs), treat it as the source of truth for scope and trace its requirement IDs instead of re-deriving product scope.
2. Build the **Constraint Register** before architecting (see `references/constraints-rubric.md`): walk the constraint taxonomy (scale/load, performance, availability/reliability, consistency, security/privacy/compliance, cost, environment, operability, delivery), do back-of-the-envelope capacity estimation where a decision depends on scale, and record each constraint as a measurable target or an explicit assumption / baseline-to-measure. Surface the conflicts to resolve (e.g. CAP/PACELC, latency vs. consistency). The architecture in the next step must be justified against this register.
3. Produce the core artifacts:
   - Product Brief
   - Requirements Summary (including the Constraint Register)
   - High-Level System Design (including the building-block selections per layer, justified against constraints — see `references/building-blocks.md`)
   - Component Inventory and Interaction Map
   - For AI/LLM systems: the assistant's role(s), the retrieval/grounding and generation-orchestration design, embeddings/vector storage, context budget, and end-to-end Data and ML Flow (see `references/ai-system-design.md`). Make these first-class components and storage, not just a flow appendix.
   - Quality Attributes
   - Risks and Assumptions
   - SMART Success Criteria
   - Next-Phase Specification Backlog
4. Select building blocks per layer (see `references/building-blocks.md`): walk compute/runtime, traffic/networking, storage & data stores, caching, async/event-driven, communication/API, coordination, distributed primitives (unique IDs/sequencers, counters, idempotency keys), resilience, and observability (metrics/monitoring, logging, tracing, alerting). Choose only the blocks the system needs, record each as a row (block chosen · alternative considered · constraint it serves), and resolve trade-off points (e.g. SQL vs NoSQL, sync vs async, cache vs consistency, orchestration vs choreography). This is distinct from domain decomposition in the next step — building blocks are the infrastructure substrate; components are the ownership boundaries that run on them.
5. Define components by ownership boundaries, not by implementation convenience. In `component-inventory.md`, start with a compact list or table of all components, then add an H2 detail section for each critical-path and highest-criticality component (summarize the rest in the table; full per-component specs are next-phase). For each detailed component, specify purpose, responsibilities, inputs, outputs, owned data, dependencies, failure modes, success criteria, and open specification questions.
6. Add performance budgets only where meaningful. Prefer practical targets such as p95 latency, throughput, concurrency, job completion windows, data freshness, cold-start time, or recovery time. Avoid fake precision.
7. Add production-readiness requirements for reliability, security, observability, deployment, rollback, data handling, operations, and documentation.
8. Identify what must be specified later: detailed SRD sections, interface contracts, data schemas, component specs, diagrams, operational runbooks, validation strategy, and delivery milestones.
9. Run a review pass against the produced artifact. Fix clear gaps before presenting the final answer. If gaps remain because information is unknown, list them under Open Questions.

## Review Workflow

Review artifacts as a design-readiness gate, not as prose. Lead with findings, ordered by severity.

Check for:

- unclear scope or missing non-goals
- missing user workflows
- missing or undefined constraints — no Constraint Register, or load-bearing constraints (scale, latency budget, availability, consistency, cost, compliance, platform limits) left unstated, unquantified, or unjustified against the architecture (see `references/constraints-rubric.md`)
- missing, unjustified, or mismatched building-block choices (see `references/building-blocks.md`) — e.g. no caching/CDN where the latency budget demands it; no queue/stream where write spikes or decoupling are needed; the wrong database type for the access pattern; no replication/resilience patterns for the availability target; or heavyweight blocks (Kafka, Kubernetes, microservices) added without a constraint that justifies the complexity
- missing component boundaries
- hidden shared state or ownership conflicts
- vague requirements
- unmeasurable success criteria
- missing performance budgets where latency, throughput, freshness, or recovery matters
- missing security, privacy, reliability, observability, or deployment requirements
- for AI/LLM systems: LLM treated as a single stage; no retrieval/grounding layer; ignored context budget / long-context handling; missing embeddings or vector index in storage; no interactive loop, agentic surface, citations, or evaluation story (see `references/ai-system-design.md`)
- missing handoff items for the later specification phase

For each finding, state the issue, why it matters, and the specific change needed.
