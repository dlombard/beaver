# Review Rubric

Use this rubric after drafting or when explicitly reviewing an artifact.

## Severity

- **Critical**: blocks design approval or creates major product, security, data, or reliability risk.
- **High**: likely causes specification rework, ambiguity, or unverifiable design decisions.
- **Medium**: weakens quality but can be resolved during implementation.
- **Low**: wording, organization, or minor coverage issue.

## Review Questions

- Does the artifact state the problem, users, workflows, scope, non-goals, and assumptions?
- Is there a Constraint Register, and are load-bearing constraints (scale/load, latency budget, availability, consistency, cost, compliance, platform limits) defined as measurable targets or explicit assumptions rather than omitted? (see `references/constraints-rubric.md`)
- Is the chosen architecture justified against those constraints (e.g. does the latency budget survive the network round trips it implies; is the CAP/PACELC trade-off stated)?
- Are the building-block choices per layer present and justified, not a defaulted generic stack? Check compute/runtime, traffic (LB/CDN/gateway), storage/data-store type vs access pattern, caching, async/eventing, communication, coordination, resilience, observability. (see `references/building-blocks.md`)
- Is each heavyweight block (Kafka, Kubernetes, microservices, extra datastores) tied to a constraint that justifies its complexity, and is any block a constraint demands (cache/CDN, queue, replication, resilience patterns) not missing?
- Are component boundaries based on ownership, data, contracts, and failure isolation?
- Does `component-inventory.md` start with a high-level list or table of all components before detailed sections?
- Are API, event, and data contracts explicit enough for implementation?
- Are security and privacy requirements present for sensitive data or privileged actions?
- Are reliability and failure-mode expectations defined?
- Are performance budgets included where timing, scale, freshness, or recovery matters?
- Are SMART criteria specific, measurable, achievable, relevant, and milestone/time-bound?
- Can the next specification phase proceed without guessing about scope, boundaries, interactions, data, risks, or quality targets?
- Are later validation needs, manual review points, observability expectations, and operational concerns identified?
- Are unknowns clearly separated from assumptions?

For AI/LLM systems (see `references/ai-system-design.md`):

- Is the assistant's role(s) named, or is "AI" left as one undefined box?
- Is there a retrieval/grounding layer, or does the design assume the model just "reads the data"?
- Is the model's context budget stated and the long-context problem handled (the model is not handed the raw full corpus)?
- Is generation an orchestrated chain (e.g. map-reduce) where input exceeds the window, not a single one-shot call?
- Are the embedding model and vector index present in the storage model?
- If conversational/agentic: are sessions/turns, streaming, tools, and side-effect bounds designed?
- Are grounding/citations and an evaluation story (retrieval + generation quality) present, even if deferred?

## Output Format

Lead with findings:

| Severity | Area | Finding | Required Change |
| --- | --- | --- | --- |
|  |  |  |  |

Then provide:

- **Blocking Questions**
- **Assumptions To Confirm**
- **Recommended Revisions**
- **Residual Risk**
