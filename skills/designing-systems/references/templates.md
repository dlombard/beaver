# Artifact Templates

Use these sections when creating or refining a system design artifact. Keep content concise, specific, and suitable for later specification work.

## Contents

Multi-File Output Set · Index · Product Brief · Requirements Summary ·
High-Level System Design · Component Inventory · Data and ML / AI Flow ·
Quality Attributes · Risks and Assumptions · Next-Phase Specification Backlog · Review

## Multi-File Output Set

When writing artifacts to disk, write them to `docs/design/` — the standard location
for this skill collection (`docs/design/` for system design, `docs/adr/` for
decisions, `docs/specs/` for specs, `docs/api/` for API contracts). If the target
repo already uses a different documentation layout, conform to it instead. Use these
files:

- `index.md`: entry point and links to all artifacts.
- `product-brief.md`: project framing and product intent.
- `requirements-summary.md`: high-level functional and non-functional requirements, including the **Constraint Register** (see `references/constraints-rubric.md`).
- `architecture.md`: system context, components, interactions, data flow, and tradeoffs.
- `component-inventory.md`: high-level component boundaries and responsibilities.
- `data-and-ml-flow.md`: data, model, retrieval/grounding, context budget, generation orchestration, evaluation, monitoring, and feedback flow. Required for AI/LLM/assistant systems (see `references/ai-system-design.md`); otherwise mark "Not applicable".
- `quality-attributes.md`: reliability, security, privacy, observability, performance, scalability, cost, and operability targets.
- `risks-and-assumptions.md`: assumptions, open questions, risks, and mitigations.
- `next-phase-spec-backlog.md`: follow-up work for SRD, diagrams, schemas, contracts, detailed specs, and validation plans.
- `review.md`: final review pass and remaining gaps.

Keep artifact names stable so examples can be compared across runs.

## Index

- **Project**:
- **Prompt Source**:
- **Artifact List**:
- **Summary**:
- **Open Questions**:

## Product Brief

- **Project**:
- **Problem**:
- **Target Users**:
- **Primary Workflows**:
- **Value Proposition**:
- **MVP Scope**:
- **Non-Goals**:
- **Constraints**:
- **Assumptions**:
- **Success Metrics**:
- **Open Questions**:

## Requirements Summary

- **Functional Requirements**:
- **Non-Functional Requirements**:
- **Constraint Register** (see `references/constraints-rubric.md`): use the table below
- **Data Requirements**:

### Constraint Register

One row per load-bearing constraint. Mark unknowns as `assumption` or `baseline-to-measure` — never leave a load-bearing constraint blank.

| Operation / Scope | Constraint Type | Target (with metric + condition) | Status | Validation Method |
| --- | --- | --- | --- | --- |
|  | scale / latency / availability / consistency / durability / security / compliance / cost / environment | e.g. p95 < 100 ms at 50M users | given / assumption / baseline-to-measure |  |

Capacity estimate (only where a decision depends on scale): peak QPS (read/write), storage/retention, bandwidth, hot-set memory.

Key trade-offs to resolve: CAP choice under partition; PACELC latency-vs-consistency; other sensitivity / trade-off points.
- **Security and Privacy Requirements**:
- **Reliability Requirements**:
- **Performance Requirements**:
- **Operational Requirements**:
- **Compliance Requirements**:
- **Dependencies and Integrations**:
- **Open Specification Questions**:

## High-Level System Design

- **Architecture Summary**:
- **Component Map**:
- **Building-Block Selections** (see `references/building-blocks.md`): use the table below
- **Data Flow**:
- **API and Event Contracts**:
- **Storage Model**:
- **Authentication and Authorization**:
- **Background Jobs and Async Processing**:
- **Observability**:
- **Deployment Model**:
- **Failure Modes**:
- **Tradeoffs**:
- **Risks and Mitigations**:

### Building-Block Selections

One row per layer the system actually needs; omit layers it doesn't. Tie each choice to a constraint and name the rejected alternative (see `references/building-blocks.md`).

| Layer | Block Chosen | Alternative Considered | Constraint It Serves |
| --- | --- | --- | --- |
| Compute / runtime (bare metal / VM / container / K8s / serverless / PaaS) |  |  |  |
| Traffic (DNS / CDN / load balancer / API gateway / service mesh) |  |  |  |
| Storage / data store (relational / KV / document / wide-column / graph / time-series / search / vector / object) |  |  |  |
| Caching (layer + pattern) |  |  |  |
| Async / event-driven (queue / pub-sub / stream / event-sourcing / CQRS / saga) |  |  |  |
| Communication / API (REST / gRPC / GraphQL / WebSockets) |  |  |  |
| Coordination (consensus / lock / scheduler / config) |  |  |  |
| Distributed primitives (unique ID/sequencer / counters / idempotency keys / rate limiter) |  |  |  |
| Resilience (timeouts / retries+backoff / circuit breaker / rate limit / load shedding / degradation) |  |  |  |
| Observability (metrics/monitoring / logging / tracing / alerting on SLOs) |  |  |  |

## Component Inventory

Start with a high-level component list before detailed component sections. Keep this high-level; detailed component specs belong in the next phase.

### Component Summary

Use a table like this:

| Component | Primary Responsibility | Owns Data? | Key Dependencies | Criticality |
| --- | --- | --- | --- | --- |
|  |  | Yes / No / Partial |  | Critical / High / Medium / Low |

### Component Relationship Overview

- **Core Request Path**:
- **Async or Background Path**:
- **External Integration Path**:
- **Shared Data or State**:

### Detailed Component Entries

Use one `##` section for each critical-path or highest-criticality component after the summary; summarize the remaining components in the table above. Full per-component specs belong in the next phase.

- **Component**:
- **Purpose**:
- **Responsibilities**:
- **Boundary**:
- **Inputs**:
- **Outputs**:
- **Owned Data**:
- **Dependencies**:
- **Likely Public Contracts**:
- **Failure Modes**:
- **Security Considerations**:
- **Performance Considerations**:
- **SMART Success Criteria**:
- **Open Specification Questions**:

## Data and ML / AI Flow

Use this for AI/LLM/ML systems. If not applicable, state why. For LLM/assistant
systems, also read `references/ai-system-design.md` — the model is the spine of
the design, not a single stage.

- **Assistant Role(s)**: what the AI is (e.g. transformer / tutor / coach), MVP vs deferred
- **Data Sources**:
- **Ingestion and Preprocessing**:
- **Chunking and Indexing**: chunk boundaries, metadata/provenance carried, embedding model
- **Vector Index / Retrieval Store**: where it lives (and its place in the storage model)
- **Model, Provider, or Inference Boundary**: generation LLM, embedding model, others; on-device/hosted/hybrid
- **Context Construction and Budget**: per-turn token budget; how prompts stay within the window
- **Retrieval Flow**: query → embed → vector/keyword/hybrid retrieve → top-k → grounding
- **Generation Orchestration**: one-shot vs map-reduce/hierarchical for long input; streaming
- **Grounding and Citations**: how outputs trace back to sources / deep-link
- **Interactive Loop**: sessions, turns, history, streaming (if conversational)
- **Agentic Surface**: tools, orchestration loop, side-effect bounds (if the assistant acts)
- **Evaluation Strategy**: retrieval eval + generation eval (faithfulness/grounding); regression
- **Human Feedback Loop**:
- **Monitoring and Drift Signals**:
- **Privacy and Safety Concerns**: prompt injection from retrieved/user content, PII in prompts/logs
- **Latency, Cost, and Quality Tradeoffs**:
- **Open Specification Questions**:

## Quality Attributes

- **Reliability**:
- **Security**:
- **Privacy**:
- **Observability**:
- **Performance**:
- **Scalability**:
- **Cost**:
- **Operability**:
- **Maintainability**:
- **AI/LLM (when applicable)**: grounding/faithfulness, context budget (tokens/turn vs window), retrieval quality, token/inference cost or on-device latency, streaming time-to-first-token, prompt-injection/PII safety
- **SMART Success Criteria**:

## Risks and Assumptions

- **Assumptions**:
- **Open Questions**:
- **Product Risks**:
- **Technical Risks**:
- **Security and Privacy Risks**:
- **Data or ML Risks**:
- **Operational Risks**:
- **Mitigations**:

## Next-Phase Specification Backlog

Use this table shape.

| Area | Required Follow-Up | Why It Matters | Suggested Artifact | Priority |
| --- | --- | --- | --- | --- |
| SRD |  |  | Full SRD section |  |
| Diagram |  |  | System/context/component diagram |  |
| API |  |  | API contract |  |
| Data |  |  | Schema or data dictionary |  |
| Component |  |  | Detailed component spec |  |
| Security |  |  | Threat model or permission matrix |  |
| Performance |  |  | Performance validation plan |  |
| Operations |  |  | Runbook or deployment plan |  |

## Review

Use `references/review-rubric.md`.

- **Findings**:
- **Blocking Questions**:
- **Assumptions To Confirm**:
- **Recommended Revisions**:
- **Residual Risk**:
